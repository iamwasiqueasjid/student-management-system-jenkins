 # Jenkins Pipeline Assignment Checklist

Use this checklist to track your progress through the assignment.

## 📋 Pre-Setup Checklist

- [ ] AWS EC2 instance created and running
- [ ] Security Group configured (ports 22, 8080, 3000)
- [ ] PEM key file downloaded and accessible
- [ ] SSH connection tested successfully
- [ ] GitHub repository created
- [ ] Code pushed to GitHub repository

## 🔧 Installation Checklist

### EC2 Instance Setup
- [ ] Connected to EC2 via SSH
- [ ] System packages updated (`sudo apt update && sudo apt upgrade`)
- [ ] Docker installed
- [ ] Docker Compose installed
- [ ] Java (OpenJDK 17) installed
- [ ] Jenkins installed
- [ ] Jenkins user added to docker group
- [ ] Jenkins service started and enabled

### Verify Installations
- [ ] `docker --version` works
- [ ] `docker-compose --version` works
- [ ] `java -version` works
- [ ] `sudo systemctl status jenkins` shows active

## 🌐 Jenkins Web Setup

### Initial Setup
- [ ] Jenkins accessible at `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080`
- [ ] Initial admin password retrieved
- [ ] Unlocked Jenkins with initial password
- [ ] Suggested plugins installed
- [ ] Admin user created
- [ ] Jenkins URL configured

