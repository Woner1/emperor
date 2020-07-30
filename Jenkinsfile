#!/usr/bin/env groovy
properties([
  buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '15', numToKeepStr: '')),
  pipelineTriggers([[$class: 'PeriodicFolderTrigger', interval: '1d']]),
])

node {
  catchError {
    timeout(time: 300, unit: 'MINUTES') {
      env.ECR_REGISTRY = "269171237421.dkr.ecr.ap-east-1.amazonaws.com"
      env.APPLICATION_NAME = "emperor"
      env.DEPLOYMENT_PROJECT_NAME = "emperor_deployment"
      env.AWS_REGION = "ap-east-1"
      
      stage('Clone Repository') {
        sh "chmod +x -R ${env.WORKSPACE}"

        def scmVars = checkout([
          $class: 'GitSCM',
          branches: scm.branches,
          extensions: scm.extensions + [
            [$class: 'CloneOption', honorRefspec: true, noTags: false],
            [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentiails: true],
            [$class: 'CleanCheckout']
          ],
          userRemoteConfigs: scm.userRemoteConfigs
        ])
      }
      // get git info description
      env.APPLICATION_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
      env.APPLICATION_VERSION = sh(returnStdout: true, script: 'git describe --always --abbrev=8 HEAD').trim()
      env.SECOND_EPOCH = sh(returnStdout: true, script: 'date +%s').trim()
      env.IMAGE_TAG = "${APPLICATION_VERSION}-b${SECOND_EPOCH}"
      echo "Building docker image usring image tag: ${IMAGE_TAG}"
      // set ci && skipbuild
      env.CI_ENV = sh(returnStdout: true, script: "git log -1 --format=%B  | sed -n 's/^.*\\[ci \\(.*\\)\\].*/\\1/p'").trim()
      echo "CI_ENV VALUE: ${CI_ENV}"
      // env.BUILD_HOB_CAUSE = getBuildCause()
      // echo "BUILD_JOB_CAUSE: ${BUILD_HOB_CAUSE}"
      // build docker image

      // set BRANCH_NAME value
      def BRANCH_NAME = "develop"

      if(env.TAG_NAME){
        build_app_image('hk_prod')
      }else{
        echo "The branch is ${BRANCH_NAME}"
        brancheName = "${BRANCH_NAME}"
        switch(brancheName) {
          case ~/^master$/:
              build_app_image('hk-prod')
          case ~/^develop$/:
              build_app_image('hk-test')
          case ~/^build.*/
              build_app_image('hk-dev')
              break
          default:
              echo "Unsupported branch name: ${branchName}"
        }
      }
    }
  }
}

def shouldDeploy(String applicationEnv){
  def countryList = "$CI_ENV".trim().tokenize(',')
  if(env.TAG_NAME){
    echo "git tag exists"
    return false;
  }
  return countryList && countryList.any { it -> applicationEnv.startsWith(it) }
}

def build_app_image(String application_env) {
  application_env = application_env ?: ''
  if(application_env == ''){
    echo "Undefind application_env: ${application_env}"
    return
  }
  withEnv(["APPLICATION_ENV=${application_env}"]) {
    stage("Build image: ${APPLICATION_NAME}_${APPLICATION_ENV}") {
      echo "next to build image"
      echo "Build image for ${APPLICATION_NAME}, env: ${APPLICATION_ENV}, version: ${APPLICATION_VERSION}, commit: ${APPLICATION_COMMIT}"
      ansiColor('xterm') {
        sh "chmod +x -R ${env.WORKSPACE}"
        sh '''
          set +x
          ./docker-build.sh ${APPLICATION_NAME} ${APPLICATION_ENV} ${APPLICATION_VERSION} ${APPLICATION_COMMIT} ${IMAGE_TAG}
        '''
      }
      publish_image("${APPLICATION_ENV}_${IMAGE_TAG}")
      publish_image("${APPLICATION_ENV}_${IMAGE_TAG}_nginx_api")
      publish_image("${APPLICATION_ENV}_${IMAGE_TAG}_nginx_admin")

      // tigger deployment if CI_ENV is set
      // deploy_image("${APPLICATION_ENV}")
      echo "finsh build"
    }
  }
}

def publish_image(String tag) {
  withEnv(["FULL_IMAGE_TAG=${tag}"]) {
    echo "image --> ${APPLICATION_NAME}:${FULL_IMAGE_TAG}"
    docker.withRegistry("https://${ECR_REGISTRY}", "ecr:${AWS_REGION}:emperor-aws-ecr") {
      docker.image("${APPLICATION_NAME}:${FULL_IMAGE_TAG}").push()
    }
  }
}

// def getBuildCause(){
//   def causes = currentBuild.getBuildCauses()
//   println causes
//   gitBranchCause  = currentBuild.getBuildCauses('jenkins.branch.BranchEventCause')
//   SCMCause        = currentBuild.getBuildCauses('hudson.triggers.SCMTrigger$SCMTriggerCause')
//   UserCause       = currentBuild.getBuildCauses('hudson.model.Cause$UserIdCause')
//   def buildCause = ''
//   if (gitBranchCause) {
//     buildCause = 'GITHUB'
//   } else if (SCMCause) {
//     buildCause = 'SCM'
//   } else if (UserCause) {
//     buildCause = 'USER'
//   } else {
//     println 'This job cant be triggered however it was just triggered, sorry.'
//   }
//   return buildCause;
// }

def deploy_image(String app_env){
  if(shouldDeploy("${app_env}")){
    build job: "${DEPLOYMENT_PROJECT_NAME}", wait: false, parameters: [
      string(name: 'DEPLOY_ENV', value: "${app_env}"),
      string(name: 'DEPLOY_VERSION', value: "${IMAGE_TAG}")]
  }
}
