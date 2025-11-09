# Command Reference Sheet

Quick reference for all commands needed during setup and operation.

## 🔌 Connect to EC2

### From Windows PowerShell
```powershell
cd C:\Users\Work\Downloads
ssh -i "studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
```

### Or Use Helper Script
```powershell
cd "D:\CUI\7th Semester\Devops\Assignment-2\student-management-system"
.\ec2-helper.ps1
```

---

## 📦 Installation Commands (Run on EC2)

### Update System
```bash
sudo apt update
sudo apt upgrade -y
```

### Install Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

### Install Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Install Java
```bash
sudo apt install -y openjdk-17-jdk
```

### Install Jenkins
```bash
# Add Jenkins key and repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/services.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install -y jenkins
```

### Configure Permissions
```bash
sudo usermod -aG docker jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

---

## 🔑 Get Jenkins Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## 🐳 Docker Commands

### Basic Commands
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# List images
docker images

# View container logs
docker logs <container_name>
docker logs student-management-app
docker logs student-management-mongodb

# Stop container
docker stop <container_name>

# Remove container
docker rm <container_name>

# Remove image
docker rmi <image_name>

# Clean up system
docker system prune -a
docker system prune -f --volumes
```

### Docker Compose Commands
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs (all services)
docker-compose logs -f

# View logs (specific service)
docker-compose logs -f app
docker-compose logs -f mongodb

# Check service status
docker-compose ps

# Rebuild and start
docker-compose up -d --build

# Stop and remove volumes
docker-compose down -v
```

---

## 🔧 Jenkins Commands

### Service Management
```bash
# Start Jenkins
sudo systemctl start jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Check status
sudo systemctl status jenkins

# Enable auto-start
sudo systemctl enable jenkins

# Disable auto-start
sudo systemctl disable jenkins
```

### View Logs
```bash
# View Jenkins logs (follow)
sudo journalctl -u jenkins -f

# View last 100 lines
sudo journalctl -u jenkins -n 100

# View logs since today
sudo journalctl -u jenkins --since today
```

### Configuration Files
```bash
# Jenkins home directory
cd /var/lib/jenkins

# Jenkins config
sudo nano /etc/default/jenkins

# View Jenkins version
sudo cat /var/lib/jenkins/config.xml | grep version
```

---

## 🔍 Verification Commands

### Check Installations
```bash
# Docker version
docker --version

# Docker Compose version
docker-compose --version

# Java version
java -version

# Jenkins status
sudo systemctl status jenkins

# Check if ports are open
sudo netstat -tulpn | grep -E ':(8080|3000|27017)'
```

### Test Services
```bash
# Test Docker
docker run hello-world

# Test Docker permissions
docker ps

# Test MongoDB connection
docker-compose exec mongodb mongosh --eval "db.adminCommand('ping')"

# Test app endpoint
curl http://localhost:3000
curl http://localhost:8080
```

---

## 🌐 Network Commands

### Check Ports
```bash
# List all listening ports
sudo netstat -tulpn

# Check specific port
sudo lsof -i :8080
sudo lsof -i :3000
sudo lsof -i :27017

# Kill process on port
sudo kill -9 <PID>
```

### Get EC2 Information
```bash
# Public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Public hostname
curl http://169.254.169.254/latest/meta-data/public-hostname

# Private IP
curl http://169.254.169.254/latest/meta-data/local-ipv4
```

---

## 📁 File Management

### Transfer Files from Windows
```powershell
# Transfer single file
scp -i "C:\Users\Work\Downloads\studentjenkins.pem" "file.txt" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com:~/

# Transfer directory
scp -i "C:\Users\Work\Downloads\studentjenkins.pem" -r "folder" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com:~/
```

### On EC2
```bash
# Create directory
mkdir -p ~/student-management-system

# Navigate to directory
cd ~/student-management-system

# List files
ls -la

# View file contents
cat filename

# Edit file
nano filename
vim filename

# Make script executable
chmod +x script.sh

# Run script
./script.sh
```

---

## 🔐 Generate Secrets

```bash
# Generate random secret (base64)
openssl rand -base64 32

# Generate random hex
openssl rand -hex 32

# Generate UUID
uuidgen
```

---

## 📊 Monitoring Commands

### System Resources
```bash
# Disk usage
df -h

# Memory usage
free -h

# CPU usage
top
htop

# Running processes
ps aux | grep jenkins
ps aux | grep docker
```

### Docker Resources
```bash
# Docker disk usage
docker system df

# Docker stats (real-time)
docker stats

