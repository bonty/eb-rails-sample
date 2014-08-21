#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage : $0 command"
        echo "Commands:"
        echo "rc - Rails Console"
        echo "rdbm - Migrate Database"
        echo "restore-db - Restore db from db/current.sql.zip"
        echo "restart - Restart rails app after bundling gems"
        echo "rebuild - Rebuild the docker container with latest Gemfile and restart"
        echo "build-image - Build rails app image for deploy"
        echo "push-image - Push latest rails app image to S3 private repository"
        echo 'cmd "bundle exec something" - Run the command in quotes in /app'
        exit
fi

case "$1" in

rc)  echo "Starting Console in Docker Container.."
    vagrant ssh -c "sh /app/docker/scripts/rc.sh"
    ;;
rdbm)  echo  "Running rake db:migrate in Docker container.."
    vagrant ssh -c "sh /app/docker/scripts/rdbm.sh"
    ;;
restore-db)  echo  "Restoring db from db/current.sql.zip"
    vagrant ssh -c "sh /app/docker/scripts/restore-db.sh"
    ;;
restart) echo  "Restarting Docker Rails Container"
    vagrant ssh -c "sh /app/docker/scripts/restart.sh"
    ;;
rebuild) echo  "Rebuilding Docker Rails Container"
    vagrant ssh -c "sh /app/docker/scripts/rebuild.sh"
    ;;
build-image) echo "Building Docker Rails Container for Deploy"
    vagrant ssh -c "sh /app/docker/scripts/build-image.sh"
    ;;
push-image) echo "Pushing Docker Rails Container to S3 Private Repository"
    vagrant ssh -c "sh /app/docker/scripts/push-image.sh"
    ;;
cmd) echo "running '$2' in docker container in /app"
    vagrant ssh -c "/app/docker/scripts/cmd.sh '$2'"
    ;;
*) echo "Command not known"
   ;;
esac
