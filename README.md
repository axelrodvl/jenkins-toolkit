# Jenkins toolkit for Kubernetes
Create Jenkins pipeline for building Gradle application and deploying builds to Kubernetes

### Supported environment:
- Jenkins instance in Kubernetes: https://github.com/helm/charts/tree/master/stable/jenkins

### Based on:
- https://github.com/jenkinsci/kubernetes-plugin

## Prepare Jenkins
### Create Jenkins credentials for your GIT repository
- https://jenkins.io/doc/book/using/using-credentials/#adding-new-global-credentials

### Upload Kubernetes config to Jenkins
- Obtain your `kubeconfig` file: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
- Upload `kubeconfig` file to Jenkins: https://jenkins.io/doc/book/using/using-credentials/#adding-new-global-credentials (use `Secret file` to upload Kubernetes `config` file)

### Set environment
Edit `env.sh`:
- `GIT_URL` - repository URL (i.e. `https://github.com/gradle/gradle-build-scan-quickstart.git`)
- `GIT_CREDENTIALS_ID` - created GIT credentials in Jenkins
- `GIT_BRANCH` - GIT branch for build (i.e. `master`)
- `JENKINS_URL` - Jenkins URL (i.e. `http://localhost:8080`)
- `JENKINS_USER` - Jenkins user
- `JENKINS_TOKEN` - your user Jenkins token (see below)
- `JENKINS_FOLDER` - folder name for Jenkins job
- `JENKINS_JOB` - Jenkins job name

### Obtain Jenkins user token:
- Log in to Jenkins
- Click you name (upper-right corner)
- Click Configure (left-side menu)
- Use "Add new Token" button to generate a new one then name it
- You must copy the token when you generate it as you cannot view the token afterwards
- Save token in `jenkins-job.sh`

**Note. In case of error `No valid crumb was included in the request` disable CSRF for a limited time (don't forget to turn it back!):
- Log in to Jenkins
- Click Manage Jenkins
- Click Configure Global Security
- Uncheck CSRF Protection - Prevent Cross Site Request Forgery exploits

### Create job
```bash
./jenkins.sh createJob
```

### Create folder
```bash
./jenkins.sh createFolder
```

### Backup existing folder
```bash
./jenkins.sh backupExistingElements`
```

## Working with Jenkinsfile
### Validate Jenkinsfile
```bash
./jenkins.sh validateJenkinsfile
```

### Deploy PVC for build cache
```bash
kubectl apply -f templates/kubernetes/build-cache-pvc.yml
```

### Run your build
- Copy `Jenkinsfile` and `KubernetesPod.yaml` to your project
- Run build in Jenkins 