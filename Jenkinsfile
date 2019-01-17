pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    environment {
        git url: 'https://github.com/babinskiy/dropwizard-example'
        env.GIT_TAG_NAME = gitTagName()
        env.GIT_TAG_MESSAGE = gitTagMessage()
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    archiveArtifacts artifacts: '**/*.jar', fingerprint: true
                    junit 'target/surefire-reports/*.xml'
                    /** @return The tag name, or `null` if the current commit isn't a tag. */
                    String gitTagName() {
                        commit = getCommit()
                        if (commit) {
                            desc = sh(script: "git describe --tags ${commit}", returnStdout: true)?.trim()
                            if (isTag(desc)) {
                                return desc
                            }
                        }
                        return null
                    }

                }
            }
        }
        stage('S3Copy') {
            steps {
                s3Upload acl: 'Private', bucket: '30daysdevops/dropwizard/release', cacheControl: '', excludePathPattern: '', file: 'target/', metadatas: [''], sseAlgorithm: '', workingDir: ''
                s3Upload acl: 'Private', bucket: '30daysdevops/dropwizard/release', cacheControl: '', excludePathPattern: '', file: 'mysql.yml', metadatas: [''], sseAlgorithm: '', workingDir: ''
            }
        }
    }
}