# Container resource usage
docker stats --no-stream
```

---

## 🐛 Troubleshooting Commands

### Jenkins Issues
```bash
# Restart Jenkins
sudo systemctl restart jenkins

# Check Jenkins logs
sudo journalctl -u jenkins -f

# Test Jenkins port
curl http://localhost:8080

# Check Jenkins process
ps aux | grep jenkins
```

### Docker Issues
```bash
# Restart Docker
sudo systemctl restart docker

# Check Docker logs
sudo journalctl -u docker -f

# Test Docker
docker run hello-world

# Remove all containers
docker rm -f $(docker ps -aq)

# Remove all images
docker rmi -f $(docker images -q)
```

### Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Apply changes (logout required)
newgrp docker

# Check group membership
groups
groups jenkins

# Fix file permissions
sudo chown -R jenkins:jenkins /var/lib/jenkins
```

### Network Issues
```bash
# Test connectivity
ping google.com

# Check DNS
nslookup google.com

# Test port connectivity
telnet localhost 8080
nc -zv localhost 8080

# Flush DNS cache
sudo systemd-resolve --flush-caches
```

---

## 🔄 Git Commands

### On EC2
```bash
# Clone repository
git clone https://github.com/iamwasiqueasjid/student-management-system-jenkins.git

# Navigate to repo
cd student-management-system-jenkins

# Check status
git status

# Pull latest changes
git pull origin main

# View commit history
git log --oneline -10
```

### On Local Machine
```powershell
# Add all changes
git add .

# Commit changes
git commit -m "Your message"

# Push to GitHub
git push origin main

# Check remote URL
git remote -v

# View status
git status
```

---

## 📋 Quick Copy-Paste Blocks

### Complete Installation (One Block)
```bash
sudo apt update && sudo apt upgrade -y && \
curl -fsSL https://get.docker.com -o get-docker.sh && \
sudo sh get-docker.sh && \
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose && \
sudo apt install -y openjdk-17-jdk && \
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null && \
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null && \
sudo apt update && \
sudo apt install -y jenkins && \
sudo usermod -aG docker $USER && \
sudo usermod -aG docker jenkins && \
sudo systemctl start jenkins && \
sudo systemctl enable jenkins && \
echo "Installation complete! Initial password:" && \
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Check Everything Is Running
```bash
echo "=== Docker ===" && docker --version && \
echo "=== Docker Compose ===" && docker-compose --version && \
echo "=== Java ===" && java -version && \
echo "=== Jenkins ===" && sudo systemctl status jenkins && \
echo "=== Containers ===" && docker ps && \
echo "=== Listening Ports ===" && sudo netstat -tulpn | grep -E ':(8080|3000|27017)'
```

### Complete Cleanup
```bash
docker-compose down -v && \
docker stop $(docker ps -aq) 2>/dev/null && \
docker rm $(docker ps -aq) 2>/dev/null && \
docker rmi $(docker images -q) 2>/dev/null && \
docker system prune -af --volumes
```

---

## 🌐 URLs to Remember

```
Jenkins:           http://ec2-98-81-246-105.compute-1.amazonaws.com:8080
Application:       http://ec2-98-81-246-105.compute-1.amazonaws.com:3000
GitHub Webhook:    http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/
Repository:        https://github.com/iamwasiqueasjid/student-management-system-jenkins
```

---

## 📱 Emergency Commands

### If Everything Breaks
```bash
# Nuclear option - restart everything
sudo systemctl restart jenkins
sudo systemctl restart docker
docker-compose down -v
docker system prune -af --volumes
sudo reboot
```

### If Jenkins Won't Start
```bash
sudo systemctl stop jenkins
sudo systemctl start jenkins
sudo journalctl -u jenkins -f
```

### If Docker Won't Start
```bash
sudo systemctl stop docker
sudo rm -rf /var/lib/docker/network
sudo systemctl start docker
```

---

## 💾 Backup Commands

### Backup Jenkins
```bash
sudo tar -czf jenkins-backup-$(date +%Y%m%d).tar.gz /var/lib/jenkins/
```

### Backup Docker Volumes
```bash
docker run --rm -v student-management-system_mongodb_data:/data -v $(pwd):/backup ubuntu tar czf /backup/mongodb-backup-$(date +%Y%m%d).tar.gz /data
```

---

## 🎯 Most Used Commands

```bash
# Connect to EC2
ssh -i "studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com

# Check containers
docker ps

# View app logs
docker-compose logs -f app

# Restart Jenkins
sudo systemctl restart jenkins

# Get Jenkins password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Rebuild everything
docker-compose down && docker-compose up -d --build
```

---

**Keep this file handy for quick reference!**
