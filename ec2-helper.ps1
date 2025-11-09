# PowerShell Script to Transfer Files to EC2 and Run Setup
# Run this script from Windows PowerShell

# Configuration
$PEM_KEY = "C:\Users\Work\Downloads\studentjenkins.pem"
$EC2_HOST = "ubuntu@ec2-98-81-246-105.compute-1.amazonaws.com"
$PROJECT_DIR = "D:\CUI\7th Semester\Devops\Assignment-2\student-management-system"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "EC2 Setup Helper Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Function to display menu
function Show-Menu {
    Write-Host "What would you like to do?" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Test SSH Connection"
    Write-Host "2. Transfer setup-jenkins.sh to EC2"
    Write-Host "3. Connect to EC2 via SSH"
    Write-Host "4. Transfer all files to EC2"
    Write-Host "5. Run setup script on EC2"
    Write-Host "6. Check Jenkins status on EC2"
    Write-Host "7. Get Jenkins initial password"
    Write-Host "8. View running Docker containers"
    Write-Host "9. Exit"
    Write-Host ""
}

# Function to test SSH connection
function Test-SSH {
    Write-Host "Testing SSH connection..." -ForegroundColor Green
    ssh -i $PEM_KEY $EC2_HOST "echo 'Connection successful!'"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ SSH connection working!" -ForegroundColor Green
    } else {
        Write-Host "✗ SSH connection failed!" -ForegroundColor Red
    }
    Write-Host ""
}

# Function to transfer setup script
function Transfer-SetupScript {
    Write-Host "Transferring setup-jenkins.sh to EC2..." -ForegroundColor Green
    scp -i $PEM_KEY "$PROJECT_DIR\setup-jenkins.sh" ${EC2_HOST}:~/setup-jenkins.sh
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ File transferred successfully!" -ForegroundColor Green
        Write-Host "Making script executable..." -ForegroundColor Yellow
        ssh -i $PEM_KEY $EC2_HOST "chmod +x ~/setup-jenkins.sh"
        Write-Host "✓ Script is ready to run!" -ForegroundColor Green
    } else {
        Write-Host "✗ File transfer failed!" -ForegroundColor Red
    }
    Write-Host ""
}

# Function to connect to EC2
function Connect-EC2 {
    Write-Host "Connecting to EC2 instance..." -ForegroundColor Green
    Write-Host "To exit, type 'exit' or press Ctrl+D" -ForegroundColor Yellow
    Write-Host ""
    ssh -i $PEM_KEY $EC2_HOST
}

# Function to transfer all files
function Transfer-AllFiles {
    Write-Host "Transferring all project files to EC2..." -ForegroundColor Green
    Write-Host "This may take a few minutes..." -ForegroundColor Yellow
    
    # Create remote directory
    ssh -i $PEM_KEY $EC2_HOST "mkdir -p ~/student-management-system"
    
    # Transfer files (excluding node_modules and .next)
    scp -i $PEM_KEY -r "$PROJECT_DIR\*" ${EC2_HOST}:~/student-management-system/
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ All files transferred successfully!" -ForegroundColor Green
    } else {
        Write-Host "✗ File transfer failed!" -ForegroundColor Red
    }
    Write-Host ""
}

# Function to run setup script
function Run-SetupScript {
    Write-Host "Running setup script on EC2..." -ForegroundColor Green
    Write-Host "This will take 5-10 minutes..." -ForegroundColor Yellow
    Write-Host ""
    ssh -i $PEM_KEY $EC2_HOST "bash ~/setup-jenkins.sh"
    Write-Host ""
    Write-Host "✓ Setup script completed!" -ForegroundColor Green
    Write-Host ""
}

# Function to check Jenkins status
function Check-JenkinsStatus {
    Write-Host "Checking Jenkins status on EC2..." -ForegroundColor Green
    ssh -i $PEM_KEY $EC2_HOST "sudo systemctl status jenkins"
    Write-Host ""
}

# Function to get Jenkins password
function Get-JenkinsPassword {
    Write-Host "Retrieving Jenkins initial password..." -ForegroundColor Green
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "JENKINS INITIAL ADMIN PASSWORD" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    ssh -i $PEM_KEY $EC2_HOST "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Copy this password and use it to unlock Jenkins at:" -ForegroundColor Yellow
    Write-Host "http://ec2-98-81-246-105.compute-1.amazonaws.com:8080" -ForegroundColor Cyan
    Write-Host ""
}

# Function to view Docker containers
function View-Containers {
    Write-Host "Viewing running Docker containers..." -ForegroundColor Green
    Write-Host ""
    ssh -i $PEM_KEY $EC2_HOST "docker ps"
    Write-Host ""
    Write-Host "Docker Compose Status:" -ForegroundColor Yellow
    ssh -i $PEM_KEY $EC2_HOST "cd ~/student-management-system && docker-compose ps"
    Write-Host ""
}

# Check if PEM key exists
if (-not (Test-Path $PEM_KEY)) {
    Write-Host "✗ Error: PEM key not found at $PEM_KEY" -ForegroundColor Red
    Write-Host "Please update the PEM_KEY variable in this script." -ForegroundColor Yellow
    exit 1
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-9)"
    Write-Host ""
    
    switch ($choice) {
        "1" { Test-SSH }
        "2" { Transfer-SetupScript }
        "3" { Connect-EC2 }
        "4" { Transfer-AllFiles }
        "5" { Run-SetupScript }
        "6" { Check-JenkinsStatus }
        "7" { Get-JenkinsPassword }
        "8" { View-Containers }
        "9" { 
            Write-Host "Goodbye!" -ForegroundColor Green
            exit 0
        }
        default { 
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            Write-Host ""
        }
    }
    
    if ($choice -ne "3" -and $choice -ne "9") {
        Write-Host "Press Enter to continue..." -ForegroundColor Yellow
        Read-Host
        Clear-Host
    }
} while ($true)
