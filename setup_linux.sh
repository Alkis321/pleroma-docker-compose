#!/bin/bash
set -e

# Create a temporary container to extract default configs
docker run --name pleroma-config-extractor -d pandentia/pleroma:latest sleep infinity
docker cp pleroma-config-extractor:/pleroma/config/prod.secret.exs.example ./config/prod.secret.exs
docker cp pleroma-config-extractor:/pleroma/config/config.exs ./config/config.exs
docker rm -f pleroma-config-extractor

# Modify the prod.secret.exs file with our environment variables
sed -i "s/username: \"pleroma\"/username: System.get_env(\"DB_USER\", \"pleroma\")/g" ./config/prod.secret.exs
sed -i "s/password: \"pleroma\"/password: System.get_env(\"DB_PASS\", \"awkward\")/g" ./config/prod.secret.exs
sed -i "s/database: \"pleroma\"/database: System.get_env(\"DB_NAME\", \"pleroma\")/g" ./config/prod.secret.exs
sed -i "s/hostname: \"localhost\"/hostname: System.get_env(\"DB_HOST\", \"pleroma-db\")/g" ./config/prod.secret.exs
sed -i "s/base_url: \"http:\/\/localhost:4000\"/base_url: \"https:\/\/\#{System.get_env(\"DOMAIN\", \"social.mpampis.com\")}\"/g" ./config/prod.secret.exs
sed -i "s/secret_key_base: \".*\"/secret_key_base: System.get_env(\"SECRET_KEY_BASE\", \"mBN26\/ho5+wXpOMsRtqKrzM8el9qOeN\/xoLy8SqmM\/ojy7wkbzQY3UBWv2FNo87NVSs9d3M\/otqyD7oJaorkPA==\")/g" ./config/prod.secret.exs
sed -i "s/name: \"Pleroma\"/name: System.get_env(\"INSTANCE_NAME\", \"Dutchman\")/g" ./config/prod.secret.exs
sed -i "s/email: \".*\"/email: System.get_env(\"ADMIN_EMAIL\", \"pleroma+admin@example.com\")/g" ./config/prod.secret.exs
sed -i "s/notify_email: \".*\"/notify_email: System.get_env(\"NOTIFY_EMAIL\", \"pleroma+admin@example.com\")/g" ./config/prod.secret.exs

echo "Configuration files extracted and modified!"