pipeline {
  agent {
    kubernetes {
      yamlFile 'KubernetesPod.yaml'
    }
  }
  environment {
      KUBERNETES_CONFIG = credentials('config')
  }
  stages {
    stage('Run gradle') {
      steps {
        container('gradle') {
          withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh 'gradle clean build uploadSnapshot \
            -PprivateNexusUser=$USERNAME \
            -PprivateNexusPassword=$PASSWORD \
            -Dorg.gradle.daemon=false \
            -Dorg.gradle.parallel=false'
          }
        }
        container('kubectl') {
          withCredentials([file(credentialsId: 'config', variable: 'config')]) {
             sh "cp \$config kubeconfig"

             sh 'echo VERSION_TO_DEPLOY = ${VERSION_TO_DEPLOY}'
             sh 'echo env.VERSION_TO_DEPLOY = ${env.VERSION_TO_DEPLOY}'

             sh "kubectl --insecure-skip-tls-verify --kubeconfig=kubeconfig get pods --all-namespaces"
             sh "kubectl --insecure-skip-tls-verify --validate=false --kubeconfig=kubeconfig --namespace default apply -f kubernetesYaml/"
          }
        }
      }
    }
  }
}