### Plugin Installation
- [ ] Git Plugin (verify it's installed)
- [ ] Pipeline Plugin (verify it's installed)
- [ ] Docker Pipeline Plugin installed
- [ ] Docker Plugin installed
- [ ] GitHub Integration Plugin installed
- [ ] Credentials Binding Plugin installed

## 🔐 Credentials Configuration

### Jenkins Credentials Added
- [ ] MONGODB_URI credential created
  - Type: Secret text
  - ID: `MONGODB_URI`
  - Value: `mongodb://root:password@mongodb:27017/student_management?authSource=admin`

- [ ] NEXTAUTH_SECRET credential created
  - Type: Secret text
  - ID: `NEXTAUTH_SECRET`
  - Value: Generated with `openssl rand -base64 32`

- [ ] JWT_SECRET credential created
  - Type: Secret text
  - ID: `JWT_SECRET`
  - Value: Generated with `openssl rand -base64 32`

- [ ] NEXTAUTH_URL credential created
  - Type: Secret text
  - ID: `NEXTAUTH_URL`
  - Value: `http://ec2-98-81-246-105.compute-1.amazonaws.com:3000`

## 📁 Repository Setup

### Required Files in Repository
- [ ] `Jenkinsfile` created in repository root
- [ ] `Dockerfile` exists
- [ ] `docker-compose.yml` exists
- [ ] `package.json` exists
- [ ] `.env.example` created (optional)
- [ ] `JENKINS_SETUP.md` added (optional)
- [ ] All files committed and pushed to GitHub

## 🚀 Pipeline Configuration

### Create Pipeline Job
- [ ] New Item created in Jenkins
- [ ] Job name: `Student-Management-System-Pipeline`
- [ ] Job type: Pipeline
- [ ] Description added
- [ ] GitHub project URL configured (optional)

### Pipeline Settings
- [ ] Pipeline definition: "Pipeline script from SCM" selected
- [ ] SCM: Git selected
- [ ] Repository URL entered: `https://github.com/iamwasiqueasjid/student-management-system-jenkins.git`
- [ ] Credentials selected (if private repo)
- [ ] Branch specifier: `*/main` (or `*/master`)
- [ ] Script path: `Jenkinsfile`
- [ ] Lightweight checkout enabled
- [ ] Configuration saved

## ▶️ First Build

### Running the Pipeline
- [ ] "Build Now" clicked
- [ ] Build started successfully
- [ ] Build number visible (e.g., #1)
- [ ] Console output accessible

### Pipeline Stages Completed
- [ ] ✅ Stage 1: Checkout
- [ ] ✅ Stage 2: Setup Environment
- [ ] ✅ Stage 3: Validate Dockerfile
- [ ] ✅ Stage 4: Build Docker Image
- [ ] ✅ Stage 5: Test Docker Image
- [ ] ✅ Stage 6: Deploy with Docker Compose
- [ ] ✅ Stage 7: Health Check
- [ ] ✅ Stage 8: Cleanup Old Images

### Build Status
- [ ] Build completed successfully (green checkmark)
- [ ] No errors in console output
- [ ] Stage View shows all stages passed
- [ ] Build artifacts archived (docker-logs.txt)

## 🔍 Verification

### Docker Verification (on EC2)
```bash
# Run these commands and check results
- [ ] `docker ps` shows 2 running containers
- [ ] `docker images` shows student-management-system image
- [ ] `docker-compose ps` shows services as "Up"
- [ ] `docker-compose logs app` shows no errors
- [ ] `docker-compose logs mongodb` shows successful connection
```

### Application Verification
- [ ] Application accessible at `http://ec2-98-81-246-105.compute-1.amazonaws.com:3000`
- [ ] Application loads without errors
- [ ] Can navigate to login page
- [ ] Can navigate to signup page
- [ ] MongoDB connection working

### Jenkins Verification
- [ ] Build history visible
- [ ] Console output shows Docker commands executed
- [ ] Stage view displays all stages
- [ ] Build duration reasonable (< 10 minutes)
- [ ] No permission errors

## 📸 Screenshots for Submission

### Required Screenshots
- [ ] Jenkins Dashboard showing successful build
- [ ] Pipeline Stage View (all stages green)
- [ ] Console Output showing:
  - [ ] Git clone from GitHub
  - [ ] Docker build process
  - [ ] Docker Compose deployment
  - [ ] Health check results
- [ ] Application running in browser (with URL visible)
- [ ] EC2 terminal showing `docker ps` output
- [ ] EC2 terminal showing `docker images` output

## 🔄 Optional: GitHub Webhook

### Webhook Configuration (Optional)
- [ ] GitHub repository → Settings → Webhooks
- [ ] Webhook URL: `http://ec2-98-81-246-105.compute-1.amazonaws.com:8080/github-webhook/`
- [ ] Content type: `application/json`
- [ ] Events: "Just the push event"
- [ ] Webhook active
- [ ] Test push triggers build automatically

## 📝 Documentation

### Assignment Documentation
- [ ] Brief project description written
- [ ] Setup process documented
- [ ] Challenges faced documented
- [ ] Solutions implemented documented
- [ ] Screenshots organized
- [ ] Repository URL noted

## ✅ Final Checks

### Functionality Test
- [ ] Make a code change locally
- [ ] Commit and push to GitHub
- [ ] Jenkins automatically builds (if webhook configured)
- [ ] Or manually trigger build
- [ ] New build completes successfully
- [ ] Application reflects changes

### Assignment Requirements Met
- [ ] ✅ Jenkins running on AWS EC2
- [ ] ✅ Code in GitHub repository
- [ ] ✅ Jenkinsfile with pipeline script
- [ ] ✅ Git plugin used to fetch code
- [ ] ✅ Pipeline plugin used for automation
- [ ] ✅ Docker Pipeline plugin used
- [ ] ✅ Application builds in Docker container
- [ ] ✅ Automated build process working

## 🎯 Submission Checklist

### What to Submit
- [ ] GitHub repository URL
- [ ] Screenshots folder with all required images
- [ ] Documentation document (PDF/Word)
- [ ] Brief description of setup process
- [ ] List of challenges and solutions
- [ ] Jenkins pipeline configuration (Jenkinsfile)
- [ ] EC2 instance details (optional, for demo)

### Quality Checks
- [ ] All screenshots are clear and readable
- [ ] URLs are visible in screenshots
- [ ] Documentation is well-formatted
- [ ] Code is properly committed to GitHub
- [ ] No sensitive information in screenshots (passwords, keys)

## 🐛 Troubleshooting Completed

### Common Issues Resolved
- [ ] Docker permission errors fixed
- [ ] Port conflicts resolved
- [ ] MongoDB connection issues resolved
- [ ] Jenkins restart performed if needed
- [ ] Build failures debugged and fixed

## 📚 Understanding

### Concepts Understood
- [ ] What is Jenkins and why it's used
- [ ] What is CI/CD
- [ ] How Jenkins integrates with GitHub
- [ ] How Docker containerization works
- [ ] How Jenkins Pipeline syntax works
- [ ] How Docker Compose orchestrates services
- [ ] How environment variables work in Docker
- [ ] How to read Jenkins console output

## 🎓 Learning Outcomes

- [ ] Can set up Jenkins on a server
- [ ] Can create Jenkins pipeline scripts
- [ ] Can integrate Jenkins with GitHub
- [ ] Can build Docker images via Jenkins
- [ ] Can deploy applications with Jenkins
- [ ] Can troubleshoot CI/CD issues
- [ ] Can configure Jenkins credentials
- [ ] Can monitor Jenkins builds

---

## 📊 Progress Summary

**Total Items**: Count all checkboxes above
**Completed**: Count checked boxes
**Percentage**: (Completed / Total) × 100%

---

## 🎉 Completion

Once all items are checked:
- [ ] Assignment is ready for submission
- [ ] All requirements met
- [ ] Documentation complete
- [ ] Screenshots captured
- [ ] Repository finalized

**CONGRATULATIONS!** 🎊 You've completed the Jenkins CI/CD Pipeline assignment!

---

## 📞 Need Help?

If stuck on any item:
1. Check `JENKINS_SETUP.md` for detailed instructions
2. Review `QUICK_START.md` for quick reference
3. Check Jenkins console output for errors
4. Review Docker logs: `docker-compose logs`
5. Restart services if needed

---

**Last Updated**: Check before submission
**Your Name**: __________________
**Submission Date**: __________________
