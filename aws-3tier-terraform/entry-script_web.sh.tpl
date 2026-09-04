#!/bin/bash
# Εκτελείται στο web EC2 instance την πρώτη φορά που ξεκινά μέσω Terraform user_data.
# Το script εγκαθιστά Nginx/Node.js, κατεβάζει το React web artifact από S3, κάνει build και ρυθμίζει reverse proxy προς το internal ALB.

# Σταματά το script σε λάθος και αποτυγχάνει αν λείπει μεταβλητή ή αποτύχει κομμάτι pipeline.
set -euo pipefail

# Ενημερώνει τα πακέτα του Amazon Linux 2023.
sudo dnf update -y
# Εγκαθιστά unzip, Nginx, Node.js και npm.
sudo dnf install -y unzip nginx nodejs npm

# Δημιουργεί φάκελο εφαρμογής στο EC2.
mkdir -p /opt/aws-3tier
# Μετακινείται στον φάκελο εργασίας.
cd /opt/aws-3tier

# Κατεβάζει το web artifact zip από το S3 bucket που περνά το Terraform στο template.
aws s3 cp "s3://${artifacts_bucket}/${web_artifact_s3_key}" web-tier.zip
# Αποσυμπιέζει το artifact και αντικαθιστά υπάρχοντα αρχεία αν υπάρχουν.
unzip -o web-tier.zip

# Μετακινείται στον φάκελο του web tier κώδικα.
cd /opt/aws-3tier/web-tier

# Εγκαθιστά ακριβώς τα dependencies του package-lock.json και κάνει production build.
npm ci
npm run build

# Καθαρίζει το default web root του Nginx.
rm -rf /usr/share/nginx/html/*
# Αντιγράφει τα build files της React εφαρμογής στο web root του Nginx.
cp -r build/* /usr/share/nginx/html/

# Δημιουργεί Nginx configuration για static frontend και reverse proxy προς το app tier μέσω internal ALB.
cat > /etc/nginx/conf.d/aws-3tier.conf <<'NGINX'
server {
    # Ο Nginx ακούει στην πόρτα 80 μέσα στο web EC2 instance.
    listen 80;
    # Δέχεται requests ανεξάρτητα από hostname.
    server_name _;

    # Endpoint health check για το public ALB target group.
    location = /health {
        return 200 "web healthy
";
        add_header Content-Type text/plain;
    }

    # Σερβίρει τη React single-page application.
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri /index.html;
    }

    # Προωθεί API calls στο internal ALB, το οποίο με τη σειρά του στέλνει traffic στο app tier.
    location /api/ {
        proxy_pass http://${internal_alb_dns_name}/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINX

# Αφαιρεί default Nginx config αν υπάρχει, χωρίς αποτυχία αν δεν υπάρχει.
rm -f /etc/nginx/conf.d/default.conf || true

# Ελέγχει ότι το Nginx configuration είναι συντακτικά σωστό.
nginx -t
# Ενεργοποιεί το Nginx ώστε να ξεκινά μετά από reboot.
systemctl enable nginx
# Κάνει restart το Nginx για να φορτωθεί το νέο configuration.
systemctl restart nginx
