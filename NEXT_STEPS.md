# 🎉 NEXT STEPS - Your Action Plan

## ✅ COMPLETED
- [x] All Jenkins pipeline files created
- [x] Documentation completed
- [x] Setup scripts created
- [x] Files pushed to GitHub: https://github.com/iamwasiqueasjid/student-management-system-jenkins.git

---

## 🚀 NOW DO THIS (Step-by-Step)

### STEP 1: Connect to EC2 (Do this now!)

Open PowerShell and run:

```powershell
cd C:\Users\Work\Downloads
ssh -i "studentjenkins.pem" ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com
```

---

### STEP 2: Install Everything (Copy-Paste This Entire Block)

Once connected to EC2, paste this ONE command:

```bash
sudo apt update && sudo apt upgrade -y && curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && sudo apt install -y openjdk-17-jdk && curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null && echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null && sudo apt update && sudo apt install -y jenkins && sudo usermod -aG docker ubuntu && sudo usermod -aG docker jenkins && sudo systemctl start jenkins && sudo systemctl enable jenkins && sleep 10 && echo "=== INSTALLATION COMPLETE ===" && echo "Jenkins Initial Password:" && sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

⏱️ **This will take 5-10 minutes. Wait for it to complete!**

---

### STEP 3: Save Jenkins Password

At the end, you'll see:
```
=== INSTALLATION COMPLETE ===
Jenkins Initial Password:
[some-long-password-here]
```

**📝 COPY THIS PASSWORD! You'll need it in Step 5.**

---

### STEP 4: Configure AWS Security Group

1. Go to AWS Console → EC2 → Your Instance
2. Click on Security Group
3. Edit Inbound Rules
4. Add these rules:

| Type | Port | Source | Description |
|------|------|--------|-------------|
| Custom TCP | 8080 | 0.0.0.0/0 | Jenkins UI |
| Custom TCP | 3000 | 0.0.0.0/0 | Application |
| SSH | 22 | Your IP | SSH Access |

5. Save rules

---

### STEP 5: Access Jenkins (Open Browser)

Go to: **http://ec2-98-81-246-105.compute-1.amazonaws.com:8080**

1. Paste the initial admin password from Step 3
2. Click "Continue"
3. Click "Install suggested plugins"
4. Wait for plugins to install (2-3 minutes)
5. Create admin user:
   - Username: `admin`
   - Password: (choose a strong password)
   - Full Name: Your Name
   - Email: your email
6. Click "Save and Continue"
7. Keep default Jenkins URL
8. Click "Start using Jenkins"

---

### STEP 6: Install Additional Plugins

1. Click "Manage Jenkins" (left sidebar)
2. Click "Plugins"
3. Click "Available plugins"
4. Search and install these:
   - ✅ **Docker Pipeline**
   - ✅ **Docker Plugin**
   - ✅ **GitHub Integration**
5. Click "Install without restart"
6. Wait for installation to complete

---

### STEP 7: Add Credentials (IMPORTANT!)

1. Go to: "Manage Jenkins" → "Credentials" → "(global)" → "Add Credentials"

**Add these 4 credentials (one by one):**

#### Credential 1: MONGODB_URI
- Kind: `Secret text`
- Scope: `Global`
- Secret: `mongodb://root:password@mongodb:27017/student_management?authSource=admin`
- ID: `MONGODB_URI`
- Description: `MongoDB Connection URI`
- Click "Create"

#### Credential 2: NEXTAUTH_SECRET
First, generate it in EC2 terminal:
```bash
openssl rand -base64 32
```
Copy the output, then in Jenkins:
- Kind: `Secret text`
- Scope: `Global`
- Secret: (paste the generated value)
- ID: `NEXTAUTH_SECRET`
- Description: `NextAuth Secret Key`
- Click "Create"

#### Credential 3: JWT_SECRET
Generate in EC2 terminal:
```bash
openssl rand -base64 32
```
Copy the output, then in Jenkins:
- Kind: `Secret text`
- Scope: `Global`
- Secret: (paste the generated value)
- ID: `JWT_SECRET`
- Description: `JWT Secret Key`
- Click "Create"

#### Credential 4: NEXTAUTH_URL
- Kind: `Secret text`
- Scope: `Global`
- Secret: `http://ec2-98-81-246-105.compute-1.amazonaws.com:3000`
- ID: `NEXTAUTH_URL`
- Description: `NextAuth URL`
- Click "Create"

---

### STEP 8: Create Pipeline Job

1. Go to Jenkins Dashboard
2. Click "New Item"
3. Enter name: `Student-Management-System`
4. Select "Pipeline"
5. Click "OK"

#### Configure Pipeline:

**General Section:**
- Description: `CI/CD Pipeline for Student Management System`

