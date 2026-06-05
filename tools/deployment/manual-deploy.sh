#!/bin/bash

# Manual deployment script for testing outside GitHub Actions
# This helps isolate whether the issue is with GitHub Actions or the deployment process itself

set -e

SERVER_HOST="ec2-3-148-13-216.us-east-2.compute.amazonaws.com"
SERVER_USER="ubuntu"
SITE_SOURCE="."

echo "🚀 Manual Deployment Script"
echo "=========================="
echo ""

# Check if we're in the right directory
if [ ! -f "mkdocs.yml" ]; then
    echo "❌ Error: mkdocs.yml not found. Please run this script from the repository root."
    exit 1
fi

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "❌ Error: SSH key not found at ~/.ssh/id_rsa"
    echo "Please ensure your SSH key is properly configured."
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Test SSH connection
echo "🔍 Testing SSH connection..."
if ssh -o ConnectTimeout=10 $SERVER_USER@$SERVER_HOST "echo 'SSH connection successful'"; then
    echo "✅ SSH connection successful"
else
    echo "❌ SSH connection failed"
    exit 1
fi
echo ""

# Create deployment archive
echo "📦 Creating deployment archive..."
tar -czf manual-deploy.tar.gz --exclude='.git' --exclude='*.tar.gz' --exclude='site' .
echo "✅ Archive created: $(ls -lh manual-deploy.tar.gz)"
echo ""

# Transfer archive
echo "📤 Transferring archive to server..."
if scp manual-deploy.tar.gz $SERVER_USER@$SERVER_HOST:/tmp/; then
    echo "✅ Transfer successful"
else
    echo "❌ Transfer failed"
    exit 1
fi
echo ""

# Deploy on server
echo "🔄 Deploying on server..."
ssh $SERVER_USER@$SERVER_HOST "
    set -e
    echo 'Starting deployment on server...'
    
    # Backup Orlando if exists
    if [ -d '/var/www/mkdocs/site/2025.1.ORL' ]; then
        sudo cp -r '/var/www/mkdocs/site/2025.1.ORL' '/tmp/orlando-backup-manual'
        echo 'Orlando backed up'
    fi
    
    # Create temp directory and extract
    mkdir -p /tmp/manual-deploy-temp
    cd /tmp/manual-deploy-temp
    tar -xzf /tmp/manual-deploy.tar.gz
    
    # Build site
    echo 'Building site...'
    python3 -m pip install --user -r requirements.txt
    ~/.local/bin/mkdocs build --clean
    
    # Deploy to final location
    sudo mkdir -p /var/www/mkdocs/site
    sudo cp -r site/* /var/www/mkdocs/site/
    
    # Restore Orlando
    if [ -d '/tmp/orlando-backup-manual' ]; then
        sudo cp -r '/tmp/orlando-backup-manual' '/var/www/mkdocs/site/2025.1.ORL'
        rm -rf /tmp/orlando-backup-manual
        echo 'Orlando restored'
    fi
    
    # Set permissions
    sudo chown -R www-data:www-data /var/www/mkdocs/site
    sudo chmod -R 755 /var/www/mkdocs/site
    
    # Reload nginx
    sudo systemctl reload nginx
    
    # Cleanup
    rm -rf /tmp/manual-deploy-temp /tmp/manual-deploy.tar.gz
    
    echo 'Manual deployment completed successfully'
"

# Cleanup local archive
rm -f manual-deploy.tar.gz

echo ""
echo "🎉 Manual deployment completed!"
echo "🌐 Site should be available at: http://$SERVER_HOST/"
echo ""
