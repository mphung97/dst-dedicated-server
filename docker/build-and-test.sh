#!/bin/bash
# Docker build and validation script for DST Dedicated Server

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "DST Docker Build & Validation"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_prerequisite() {
    local cmd="$1"
    local name="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name found"
        return 0
    else
        echo -e "${RED}✗${NC} $name not found - install and try again"
        return 1
    fi
}

# Check prerequisites
echo "Checking prerequisites..."
all_ok=true

check_prerequisite "docker" "Docker" || all_ok=false
check_prerequisite "docker-compose" "Docker Compose" || all_ok=false

if [ "$all_ok" != true ]; then
    echo ""
    echo "Please install Docker and Docker Compose to proceed."
    exit 1
fi

echo ""
echo "=========================================="
echo "Building Docker image..."
echo "=========================================="
echo ""

# Build the image
if docker build -t dst-server:latest .; then
    echo -e "${GREEN}✓${NC} Image built successfully"
else
    echo -e "${RED}✗${NC} Image build failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "Image Information"
echo "=========================================="
docker images dst-server:latest --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.Created}}"

echo ""
echo "=========================================="
echo "Validation Results"
echo "=========================================="
echo ""

# Check required files exist
echo "Checking required files..."
files=(
    "Dockerfile"
    "docker-compose.yml"
    ".env.example"
    "docker/container-start.sh"
    "docker/config-helper.sh"
    "DOCKER_GUIDE.md"
)

all_files_ok=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file missing"
        all_files_ok=false
    fi
done

echo ""
echo "Checking Dockerfile configuration..."
if grep -q "EXPOSE 10999/udp 8765/tcp" Dockerfile; then
    echo -e "${GREEN}✓${NC} Ports exposed correctly"
else
    echo -e "${RED}✗${NC} Port configuration issue"
    all_files_ok=false
fi

if grep -q "HEALTHCHECK" Dockerfile; then
    echo -e "${GREEN}✓${NC} Health check configured"
else
    echo -e "${RED}✗${NC} Health check missing"
    all_files_ok=false
fi

echo ""
echo "Checking docker-compose configuration..."
if grep -q "depends_on:" docker-compose.yml; then
    echo -e "${GREEN}✓${NC} Service dependencies configured"
else
    echo -e "${RED}✗${NC} Service dependencies missing"
    all_files_ok=false
fi

if grep -q "volumes:" docker-compose.yml; then
    echo -e "${GREEN}✓${NC} Volume configuration present"
else
    echo -e "${RED}✗${NC} Volume configuration missing"
    all_files_ok=false
fi

echo ""
echo "=========================================="
if [ "$all_files_ok" = true ]; then
    echo -e "${GREEN}Build Validation PASSED${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Copy .env.example to .env"
    echo "2. Edit .env and add your CLUSTER_TOKEN"
    echo "3. Run: docker-compose up -d"
    echo "4. View logs: docker-compose logs -f"
else
    echo -e "${RED}Build Validation FAILED${NC}"
    echo "Please review the errors above."
    exit 1
fi

echo "=========================================="
