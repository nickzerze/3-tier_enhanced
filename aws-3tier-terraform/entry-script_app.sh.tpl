#!/bin/bash
# Εκτελείται στο app EC2 instance την πρώτη φορά που ξεκινά μέσω Terraform user_data.
# Το script εγκαθιστά dependencies, κατεβάζει το app artifact από S3, παίρνει DB credentials από Secrets Manager και ξεκινά την εφαρμογή με PM2.

# Σταματά το script σε λάθος και αποτυγχάνει αν λείπει μεταβλητή ή αποτύχει κομμάτι pipeline.
# Δεν ενεργοποιείται xtrace, ώστε τα credentials του Secrets Manager να μη γραφτούν στα cloud-init logs.
set -euo pipefail

# Ενημερώνει τα πακέτα του Amazon Linux 2023.
sudo dnf update -y
# Εγκαθιστά unzip για αποσυμπίεση artifact και jq για ανάγνωση JSON secrets.
sudo dnf install -y unzip jq

# Εγκαθιστά Node.js και npm για να τρέξει η Node εφαρμογή του app tier.
sudo dnf install -y nodejs npm

# Εγκαθιστά το PM2 globally ώστε η Node εφαρμογή να τρέχει ως managed process.
npm install -g pm2

# Δημιουργεί φάκελο εφαρμογής στο EC2.
mkdir -p /opt/aws-3tier
# Μετακινείται στον φάκελο εργασίας.
cd /opt/aws-3tier

# Κατεβάζει το app artifact zip από το S3 bucket που περνά το Terraform στο template.
aws s3 cp "s3://${artifacts_bucket}/${app_artifact_s3_key}" app-tier.zip
# Αποσυμπιέζει το artifact και αντικαθιστά υπάρχοντα αρχεία αν υπάρχουν.
unzip -o app-tier.zip

# Μετακινείται στον φάκελο του app tier κώδικα.
cd /opt/aws-3tier/app-tier

# Διαβάζει από το AWS Secrets Manager το JSON με username/password/dbname της βάσης.
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "${db_secret_arn}" \
  --region "${aws_region}" \
  --query SecretString \
  --output text)

# Εξάγει τα στοιχεία σύνδεσης από το JSON secret.
DB_USERNAME=$(echo "$SECRET_JSON" | jq -r .username)
DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password)
DB_NAME=$(echo "$SECRET_JSON" | jq -r .dbname)

# Αν υπάρχει DbConfig.js, το ξαναγράφει ώστε η εφαρμογή να συνδεθεί στο RDS endpoint.
if [ -f "DbConfig.js" ]; then
  cat > DbConfig.js <<EOF
module.exports = Object.freeze({
  DB_HOST: "${db_host}",
  DB_USER: "$DB_USERNAME",
  DB_PWD: "$DB_PASSWORD",
  DB_DATABASE: "$DB_NAME"
});
EOF
  chmod 600 DbConfig.js
fi

unset SECRET_JSON DB_USERNAME DB_PASSWORD DB_NAME

# Εγκαθιστά ακριβώς τα dependencies του package-lock.json.
npm ci

# Διαγράφει παλιά PM2 processes αν υπάρχουν, χωρίς να αποτύχει το script αν δεν υπάρχουν.
pm2 delete all || true
# Ξεκινά την εφαρμογή δοκιμάζοντας συνηθισμένα entry files: index.js, server.js ή app.js.
pm2 start index.js --name aws-3tier-app || pm2 start server.js --name aws-3tier-app || pm2 start app.js --name aws-3tier-app
# Ρυθμίζει το PM2 να ξεκινά αυτόματα με systemd μετά από reboot.
pm2 startup systemd -u root --hp /root
# Αποθηκεύει την τρέχουσα PM2 process list για επανεκκίνηση μετά από reboot.
pm2 save
