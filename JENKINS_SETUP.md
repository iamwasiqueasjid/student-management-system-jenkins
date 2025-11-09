# Jenkins Setup Guide for AWS EC2

This guide will help you set up Jenkins on your AWS EC2 instance and configure the CI/CD pipeline for the Student Management System.

## Prerequisites

- AWS EC2 instance (Ubuntu)
- SSH access to the EC2 instance
- PEM key file: `C:\Users\Work\Downloads\studentjenkins.pem`
- GitHub repository with your code

## SSH Connection

```bash
ssh -i "C:\Users\Work\Downloads\studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
```

---

## Part 1: Initial EC2 Setup

### Step 1: Connect to EC2 Instance

From PowerShell on Windows:

```powershell
cd C:\Users\Work\Downloads
ssh -i "studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
```

### Step 2: Update System

```bash
sudo apt update
sudo apt upgrade -y
```

---

## Part 2: Install Docker and Docker Compose

### Install Docker

```bash
# Install prerequisites
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Verify Docker installation
docker --version
```

### Install Docker Compose

```bash
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

---

## Part 3: Install Java (Required for Jenkins)

```bash
# Install OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Verify Java installation
java -version
```

---

## Part 4: Install Jenkins

### Install Jenkins

```bash
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

# Start Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins status
sudo systemctl status jenkins
```

### Configure Jenkins User Permissions

```bash
# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Restart Jenkins to apply changes
sudo systemctl restart jenkins

# Verify jenkins user can access docker
sudo -u jenkins docker ps
```

---

## Part 5: Configure EC2 Security Group

### Open Required Ports in AWS Console:

1. **Jenkins UI**: Port `8080` (TCP)
2. **Application**: Port `3000` (TCP)
3. **SSH**: Port `22` (TCP)

**Steps:**
1. Go to AWS EC2 Console
2. Select your instance
3. Go to Security Groups
4. Edit Inbound Rules
5. Add rules:
   - Type: Custom TCP, Port: 8080, Source: My IP (or 0.0.0.0/0 for public)
   - Type: Custom TCP, Port: 3000, Source: My IP (or 0.0.0.0/0 for public)

---

## Part 6: Access and Setup Jenkins

### Step 1: Get Initial Admin Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy this password.

### Step 2: Access Jenkins UI

Open your browser and go to:
```
http://ec2-98-81-246-105.compute-1.amazonaws.com:8080
```

### Step 3: Complete Initial Setup

1. Paste the initial admin password
2. Click "Install suggested plugins"
3. Wait for plugins to install
4. Create your first admin user:
   - Username: `admin`
   - Password: (choose a strong password)
   - Full name: Your Name
   - Email: your@email.com
5. Keep the default Jenkins URL or change it
6. Click "Start using Jenkins"

---

## Part 7: Install Required Jenkins Plugins

### Navigate to Plugin Manager:
`Dashboard` → `Manage Jenkins` → `Plugins` → `Available plugins`

### Install the following plugins:

1. **Git Plugin** (usually pre-installed)
2. **Pipeline Plugin** (usually pre-installed)
3. **Docker Pipeline Plugin**
4. **Docker Plugin**
5. **GitHub Integration Plugin**
6. **Credentials Binding Plugin**

**Steps:**
1. Search for each plugin
2. Check the checkbox
3. Click "Install without restart" or "Download now and install after restart"
4. Wait for installation to complete
5. Restart Jenkins if needed

---

## Part 8: Configure Jenkins Credentials

### Step 1: Add MongoDB URI

1. Go to `Dashboard` → `Manage Jenkins` → `Credentials`
2. Click on `(global)` domain
3. Click `Add Credentials`
4. Configure:
   - Kind: `Secret text`
   - Scope: `Global`
   - Secret: `mongodb://root:password@mongodb:27017/student_management?authSource=admin`
   - ID: `MONGODB_URI`
   - Description: `MongoDB Connection URI`
5. Click `Create`

### Step 2: Add NEXTAUTH_SECRET

1. Click `Add Credentials` again
2. Configure:
   - Kind: `Secret text`
   - Scope: `Global`
   - Secret: `your-nextauth-secret-key-change-this-in-production`
   - ID: `NEXTAUTH_SECRET`
   - Description: `NextAuth Secret Key`
