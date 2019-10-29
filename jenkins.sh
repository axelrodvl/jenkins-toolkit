#!/bin/bash

source env.sh

createFolder() {
  echo "Create folder"
  curl -XPOST "$JENKINS_URL/createItem?name=$FOLDER_NAME&mode=com.cloudbees.hudson.plugins.folder.Folder&from=&json=%7B%22name%22%3A%22FolderName%22%2C%22mode%22%3A%22com.cloudbees.hudson.plugins.folder.Folder%22%2C%22from%22%3A%22%22%2C%22Submit%22%3A%22OK%22%7D&Submit=OK" -H "Content-Type:application/x-www-form-urlencoded" --user "$JENKINS_USER:$JENKINS_TOKEN"
}

createJob() {
  echo "Creating job $JOB_NAME in folder $FOLDER_NAME"

  cp templates/jenkins/jenkins-job.xml jenkins-job.xml
  sed -i.bak "s~\${GIT_URL}~$GIT_URL~g" jenkins-job.xml
  sed -i.bak "s~\${GIT_CREDENTIALS_ID}~$GIT_CREDENTIALS_ID~g" jenkins-job.xml
  sed -i.bak "s~\${GIT_BRANCH}~$GIT_BRANCH~g" jenkins-job.xml

  curl -X POST "$JENKINS_URL/job/RGF/createItem?name=$JOB_NAME" -H "Content-Type: application/xml" -d @jenkins-job.xml --user "$JENKINS_USER:$JENKINS_TOKEN"

  rm *.bak
  rm jenkins-job.xml
}

backupExistingElements() {
  echo "Get existing job"
  curl -XGET "$JENKINS_URL/job/$FOLDER_NAME/job/$JOB_NAME/config.xml" --user "$JENKINS_USER:$JENKINS_TOKEN"

  echo "Get existing folder"
  curl -XGET "$JENKINS_URL/job/$FOLDER_NAME/config.xml" --user "$JENKINS_USER:$JENKINS_TOKEN"
}

validateJenkinsfile() {
  while read -r line; do declare "$line"; done <gradle.properties
  curl --user "$JENKINS_USER:$JENKINS_TOKEN" -X POST -F "jenkinsfile=<Jenkinsfile" "$JENKINS_URL/pipeline-model-converter/validate"
}

"$@"