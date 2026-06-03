#!/bin/bash
set -euxo pipefail

sudo dnf update -y
sudo dnf install -y unzip nginx nodejs npm

mkdir -p /opt/aws-3tier
cd /opt/aws-3tier

aws s3 cp "s3://${artifacts_bucket}/${web_artifact_s3_key}" web-tier.zip
unzip -o web-tier.zip

cd /opt/aws-3tier/web-tier

npm install

# If the React app needs an API URL at build time, we can inject it here.
# Many workshop versions use relative /api paths handled by nginx.
npm run build

rm -rf /usr/share/nginx/html/*
cp -r build/* /usr/share/nginx/html/

cat > /etc/nginx/conf.d/aws-3tier.conf <<'NGINX'
server {
    listen 80;
    server_name _;

    location = /health {
        return 200 "web healthy\n";
        add_header Content-Type text/plain;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri /index.html;
    }

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

rm -f /etc/nginx/conf.d/default.conf || true

nginx -t
systemctl enable nginx
systemctl restart nginx