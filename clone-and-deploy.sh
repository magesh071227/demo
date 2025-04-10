#!/bin/bash

# Ask for the GitHub repository URL
read -p "Enter the GitHub repo URL to clone: " repo_url

# Extract the repo name from the URL
repo_name=$(basename "$repo_url" .git)

# Clone the repo
echo "🔄 Cloning the repository..."
git clone "$repo_url"

# Check if cloning was successful
if [ ! -d "$repo_name" ]; then
  echo "❌ Failed to clone the repository. Please check the URL."
  exit 1
fi

# Search for 'cafe' folder inside the repo
cafe_path=$(find "$repo_name" -type d -name "cafe" | head -n 1)

if [ -z "$cafe_path" ]; then
  echo "❌ 'cafe' folder not found inside the repository."
  exit 1
fi

# Move the 'cafe' folder to /var/www/html/
echo "📦 Moving 'cafe' folder to /var/www/html/ ..."
sudo mv "$cafe_path" /var/www/html/

echo "✅ Deployment complete! Cafe is now at /var/www/html/cafe"
