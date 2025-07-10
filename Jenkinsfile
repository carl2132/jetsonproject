pipeline {
    agent any

    environment {
        OSSUTIL_PATH = '/usr/local/bin/ossutil'
        MODEL_DIR = "${WORKSPACE}/models"
        SCRIPT_PATH = "${WORKSPACE}/scripts/upload_and_ota.sh"
    }

    stages {
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

        stage('上传并触发 OTA') {
            steps {
                sh "chmod +x \"${SCRIPT_PATH}\""
                sh "\"${SCRIPT_PATH}\" \"${env.LATEST_MODEL}\""
            }
        }
    }

    post {
        failure {
            echo "❌ OTA 失败，请检查日志"
        }
        success {
            echo "✅ OTA 成功完成"
        }
    }
}
