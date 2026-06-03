#!/bin/bash
set -euxo pipefail

sudo dnf update -y
sudo dnf install -y unzip jq

# Install Node.js
sudo dnf install -y nodejs npm

# Install PM2
npm install -g pm2

mkdir -p /opt/aws-3tier
cd /opt/aws-3tier

aws s3 cp "s3://${artifacts_bucket}/${app_artifact_s3_key}" app-tier.zip
unzip -o app-tier.zip

cd /opt/aws-3tier/app-tier

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "${db_secret_arn}" \
  --region "${aws_region}" \
  --query SecretString \
  --output text)

DB_USERNAME=$(echo "$SECRET_JSON" | jq -r .username)
DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password)
DB_NAME=$(echo "$SECRET_JSON" | jq -r .dbname)

# Adjust this path after we inspect the repo file names.
# Common workshop file is often DbConfig.js or similar.
if [ -f "DbConfig.js" ]; then
  cat > DbConfig.js <<EOF
module.exports = {
  HOST: "${db_host}",
  USER: "$DB_USERNAME",
  PASSWORD: "$DB_PASSWORD",
  DB: "$DB_NAME"
};
EOF
fi

npm install

pm2 delete all || true
pm2 start index.js --name aws-3tier-app || pm2 start server.js --name aws-3tier-app || pm2 start app.js --name aws-3tier-app
pm2 startup systemd -u root --hp /root
pm2 save