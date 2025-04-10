#!/bin/bash

# Exit on any error
set -e

echo "🔄 Updating system packages..."
sudo yum update -y

echo "📦 Installing Apache (httpd)..."
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

echo "🛢 Installing MariaDB..."
sudo yum install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "⚙️ Installing PHP and required extensions..."
sudo yum install php php-mysqlnd -y
sudo systemctl restart httpd

echo "🔗 Linking /var/www to /home/ec2-user/environment..."
#ln -s /var/www/ /home/ec2-user/environment

# Option 1: Check and skip if exists
if [ ! -L /home/ec2-user/environment/www ]; then
    ln -s /var/www/ /home/ec2-user/environment/www
    echo "🔗 Symbolic link created successfully."
else
    echo "🔗 Symbolic link /home/ec2-user/environment/www already exists, skipping."
fi

echo "📁 Moving to web environment directory..."
cd /home/ec2-user/environment

echo "⬇️ Downloading setup.zip..."
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/03-lab-mod5-challenge-EC2/s3/setup.zip
unzip setup.zip

echo "⬇️ Downloading db.zip..."
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/03-lab-mod5-challenge-EC2/s3/db.zip
unzip db.zip

echo "⬇️ Downloading cafe.zip..."
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/03-lab-mod5-challenge-EC2/s3/cafe.zip
unzip cafe.zip -d /var/www/html/

echo "📦 Installing AWS SDK..."
cd /var/www/html/cafe/
wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.phar
unzip aws -d /var/www/html/cafe/
chmod -R +r /var/www/html/cafe/

echo "🚀 Running app setup scripts..."
cd /home/ec2-user/environment/setup/
./set-app-parameters.sh

cd /home/ec2-user/environment/db/
./set-root-password.sh
./create-db.sh

echo "🌐 Setting timezone in PHP config..."
sudo sed -i "2i date.timezone = \"America/New_York\" " /etc/php.ini

echo "🔄 Restarting Apache..."
sudo service httpd restart

echo "✅ Deployment complete! Your Cafe website is ready."
