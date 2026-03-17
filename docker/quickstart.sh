#!/bin/bash
# Quick-start setup for DST Docker deployment

set -e

echo "Don't Starve Together - Docker Quick Start Setup"
echo "================================================="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Creating .env from .env.example..."
    if [ ! -f ".env.example" ]; then
        echo "Error: .env.example not found"
        exit 1
    fi
    cp .env.example .env
    echo "Created .env - please edit it with your settings"
    echo ""
fi

# Check for CLUSTER_TOKEN
if ! grep -q "^CLUSTER_TOKEN=.*[a-zA-Z0-9_-]" .env && ! grep -q "^CLUSTER_TOKEN=your_" .env; then
    echo "⚠️  Warning: CLUSTER_TOKEN appears to not be set in .env"
    echo "Please set CLUSTER_TOKEN in .env before starting:"
    echo "  1. Visit https://accounts.klei.com/account/me"
    echo "  2. Copy your cluster token"
    echo "  3. Edit .env and set CLUSTER_TOKEN=<your_token>"
    echo ""
fi

# List configuration
echo "Current Configuration:"
echo "====================="
echo ""
grep -E "^[A-Z_]+=" .env | head -10
echo ""
echo "Full config: cat .env"
echo ""

# Prompt to continue
read -p "Continue with docker-compose up? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Starting services..."
    echo ""
    docker-compose up -d
    
    echo ""
    echo "✓ Services started in background"
    echo ""
    echo "Check status:"
    echo "  docker-compose ps"
    echo ""
    echo "View logs:"
    echo "  docker-compose logs -f"
    echo "  docker-compose logs -f master"
    echo "  docker-compose logs -f caves"
    echo ""
    echo "Stop services:"
    echo "  docker-compose down"
else
    echo "Setup cancelled"
    exit 1
fi
