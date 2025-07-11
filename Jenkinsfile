pipeline {
    agent any

    environment {
        // 替换为你实际部署的 ossutil 路径
        OSSUTIL_PATH = '/var/jenkins_home/bin/ossutil'
        MODEL_DIR = "${WORKSPACE}/models"
        SCRIPT_PATH = "${WORKSPACE}/scripts/upload_and_ota.sh"
        PATH = "/var/jenkins_home/bin:$PATH"
        JETSON_USER = 'cqut'
        JETSON_IP = '172.20.10.2'
    }

    stages {
        stage('拉取代码') {
            steps {
                git credentialsId: 'jetson-ssh-key', url: 'git@github.com:carl2132/jetsonproject.git', branch: 'main'
            }
        }

        stage('获取最新模型') {
            steps {
                script {
                    def latestModel = sh(script: "ls -t \"${MODEL_DIR}\"/*.pt | head -n 1", returnStdout: true).trim()
                    if (latestModel == "") {
                        error "❌ 未找到模型文件"
                    }
                    env.LATEST_MODEL = latestModel
                    echo "✅ 获取到模型: ${env.LATEST_MODEL}"
                }
            }
        }

        stage('测试 Jetson SSH 连通性') {
            steps {
                sh """
                    echo '🔍 正在测试 Jetson SSH 连接...'
                    ssh -o StrictHostKeyChecking=no ${JETSON_USER}@${JETSON_IP} 'echo Jetson SSH OK' || {
                        echo '❌ 无法连接 Jetson，请检查免密 SSH 配置'
                        exit 1
                    }
                """
            }
        }

        stage('上传并触发 OTA') {
            steps {
                sh "chmod +x \"${SCRIPT_PATH}\""
                sh "\"${SCRIPT_PATH}\" \"${env.LATEST_MODEL}\""
            }
        }
    }

    post {
        success {
            echo "✅ OTA 成功完成"
        }
        failure {
            echo "❌ OTA 失败，请检查日志"
        }
    }
}
