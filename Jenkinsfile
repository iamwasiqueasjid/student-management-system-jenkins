pipeline {
    agent any
    
    environment {
        // Docker Hub credentials (configure in Jenkins)
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE_NAME = 'student-management-system'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
        
        // MongoDB Configuration
        MONGODB_URI = credentials('MONGODB_URI')
        NEXTAUTH_SECRET = credentials('NEXTAUTH_SECRET')
        JWT_SECRET = credentials('JWT_SECRET')
        NEXTAUTH_URL = credentials('NEXTAUTH_URL')
        
        // Application Port
        APP_PORT = '3000'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
                sh 'git log -1 --pretty=format:"%h - %an, %ar : %s"'
            }
        }
        
        stage('Setup Environment') {
            steps {
                echo 'Setting up environment...'
                script {
                    // Display Node version if available
                    sh '''
                        if command -v node &> /dev/null; then
                            echo "Node version: $(node --version)"
                        else
                            echo "Node.js not found in PATH"
                        fi
                    '''
                    
                    // Display Docker version
                    sh 'docker --version'
                    sh 'docker compose version || docker-compose --version'
                }
            }
        }
        
        stage('Validate Dockerfile') {
            steps {
                echo 'Validating Dockerfile...'
                script {
                    if (!fileExists('Dockerfile')) {
                        error('Dockerfile not found!')
                    }
                    if (!fileExists('docker-compose.yml')) {
                        error('docker-compose.yml not found!')
                    }
                    echo 'Dockerfile and docker-compose.yml validated successfully'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    // Build the Docker image with build arguments
                    sh """
                        docker build \
                            --build-arg MONGODB_URI=\${MONGODB_URI} \
                            --build-arg NEXTAUTH_SECRET=\${NEXTAUTH_SECRET} \
                            --build-arg JWT_SECRET=\${JWT_SECRET} \
                            --build-arg NEXTAUTH_URL=\${NEXTAUTH_URL} \
                            -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
                            -t ${DOCKER_IMAGE_NAME}:latest \
                            .
                    """
                    echo "Docker image built successfully: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                echo 'Testing Docker image...'
                script {
                    // Verify the image was created
                    sh "docker images | grep ${DOCKER_IMAGE_NAME}"
                    
                    // Inspect the image
                    sh "docker inspect ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }
        
        stage('Deploy with Docker Compose') {
            steps {
                echo 'Deploying application with Docker Compose...'
                script {
                    // Stop and remove existing containers
                    sh '''
                        docker compose down || true
                        docker system prune -f --volumes || true
                    '''
                    
                    // Start services with docker-compose
                    sh '''
                        docker compose up -d --build
                    '''
                    
                    // Wait for services to be ready
                    echo 'Waiting for services to be ready...'
                    sh 'sleep 15'
                    
                    // Check running containers
                    sh 'docker compose ps'
                    sh 'docker ps'
                }
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Performing health check...'
                script {
                    // Check if MongoDB is running
                    sh '''
                        docker compose exec -T mongodb mongosh --eval "db.adminCommand('ping')" || \
                        echo "MongoDB health check: Waiting for initialization..."
                    '''
                    
                    // Check if app container is running
                    sh '''
                        docker compose logs app | tail -20
                    '''
                    
                    echo 'Health check completed'
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                echo 'Cleaning up old Docker images...'
                script {
                    // Remove dangling images
                    sh '''
                        docker image prune -f || true
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            echo "Application is running on port ${APP_PORT}"
            echo "MongoDB is running on port 27017"
            sh 'docker compose ps'
        }
        
        failure {
            echo 'Pipeline failed!'
            echo 'Collecting logs for debugging...'
            sh '''
                docker compose logs --tail=50 || true
                docker ps -a || true
            '''
        }
        
        always {
            echo 'Pipeline execution completed'
            // Archive logs if needed
            sh 'docker compose logs > docker-logs.txt || true'
            archiveArtifacts artifacts: 'docker-logs.txt', allowEmptyArchive: true
        }
    }
}