3. Click `Create`

### Step 3: Add JWT_SECRET

1. Click `Add Credentials` again
2. Configure:
   - Kind: `Secret text`
   - Scope: `Global`
   - Secret: `your-jwt-secret-key-change-this-in-production`
   - ID: `JWT_SECRET`
   - Description: `JWT Secret Key`
3. Click `Create`

### Step 4: Add NEXTAUTH_URL

1. Click `Add Credentials` again
2. Configure:
   - Kind: `Secret text`
   - Scope: `Global`
   - Secret: `http://ec2-98-81-246-105.compute-1.amazonaws.com:3000`
   - ID: `NEXTAUTH_URL`
   - Description: `NextAuth URL`
3. Click `Create`

### Step 5: (Optional) Add GitHub Credentials

If your repository is private:

1. Click `Add Credentials`
2. Configure:
   - Kind: `Username with password`
   - Scope: `Global`
   - Username: Your GitHub username
   - Password: Your GitHub Personal Access Token
   - ID: `github-credentials`
   - Description: `GitHub Credentials`
3. Click `Create`

---

## Part 9: Create Jenkins Pipeline Job

### Step 1: Create New Pipeline

1. Go to Jenkins Dashboard
2. Click `New Item`
3. Enter item name: `Student-Management-System-Pipeline`
4. Select `Pipeline`
5. Click `OK`

### Step 2: Configure Pipeline

#### General Section:
- Description: `CI/CD Pipeline for Student Management System`
- Check `GitHub project` (if using GitHub)
- Project url: `https://github.com/iamwasiqueasjid/student-management-system-jenkins/`

#### Build Triggers:
- Check `GitHub hook trigger for GITScm polling` (for automatic builds on push)
- Or check `Poll SCM` and set schedule: `H/5 * * * *` (checks every 5 minutes)

#### Pipeline Section:

**Option A: Pipeline from SCM (Recommended)**

1. Definition: Select `Pipeline script from SCM`
2. SCM: Select `Git`
3. Repository URL: `https://github.com/iamwasiqueasjid/student-management-system-jenkins.git`
4. Credentials: Select if repository is private
5. Branch Specifier: `*/main` (or `*/master`)
6. Script Path: `Jenkinsfile`
7. Lightweight checkout: Check this

**Option B: Pipeline Script**

1. Definition: Select `Pipeline script`
2. Copy the entire content from `Jenkinsfile` in your project
3. Paste it in the Script section

### Step 3: Save Configuration

Click `Save`

---

## Part 10: Run the Pipeline

### Manual Build

