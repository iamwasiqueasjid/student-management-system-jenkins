# Jenkins CI/CD Pipeline - Quick Start Guide

This is a quick reference guide for setting up and running the Jenkins pipeline for the Student Management System.

## 🚀 Quick Start (5 Steps)

### 1️⃣ Connect to EC2
```bash
ssh -i "C:\Users\Work\Downloads\studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
```

### 2️⃣ Install Everything (Run this script)
```bash
# Run this entire script on your EC2 instance
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Java
sudo apt install -y openjdk-17-jdk

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins

# Configure permissions
sudo usermod -aG docker jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial password
echo "=== JENKINS INITIAL PASSWORD ==="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "================================"
```

### 3️⃣ Open Ports in AWS Security Group
- Port 8080 (Jenkins)
- Port 3000 (Application)
- Port 22 (SSH)

### 4️⃣ Setup Jenkins (via Browser)
1. Go to: `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080`
2. Enter the initial admin password
3. Install suggested plugins
4. Create admin user
5. Install these additional plugins:
   - Docker Pipeline
   - Docker Plugin
   - GitHub Integration

### 5️⃣ Create Pipeline Job
1. Click "New Item"
2. Name: `Student-Management-System`
3. Type: `Pipeline`
4. Under Pipeline:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `https://github.com/iamwasiqueasjid/student-management-system-jenkins.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
5. Save and click "Build Now"

---

## 🔐 Add Credentials (Important!)

Go to: `Manage Jenkins` → `Credentials` → `(global)` → `Add Credentials`

Add these 4 credentials as **Secret text**:

| ID | Secret Value |
|----|--------------|
| `MONGODB_URI` | `mongodb://root:password@mongodb:27017/student_management?authSource=admin` |
| `NEXTAUTH_SECRET` | Run: `openssl rand -base64 32` and paste result |
| `JWT_SECRET` | Run: `openssl rand -base64 32` and paste result |
| `NEXTAUTH_URL` | `http://ec2-98-81-246-105.compute-1.amazonaws.com:3000` |

---

## 📋 Pipeline Stages

The Jenkins pipeline will execute these stages:

1. **Checkout** - Fetch code from GitHub
2. **Setup Environment** - Verify Docker and dependencies
3. **Validate Dockerfile** - Check if Docker files exist
4. **Build Docker Image** - Build application container
5. **Test Docker Image** - Verify image was created
6. **Deploy with Docker Compose** - Start MongoDB and App
7. **Health Check** - Verify services are running
8. **Cleanup Old Images** - Remove unused images

---

## 🌐 Access Your Application

After successful build:

**Application**: http://ec2-98-81-246-105.compute-1.amazonaws.com:3000
**Jenkins**: http://ec2-98-81-246-105.compute-1.amazonaws.com:8080

---

## 🐛 Troubleshooting

### Pipeline fails with "Permission denied" for Docker
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Can't access application on port 3000
```bash
# Check if containers are running
docker ps

# Check logs
docker-compose logs -f app
```

### Need to restart everything
```bash
# Stop all containers
docker-compose down

# Restart Jenkins
sudo systemctl restart jenkins

# Start containers again via Jenkins pipeline
```

---

## 📊 Verify Deployment

After pipeline completes, verify on EC2:

```bash
# Check running containers
docker ps

# Should see 2 containers:
# - student-management-app
# - student-management-mongodb

# Check logs
docker-compose logs -f

# Test MongoDB
docker-compose exec mongodb mongosh --eval "db.adminCommand('ping')"
```

---

## 🔄 Make Changes and Redeploy

1. Make changes to your code locally
2. Commit and push to GitHub:
   ```bash
   git add .
   git commit -m "Your changes"
   git push origin main
   ```
3. Go to Jenkins and click "Build Now"
4. Watch the pipeline execute
5. Access updated application

---

## 💡 Pro Tips

- **Auto-build on push**: Set up GitHub webhook pointing to `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/`
- **View real-time logs**: Click on build number → "Console Output"
- **Pipeline visualization**: Blue Ocean plugin provides better UI
- **Save logs**: Pipeline automatically archives logs in `docker-logs.txt`

---

## 📞 Common Commands

### Jenkins
```bash
sudo systemctl status jenkins    # Check status
sudo systemctl restart jenkins   # Restart
sudo journalctl -u jenkins -f    # View logs
```

### Docker
```bash
docker ps                        # List containers
docker-compose logs -f           # View logs
docker-compose down              # Stop all
docker-compose up -d --build     # Rebuild and start
```

---

## ✅ Assignment Requirements Met

- ✅ Jenkins running on AWS EC2
- ✅ Code in GitHub repository
- ✅ Jenkinsfile with pipeline script
- ✅ Uses Git plugin to fetch code
- ✅ Uses Pipeline plugin for CI/CD
- ✅ Uses Docker Pipeline plugin
- ✅ Builds application in Docker container
- ✅ Automated build process

---

## 📝 What to Submit

1. **Screenshots**:
   - Jenkins dashboard with successful build
   - Pipeline stage view
   - Console output showing Docker build
   - Running application in browser
   - Docker containers running (`docker ps`)

2. **Repository**:
   - GitHub repo URL
   - Jenkinsfile in the repo

3. **Documentation**:
   - Brief description of your setup
   - Any challenges faced and solutions

---

**Need detailed instructions?** See `JENKINS_SETUP.md` for comprehensive guide.

**Good luck! 🎉**
