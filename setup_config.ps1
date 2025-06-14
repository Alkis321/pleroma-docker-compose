# Set script to stop on error
$ErrorActionPreference = "Stop"

# Create config directory if it doesn't exist
if (!(Test-Path -Path "./config")) {
    New-Item -ItemType Directory -Path "./config" | Out-Null
}

# Create a temporary container to extract default configs
docker run --name pleroma-config-extractor -d pandentia/pleroma:latest sleep infinity
Start-Sleep -Seconds 5  # Allow container to start

# Copy files from container
docker cp pleroma-config-extractor:/pleroma/config/prod.secret.exs.example ./config/prod.secret.exs
docker cp pleroma-config-extractor:/pleroma/config/config.exs ./config/config.exs

# Remove the temporary container
docker rm -f pleroma-config-extractor

# Define replacements
$replacements = @{
    'username: "pleroma"' = 'username: System.get_env("DB_USER", "pleroma")'
    'password: "pleroma"' = 'password: System.get_env("DB_PASS", "awkward")'
    'database: "pleroma"' = 'database: System.get_env("DB_NAME", "pleroma")'
    'hostname: "localhost"' = 'hostname: System.get_env("DB_HOST", "pleroma-db")'
    'base_url: "http://localhost:4000"' = 'base_url: "https://#{System.get_env("DOMAIN", "social.mpampis.com")}"'
    'secret_key_base: ".*"' = 'secret_key_base: System.get_env("SECRET_KEY_BASE", "mBN26/ho5+wXpOMsRtqKrzM8el9qOeN/xoLy8SqmM/ojy7wkbzQY3UBWv2FNo87NVSs9d3M/otqyD7oJaorkPA==")'
    'name: "Pleroma"' = 'name: System.get_env("INSTANCE_NAME", "Dutchman")'
    'email: ".*"' = 'email: System.get_env("ADMIN_EMAIL", "pleroma+admin@example.com")'
    'notify_email: ".*"' = 'notify_email: System.get_env("NOTIFY_EMAIL", "pleroma+admin@example.com")'
}

# Read file, do replacements, and write back
(Get-Content ./config/prod.secret.exs) | ForEach-Object {
    $line = $_
    foreach ($pattern in $replacements.Keys) {
        $replacement = $replacements[$pattern]
        $line = [regex]::Replace($line, $pattern, $replacement)
    }
    $line
} | Set-Content ./config/prod.secret.exs

Write-Host "Configuration files extracted and modified!"
