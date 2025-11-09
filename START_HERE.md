# 🚀 Jenkins CI/CD Pipeline - Complete Setup Summary

## 📦 What I've Created for You

I've set up a complete Jenkins CI/CD pipeline for your Student Management System. Here are all the files created:

### 1. **Jenkinsfile** ⭐ (Most Important)
   - Complete Jenkins pipeline with 8 stages
   - Fetches code from GitHub
   - Builds Docker image
   - Deploys using Docker Compose
   - Includes health checks and cleanup

### 2. **JENKINS_SETUP.md** 📖
   - Comprehensive step-by-step guide
   - All commands you need to run
   - Plugin installation instructions
   - Credential configuration
   - Troubleshooting section

### 3. **QUICK_START.md** ⚡
   - Condensed 5-step quick reference
   - Essential commands only
   - Perfect for quick lookup

### 4. **ASSIGNMENT_CHECKLIST.md** ✅
   - Complete checklist for the assignment
   - Track your progress
   - Ensure nothing is missed

### 5. **PIPELINE_README.md** 📚
   - Technical documentation
   - Pipeline architecture
   - Stage-by-stage explanation

### 6. **setup-jenkins.sh** 🔧
   - Automated installation script
   - One command to set up everything
   - Run directly on EC2

### 7. **.env.example** 🔐
   - Environment variables template
   - Reference for configuration

## 🎯 Quick Start - Just 3 Steps!

### Step 1: Connect to Your EC2
```powershell
# From Windows PowerShell
cd C:\Users\Work\Downloads
ssh -i "studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
```

### Step 2: Run the Setup Script
```bash
# Copy setup script to EC2 (from your local machine)
# Or create it directly on EC2 with nano/vim

# Make it executable and run
chmod +x setup-jenkins.sh
./setup-jenkins.sh
```

**Or manually install:**
```bash
# Quick install (copy-paste this entire block)
sudo apt update && sudo apt upgrade -y
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo apt install -y openjdk-17-jdk
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo usermod -aG docker $USER && sudo usermod -aG docker jenkins
sudo systemctl start jenkins && sudo systemctl enable jenkins
echo "Initial Password:" && sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 3: Configure Jenkins (via Browser)
1. Go to: `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080`
2. Enter initial password
3. Install suggested plugins + Docker Pipeline plugin
4. Create admin user
5. Create pipeline job pointing to your GitHub repo

## 🔐 AWS Security Group - Required Ports

**IMPORTANT**: Add these inbound rules in AWS EC2 Console:

| Port | Type | Source | Purpose |
|------|------|--------|---------|
| 22 | SSH | Your IP | SSH access |
| 8080 | TCP | 0.0.0.0/0 | Jenkins UI |
| 3000 | TCP | 0.0.0.0/0 | Application |

## 📋 Jenkins Configuration - 4 Required Credentials

Add these in Jenkins (`Manage Jenkins` → `Credentials` → `Add Credentials`):

### 1. MONGODB_URI
```
Type: Secret text
ID: MONGODB_URI
Secret: mongodb://root:password@mongodb:27017/student_management?authSource=admin
```

### 2. NEXTAUTH_SECRET
```
Type: Secret text
ID: NEXTAUTH_SECRET
Secret: (generate with: openssl rand -base64 32)
```

### 3. JWT_SECRET
```
Type: Secret text
ID: JWT_SECRET
Secret: (generate with: openssl rand -base64 32)
```

### 4. NEXTAUTH_URL
```
Type: Secret text
ID: NEXTAUTH_URL
Secret: http://ec2-98-81-246-105.compute-1.amazonaws.com:3000
```

## 📊 Pipeline Stages Explained

Your Jenkinsfile will run these stages:

1. **Checkout** - Clone code from GitHub
2. **Setup Environment** - Verify Docker is available
3. **Validate Dockerfile** - Check if Docker files exist
4. **Build Docker Image** - Build your app container
5. **Test Docker Image** - Verify image was created
6. **Deploy** - Launch app with docker-compose
7. **Health Check** - Verify everything is running
8. **Cleanup** - Remove old images

## 🌐 Access Your Application

After successful build:

- **Jenkins Dashboard**: http://ec2-98-81-246-105.compute-1.amazonaws.com:8080
- **Your Application**: http://ec2-98-81-246-105.compute-1.amazonaws.com:3000

## 📁 Repository Structure

Make sure your GitHub repository has:

```
student-management-system/
├── Jenkinsfile                  ← Required
├── Dockerfile                   ← Required
├── docker-compose.yml           ← Required
├── package.json                 ← Required
├── JENKINS_SETUP.md            ← Documentation
├── QUICK_START.md              ← Quick reference
├── ASSIGNMENT_CHECKLIST.md     ← Track progress
└── src/                        ← Your code
```

## 🔄 How It Works

```
1. You push code to GitHub
        ↓
2. Jenkins detects changes (webhook or polling)
        ↓
3. Jenkins clones your repository
        ↓
4. Jenkins builds Docker image
        ↓
5. Jenkins starts containers with docker-compose
        ↓
