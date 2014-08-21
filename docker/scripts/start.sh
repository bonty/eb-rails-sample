DOCKER_REPOSITORY_BUCKET=$1
AWS_ACCESS_KEY_ID=$2
AWS_SECRET_KEY=$3

docker start app
docker start nginx
docker start registry
