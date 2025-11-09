# Jenkins CI/CD Pipeline for Student Management System

This repository contains a complete Jenkins CI/CD pipeline configuration for automating the build and deployment of the Student Management System using Docker.

## 📁 Repository Structure

```
.
├── Jenkinsfile                 # Jenkins pipeline configuration
├── Dockerfile                  # Docker image build instructions
├── docker-compose.yml          # Multi-container orchestration
├── JENKINS_SETUP.md           # Detailed setup guide
├── QUICK_START.md             # Quick reference guide
├── .env.example               # Environment variables template
└── src/                       # Application source code
```

## 🎯 Pipeline Overview

The Jenkins pipeline automates the following workflow:

1. **Checkout** - Clones code from GitHub repository
2. **Setup Environment** - Validates Docker and system dependencies
3. **Validate Dockerfile** - Ensures Docker configuration files exist
4. **Build Docker Image** - Creates containerized application image
5. **Test Docker Image** - Verifies successful image creation
6. **Deploy** - Launches application using Docker Compose
7. **Health Check** - Validates service availability
8. **Cleanup** - Removes unused Docker images

## 🚀 Quick Setup

### Prerequisites

- AWS EC2 instance (Ubuntu)
- SSH access with PEM key
- GitHub repository

### Installation

1. **Connect to EC2**:
   ```bash
   ssh -i "studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
   ```

2. **Run installation script** (see `QUICK_START.md`)

3. **Configure Security Group**: Open ports 8080, 3000, and 22

4. **Access Jenkins**: `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080`

5. **Create Pipeline Job** and link to this repository

## 🔐 Required Credentials

Configure these credentials in Jenkins (`Manage Jenkins` → `Credentials`):

| Credential ID | Type | Description |
|---------------|------|-------------|
| `MONGODB_URI` | Secret text | MongoDB connection string |
| `NEXTAUTH_SECRET` | Secret text | NextAuth.js encryption key |
| `JWT_SECRET` | Secret text | JWT token signing key |
| `NEXTAUTH_URL` | Secret text | Application base URL |

## 🐳 Docker Configuration

### Dockerfile

Multi-stage build process:
- **Builder stage**: Installs dependencies and builds Next.js app
- **Production stage**: Creates lightweight runtime image

### Docker Compose

Services:
- **mongodb**: MongoDB 7.0 database with health checks
- **app**: Next.js application connected to MongoDB

## 📊 Pipeline Stages Explained

### 1. Checkout
```groovy
checkout scm
```
Fetches latest code from GitHub using Git plugin.

### 2. Setup Environment
Validates Docker and Docker Compose installation.

### 3. Validate Dockerfile
Ensures required files exist before building.

### 4. Build Docker Image
```bash
docker build \
  --build-arg MONGODB_URI=${MONGODB_URI} \
  --build-arg NEXTAUTH_SECRET=${NEXTAUTH_SECRET} \
  -t student-management-system:latest .
```

### 5. Test Docker Image
Verifies image creation and inspects metadata.

### 6. Deploy with Docker Compose
```bash
docker-compose down
docker-compose up -d --build
```

### 7. Health Check
Validates MongoDB and application container health.

### 8. Cleanup
Removes dangling Docker images to free disk space.

## 🌐 Accessing the Application

After successful deployment:

- **Application**: http://ec2-98-81-246-105.compute-1.amazonaws.com:3000
- **Jenkins**: http://ec2-98-81-246-105.compute-1.amazonaws.com:8080

## 🔄 CI/CD Workflow

### Manual Trigger
1. Go to Jenkins dashboard
2. Select your pipeline job
3. Click "Build Now"

### Automatic Trigger (GitHub Webhook)
1. Configure webhook in GitHub repository settings
2. Webhook URL: `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/`
3. Pipeline triggers automatically on code push

## 📋 Environment Variables

Required environment variables (configure in Jenkins credentials):

```bash
# MongoDB Connection
MONGODB_URI=mongodb://root:password@mongodb:27017/student_management?authSource=admin

# Authentication Secrets
NEXTAUTH_SECRET=<generate-with-openssl-rand-base64-32>
JWT_SECRET=<generate-with-openssl-rand-base64-32>

# Application URL
NEXTAUTH_URL=http://ec2-98-81-246-105.compute-1.amazonaws.com:3000
```