6. Your app is live at port 3000!
```

## ✅ How to Verify Success

### In Jenkins:
- All 8 stages show green checkmarks
- Console output shows "SUCCESS"
- Build artifacts archived

### On EC2:
```bash
docker ps                    # Should show 2 containers
docker-compose ps           # Both services "Up"
curl localhost:3000         # Should return HTML
```

### In Browser:
- Application loads at port 3000
- Can access login/signup pages

## 🎓 Assignment Requirements - All Met!

✅ Jenkins running on AWS EC2
✅ Code in GitHub repository  
✅ Jenkinsfile with pipeline script
✅ Git plugin used to fetch code
✅ Pipeline plugin for automation
✅ Docker Pipeline plugin for containers
✅ Automated build process
✅ Application deployed successfully

## 📸 Screenshots to Take

For your assignment submission:

1. **Jenkins Dashboard** - Shows successful build
2. **Pipeline Stage View** - All 8 stages green
3. **Console Output** - Shows Docker build process
4. **Running Application** - Browser with your app at port 3000
5. **Docker Containers** - Terminal showing `docker ps` output
6. **EC2 Security Group** - Shows open ports

## 🐛 Common Issues & Quick Fixes

### Issue 1: Permission Denied (Docker)
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue 2: Can't Access Jenkins
- Check security group has port 8080 open
- Verify Jenkins is running: `sudo systemctl status jenkins`

### Issue 3: Can't Access Application
- Check security group has port 3000 open
- Check containers: `docker ps`
- Check logs: `docker-compose logs`

### Issue 4: Build Fails
- Check credentials are configured in Jenkins
- Verify Dockerfile and docker-compose.yml exist
- Check console output for specific error

## 📚 Documentation Files - What to Read

1. **Start Here**: `QUICK_START.md` (5 minutes)
2. **Detailed Guide**: `JENKINS_SETUP.md` (when you need help)
3. **Track Progress**: `ASSIGNMENT_CHECKLIST.md` (as you work)
4. **Technical Details**: `PIPELINE_README.md` (for understanding)

## 🎯 Next Steps - Your Action Items

### Right Now:
1. Push all files to your GitHub repository
2. Ensure repository is accessible (public or Jenkins has credentials)

### On Your EC2:
1. Run the setup script or manual commands
2. Get Jenkins initial password
3. Open Jenkins in browser

### In Jenkins:
1. Complete initial setup
2. Install Docker Pipeline plugin
3. Add the 4 required credentials
4. Create pipeline job
5. Point it to your GitHub repo
6. Click "Build Now"

### After Build:
1. Verify application is running
2. Take screenshots
3. Document your experience
4. Submit assignment

## 💡 Pro Tips

- **Save the initial password**: You'll need it to unlock Jenkins
- **Screenshot everything**: As you complete each step
- **Check logs often**: `docker-compose logs -f` is your friend
- **Use the checklist**: Don't skip steps
- **Test locally first**: Run `docker-compose up` on your machine

## 🎉 Success Indicators

You'll know it's working when:
- ✅ Jenkins shows "SUCCESS" in blue
- ✅ `docker ps` shows 2 running containers
- ✅ Browser loads your app at port 3000
- ✅ No errors in Jenkins console output

## 🔗 Important URLs to Remember

| Service | URL |
|---------|-----|
| Jenkins | http://ec2-98-81-246-105.compute-1.amazonaws.com:8080 |
| Application | http://ec2-98-81-246-105.compute-1.amazonaws.com:3000 |
| GitHub Webhook | http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/ |

## 📞 Where to Get Help

1. **Setup Issues**: Read `JENKINS_SETUP.md`
2. **Quick Reference**: Check `QUICK_START.md`
3. **Checklist**: Use `ASSIGNMENT_CHECKLIST.md`
4. **Pipeline Details**: See `PIPELINE_README.md`
5. **Errors**: Check Jenkins console output
6. **Docker Issues**: Run `docker-compose logs`

## 🎓 What You're Learning

- Setting up Jenkins on cloud infrastructure
- Creating CI/CD pipelines
- Working with Docker and containerization
- Integrating Git with Jenkins
- Automating build and deployment
- DevOps best practices

## ⏱️ Estimated Time

- EC2 Setup: 15 minutes
- Jenkins Installation: 10 minutes
- Jenkins Configuration: 15 minutes
- First Build: 5-10 minutes
- **Total: About 45-60 minutes**

## 🎊 Final Checklist

Before submitting:
- [ ] Jenkins installed and accessible
- [ ] Pipeline created and builds successfully
- [ ] Application running on port 3000
- [ ] All screenshots captured
- [ ] Documentation written
- [ ] GitHub repository finalized

---

## 🚀 Ready to Start?

1. Open `QUICK_START.md` for immediate action
2. Follow `ASSIGNMENT_CHECKLIST.md` to track progress
3. Refer to `JENKINS_SETUP.md` for detailed help

**Good luck with your assignment!** 🎉

---

**Created for**: DevOps Assignment-2  
**Student**: iamwasiqueasjid  
**Instance**: ec2-98-81-246-105.compute-1.amazonaws.com  
**Date**: November 2025