**Pipeline Section:**
- Definition: Select `Pipeline script from SCM`
- SCM: Select `Git`
- Repository URL: `https://github.com/iamwasiqueasjid/student-management-system-jenkins.git`
- Credentials: (leave as "none" if public repo)
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`
- ✅ Check "Lightweight checkout"

**Click "Save"**

---

### STEP 9: Run Your First Build! 🚀

1. Click "Build Now"
2. Watch the build number appear (e.g., #1)
3. Click on the build number
4. Click "Console Output"
5. Watch the magic happen! ✨

**You should see these 8 stages execute:**
1. ✅ Checkout
2. ✅ Setup Environment
3. ✅ Validate Dockerfile
4. ✅ Build Docker Image
5. ✅ Test Docker Image
6. ✅ Deploy with Docker Compose
7. ✅ Health Check
8. ✅ Cleanup Old Images

⏱️ **First build takes 5-10 minutes.**

---

### STEP 10: Verify Deployment

#### In Browser:
Go to: **http://ec2-98-81-246-105.compute-1.amazonaws.com:3000**

You should see your Student Management System! 🎉

#### In EC2 Terminal:
```bash
# Check running containers
docker ps

# Should show 2 containers:
# 1. student-management-app
# 2. student-management-mongodb

# Check logs
docker-compose logs -f
```

---

## 📸 TAKE SCREENSHOTS FOR SUBMISSION

### Screenshot 1: Jenkins Dashboard
- Show successful build (green checkmark)
- Build history visible

### Screenshot 2: Pipeline Stage View
- All 8 stages showing green
- Click on your build → "Pipeline Steps"

### Screenshot 3: Console Output
- Show the full console output
- Must show:
  - Git clone from GitHub
  - Docker build process
  - docker-compose up
  - "SUCCESS" at the end

### Screenshot 4: Application Running
- Browser showing your app
- **URL must be visible** in address bar
- Show login or signup page

### Screenshot 5: Docker Containers
In EC2 terminal:
```bash
docker ps
```
Screenshot showing both containers running

### Screenshot 6: AWS Security Group
- Show inbound rules with ports 8080, 3000, 22

---

## ✅ SUCCESS CHECKLIST

- [ ] Connected to EC2 successfully
- [ ] Ran installation command
- [ ] Got Jenkins initial password
- [ ] Opened ports in AWS Security Group
- [ ] Accessed Jenkins at port 8080
- [ ] Installed suggested plugins
- [ ] Installed Docker Pipeline plugin
- [ ] Created admin user
- [ ] Added all 4 credentials (MONGODB_URI, NEXTAUTH_SECRET, JWT_SECRET, NEXTAUTH_URL)
- [ ] Created pipeline job
- [ ] Configured pipeline to use GitHub repo
- [ ] First build completed successfully
- [ ] All 8 stages passed
- [ ] Application accessible at port 3000
- [ ] Took all 6 screenshots
- [ ] docker ps shows 2 running containers

---

## 🐛 TROUBLESHOOTING

### Build Fails with "Permission Denied"
```bash
# In EC2 terminal:
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
# Then rebuild in Jenkins
```

### Can't Access Jenkins at Port 8080
- Check AWS Security Group has port 8080 open
- Check Jenkins is running: `sudo systemctl status jenkins`

### Can't Access Application at Port 3000
- Check AWS Security Group has port 3000 open
- Check containers are running: `docker ps`
- Check logs: `docker-compose logs`

### Credentials Not Found
- Make sure credential ID exactly matches:
  - `MONGODB_URI` (not mongodb_uri)
  - `NEXTAUTH_SECRET` (not nextauth_secret)
  - `JWT_SECRET` (not jwt_secret)
  - `NEXTAUTH_URL` (not nextauth_url)

---

## 🎓 FOR ASSIGNMENT SUBMISSION

### Submit:
1. **GitHub Repository URL**: 
   ```
   https://github.com/iamwasiqueasjid/student-management-system-jenkins.git
   ```

2. **6 Screenshots** (in a folder)

3. **Document** with:
   - Brief description of your setup
   - Challenges faced (if any)
   - How you solved them
   - EC2 instance details:
     - Jenkins URL: http://ec2-98-81-246-105.compute-1.amazonaws.com:8080
     - App URL: http://ec2-98-81-246-105.compute-1.amazonaws.com:3000

4. **Jenkinsfile** (already in your repo)

---

## 🎉 YOU'RE READY!

Everything is set up. Just follow the steps above one by one.

**Good luck! You've got this! 🚀**

---

## 📞 Quick Help

- **Stuck?** Check: `JENKINS_SETUP.md` in your repo
- **Need a command?** Check: `COMMANDS_REFERENCE.md`
- **Progress tracking?** Use: `ASSIGNMENT_CHECKLIST.md`

**Current Time**: Start now and you can complete everything in 1-2 hours!