1. Go to your pipeline job
2. Click `Build Now`
3. Wait for the build to start
4. Click on the build number (e.g., #1)
5. Click `Console Output` to see real-time logs

### Monitor the Build

Watch the following stages:
1. ✅ Checkout
2. ✅ Setup Environment
3. ✅ Validate Dockerfile
4. ✅ Build Docker Image
5. ✅ Test Docker Image
6. ✅ Deploy with Docker Compose
7. ✅ Health Check
8. ✅ Cleanup Old Images

---

## Part 11: Access Your Application

After successful build:

### Application URL:
```
http://ec2-98-81-246-105.compute-1.amazonaws.com:3000
```

### Verify Deployment

SSH into EC2 and run:

```bash
# Check running containers
docker ps

# Check application logs
docker-compose logs -f app

# Check MongoDB logs
docker-compose logs -f mongodb

# Check container health
docker-compose ps
```

---

## Part 12: Setup GitHub Webhook (Optional)

For automatic builds on code push:

### Step 1: Get Jenkins Webhook URL

```
http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/
```

### Step 2: Configure GitHub Webhook

1. Go to your GitHub repository
2. Click `Settings` → `Webhooks` → `Add webhook`
3. Configure:
   - Payload URL: `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/`
   - Content type: `application/json`
   - Which events: `Just the push event`
   - Active: ✓
4. Click `Add webhook`

Now, every time you push code to GitHub, Jenkins will automatically trigger a build!

---

## Troubleshooting

### Issue 1: Permission Denied (Docker)

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo reboot
```

### Issue 2: Port Already in Use

```bash
# Find process using port 3000
sudo lsof -i :3000

# Kill the process
sudo kill -9 <PID>

# Or stop all containers
docker-compose down
```

### Issue 3: Jenkins Won't Start

```bash
# Check Jenkins status
sudo systemctl status jenkins

# View Jenkins logs
sudo journalctl -u jenkins -f

# Restart Jenkins
sudo systemctl restart jenkins
```

### Issue 4: Cannot Connect to Docker Daemon

```bash
# Check Docker status
sudo systemctl status docker

# Start Docker
sudo systemctl start docker

# Add jenkins user to docker group (if not done)
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue 5: MongoDB Connection Issues

```bash
# Check MongoDB logs
docker-compose logs mongodb

# Verify MongoDB is running
docker ps | grep mongodb

# Test MongoDB connection
docker-compose exec mongodb mongosh --eval "db.adminCommand('ping')"
```

---

## Useful Commands

### Jenkins Commands

```bash
# Start Jenkins
sudo systemctl start jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Check Jenkins status
sudo systemctl status jenkins

# View Jenkins logs
sudo journalctl -u jenkins -f
```

### Docker Commands

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# View container logs
docker logs <container_name>

# Stop all containers
docker stop $(docker ps -q)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all images
docker rmi $(docker images -q)

# Clean up system
docker system prune -a
```

### Docker Compose Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and start
docker-compose up -d --build

# Check service status
docker-compose ps
```

---

## Environment Variables Reference

### Required Environment Variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `MONGODB_URI` | MongoDB connection string | `mongodb://root:password@mongodb:27017/student_management?authSource=admin` |
| `NEXTAUTH_SECRET` | NextAuth.js secret key | Generate with: `openssl rand -base64 32` |
| `JWT_SECRET` | JWT token secret | Generate with: `openssl rand -base64 32` |
| `NEXTAUTH_URL` | Application URL | `http://ec2-98-81-246-105.compute-1.amazonaws.com:3000` |

### Generate Secure Secrets:

```bash
# Generate NEXTAUTH_SECRET
openssl rand -base64 32

# Generate JWT_SECRET
openssl rand -base64 32
```

---

## Security Best Practices

1. **Change Default Credentials**: Update MongoDB root password in docker-compose.yml
2. **Use Strong Secrets**: Generate secure random strings for NEXTAUTH_SECRET and JWT_SECRET
3. **Limit Security Group Access**: Only allow access from trusted IP addresses
4. **Regular Updates**: Keep Jenkins, Docker, and system packages updated
5. **Backup Jenkins Configuration**: Regularly backup `/var/lib/jenkins`
6. **Use HTTPS**: Consider setting up SSL/TLS with Let's Encrypt
7. **Monitor Logs**: Regularly check Jenkins and application logs for issues

---

## Next Steps

1. ✅ Set up Jenkins on EC2
2. ✅ Install required plugins
3. ✅ Configure credentials
4. ✅ Create pipeline job
5. ✅ Run first build
6. ✅ Verify application is running
7. 🔄 Set up GitHub webhook for automatic builds
8. 🔄 Configure SSL certificate (optional)
9. 🔄 Set up monitoring and alerts (optional)
10. 🔄 Configure backup strategy (optional)

---

## Support and Resources

- Jenkins Documentation: https://www.jenkins.io/doc/
- Docker Documentation: https://docs.docker.com/
- Next.js Documentation: https://nextjs.org/docs
- MongoDB Documentation: https://docs.mongodb.com/

---

## Assignment Checklist

- [ ] EC2 instance running with Jenkins installed
- [ ] Jenkins accessible via browser (port 8080)
- [ ] Required plugins installed (Git, Pipeline, Docker Pipeline)
- [ ] GitHub repository with code
- [ ] Jenkinsfile in repository
- [ ] Pipeline successfully fetches code from GitHub
- [ ] Application builds in Docker container
- [ ] Application deploys and runs successfully
- [ ] Can access application via browser (port 3000)
- [ ] Pipeline stages visible in Jenkins UI
- [ ] Build logs captured and accessible

---

Good luck with your assignment! 🚀
