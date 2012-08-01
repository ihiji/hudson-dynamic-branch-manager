#!/bin/bash
set -e
set -u
#the env var CI_TYPE is expected to be hudson or jenkins, and controls location and name of the cli jar.

project_name=$1 #e.g. "pachweb".  A config  ${project_name}_develop/config.xml is
                #expected to exist already and will be used as the template for the new branch job.
branch=$2 #this should be a simple name for branch, stripped of origin/  e.g. "hotfix-1.3.1" or "feature/zombies"
job_name=${project_name}_$branch

#TODO: remove certain things from job names, such as / characters, as job name will be used as dir name.

#copy the #{project_name}_develop job config, substituting origin/$branch where we had develop.
sed "s%master%origin/${branch}%" ~/jobs/${project_name}_develop/config.xml > /tmp/newconfig.xml
#cp  ~/jobs/${project_name}_template/config.xml /tmp/newconfig.xml
#create this job
< /tmp/newconfig.xml java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job $job_name
sleep 5
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 build $job_name

