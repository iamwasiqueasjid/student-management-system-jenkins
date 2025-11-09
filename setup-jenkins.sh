#!/bin/bash

# Jenkins and Docker Setup Script for AWS EC2 Ubuntu Instance
# This script automates the installation of Jenkins, Docker, and Docker Compose

set -e  # Exit on error

echo "=================================================="
echo "Jenkins CI/CD Setup for Student Management System"
echo "=================================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script as root. Run as ubuntu user."
    exit 1
fi

# Update system
echo "Step 1: Updating system packages..."
sudo apt update && sudo apt upgrade -y
print_success "System updated successfully"
echo ""

# Install Docker
echo "Step 2: Installing Docker..."
if command -v docker &> /dev/null; then
    print_info "Docker is already installed"
    docker --version
else
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo usermod -aG docker jenkins 2>/dev/null || true
    rm get-docker.sh
    print_success "Docker installed successfully"
fi
echo ""

# Install Docker Compose
echo "Step 3: Installing Docker Compose..."
if command -v docker-compose &> /dev/null; then
    print_info "Docker Compose is already installed"
    docker-compose --version
else
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed successfully"
fi
echo ""

# Install Java
echo "Step 4: Installing Java (OpenJDK 17)..."
if command -v java &> /dev/null; then
    print_info "Java is already installed"
    java -version
else
    sudo apt install -y openjdk-17-jdk
    print_success "Java installed successfully"
fi
echo ""

# Install Jenkins
echo "Step 5: Installing Jenkins..."
if command -v jenkins &> /dev/null || [ -f /usr/bin/jenkins ]; then
    print_info "Jenkins is already installed"
else
    # Add Jenkins repository key
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    
    # Add Jenkins repository
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    # Update and install Jenkins
    sudo apt update
    sudo apt install -y jenkins
    
    print_success "Jenkins installed successfully"
fi
echo ""

# Configure Jenkins user permissions
echo "Step 6: Configuring Jenkins permissions..."
sudo usermod -aG docker jenkins
print_success "Jenkins user added to docker group"
echo ""

# Start Jenkins
echo "Step 7: Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins
print_success "Jenkins service started and enabled"
echo ""

# Wait for Jenkins to start
echo "Step 8: Waiting for Jenkins to initialize..."
sleep 10
print_success "Jenkins initialized"
echo ""

# Get Jenkins initial password
echo "Step 9: Retrieving Jenkins initial password..."
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
    echo ""
    echo "=================================================="
    echo "JENKINS INITIAL ADMIN PASSWORD"
    echo "=================================================="
    echo -e "${GREEN}${JENKINS_PASSWORD}${NC}"
    echo "=================================================="
    echo ""
    print_info "Save this password! You'll need it to access Jenkins."
else
    print_error "Could not find Jenkins initial password. Jenkins may still be starting."
fi
echo ""

# Install additional tools
echo "Step 10: Installing additional utilities..."
sudo apt install -y git curl wget vim
print_success "Additional utilities installed"
echo ""

# Display versions
echo "=================================================="
echo "INSTALLATION SUMMARY"
echo "=================================================="
echo -n "Docker: "
docker --version
echo -n "Docker Compose: "
docker-compose --version || docker compose version
echo -n "Java: "
java -version 2>&1 | head -n 1
echo -n "Jenkins: "
sudo systemctl is-active jenkins && echo "Running" || echo "Not running"
echo "=================================================="
echo ""

# Get EC2 public IP
echo "Step 11: Getting EC2 instance information..."
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "Unable to fetch")
PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname || echo "Unable to fetch")
echo ""

# Display access information
echo "=================================================="
echo "ACCESS INFORMATION"
echo "=================================================="
echo "Jenkins URL (IP):  http://${PUBLIC_IP}:8080"
echo "Jenkins URL (DNS): http://${PUBLIC_DNS}:8080"
echo ""
echo "App URL (IP):      http://${PUBLIC_IP}:3000"
echo "App URL (DNS):     http://${PUBLIC_DNS}:3000"
echo "=================================================="
echo ""

# Display next steps
echo "=================================================="
echo "NEXT STEPS"
echo "=================================================="
print_info "1. Configure AWS Security Group to allow ports:"
echo "   - Port 8080 (Jenkins)"
echo "   - Port 3000 (Application)"
echo "   - Port 22 (SSH)"
echo ""
print_info "2. Access Jenkins at: http://${PUBLIC_DNS}:8080"
echo ""
print_info "3. Use the initial admin password shown above"
echo ""
print_info "4. Install suggested plugins + these additional ones:"
echo "   - Docker Pipeline"
echo "   - Docker Plugin"
echo "   - GitHub Integration"
echo ""
print_info "5. Create a new Pipeline job pointing to your GitHub repo"
echo ""
print_info "6. Add credentials in Jenkins for:"
echo "   - MONGODB_URI"
echo "   - NEXTAUTH_SECRET"
echo "   - JWT_SECRET"
echo "   - NEXTAUTH_URL"
echo ""
print_info "7. Run your first build!"
echo "=================================================="
echo ""

# Important notes
print_info "⚠️  IMPORTANT: You may need to log out and log back in for Docker permissions to take effect"
print_info "⚠️  Or simply restart Jenkins: sudo systemctl restart jenkins"
echo ""

print_success "Setup completed successfully! 🎉"
echo ""
echo "For detailed instructions, see JENKINS_SETUP.md"
echo "For quick reference, see QUICK_START.md"