Generate secure secrets:
```bash
openssl rand -base64 32
```

## 🐛 Troubleshooting

### Pipeline fails with Docker permission errors
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Port conflicts
```bash
docker-compose down
sudo lsof -i :3000
sudo kill -9 <PID>
```

### View container logs
```bash
docker-compose logs -f
docker-compose logs app
docker-compose logs mongodb
```

### Restart Jenkins
```bash
sudo systemctl restart jenkins
```

## 📦 Docker Commands Reference

```bash
# View running containers
docker ps

# View all containers
docker ps -a

# View images
docker images

# View logs
docker-compose logs -f app

# Stop all services
docker-compose down

# Rebuild and start
docker-compose up -d --build

# Clean up system
docker system prune -a
```

## 🔧 Jenkins Plugins Required

- Git Plugin
- Pipeline Plugin
- Docker Pipeline Plugin
- Docker Plugin
- GitHub Integration Plugin
- Credentials Binding Plugin

Install via: `Manage Jenkins` → `Plugins` → `Available plugins`

## 📈 Monitoring and Logs

### View Pipeline Logs
- Click on build number
- Select "Console Output"

### View Application Logs
```bash
docker-compose logs -f app
```

### View MongoDB Logs
```bash
docker-compose logs -f mongodb
```

### Archived Logs
Pipeline automatically archives logs in `docker-logs.txt` artifact.

## 🔒 Security Best Practices

1. **Use strong secrets**: Generate random strings for NEXTAUTH_SECRET and JWT_SECRET
2. **Restrict Security Groups**: Limit access to trusted IPs
3. **Update regularly**: Keep Jenkins, Docker, and system packages updated
4. **Secure MongoDB**: Change default root password
5. **Use HTTPS**: Configure SSL certificate for production
6. **Backup Jenkins**: Regular backups of `/var/lib/jenkins`

## 📚 Documentation

- **Detailed Setup**: See `JENKINS_SETUP.md`
- **Quick Reference**: See `QUICK_START.md`
- **Environment Config**: See `.env.example`

## 🎓 Assignment Deliverables

### Required Screenshots
1. Jenkins dashboard with successful build
2. Pipeline stage view showing all stages
3. Console output showing Docker build
4. Application running in browser
5. `docker ps` output showing running containers

### Repository Requirements
- ✅ Jenkinsfile in repository root
- ✅ Dockerfile for containerization
- ✅ docker-compose.yml for orchestration
- ✅ README with setup instructions

### Pipeline Requirements
- ✅ Uses Git plugin to fetch code from GitHub
- ✅ Uses Pipeline plugin for CI/CD automation
- ✅ Uses Docker Pipeline plugin for containerization
- ✅ Builds application in Docker container
- ✅ Deploys application automatically

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Commit and push
5. Jenkins will automatically build and deploy

## 📞 Support

For issues or questions:
- Check `JENKINS_SETUP.md` for detailed instructions
- Review console output for error messages
- Check Docker logs: `docker-compose logs`

## 🎉 Success Criteria

Pipeline is successful when:
- ✅ All 8 stages complete without errors
- ✅ Docker image is built successfully
- ✅ Containers are running (`docker ps`)
- ✅ Application is accessible on port 3000
- ✅ MongoDB is healthy and accepting connections

## 📊 Pipeline Visualization

```
GitHub Push
    ↓
Jenkins Webhook Trigger
    ↓
Checkout Code
    ↓
Validate Environment
    ↓
Build Docker Image
    ↓
Run Tests
    ↓
Deploy with Docker Compose
    ↓
Health Checks
    ↓
Application Live ✨
```

## 🔗 Useful Links

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Next.js Documentation](https://nextjs.org/docs)

---

**Built with ❤️ for DevOps Assignment-2**

**Author**: iamwasiqueasjid  
**Repository**: student-management-system-jenkins  
**Jenkins Setup**: AWS EC2 Ubuntu Instance
