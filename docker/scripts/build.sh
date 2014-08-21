DOCKER_REPOSITORY_BUCKET=$1
AWS_ACCESS_KEY_ID=$2
AWS_SECRET_KEY=$3

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Build containers from Dockerfiles
docker build -t rails_app /app/rails_app
docker build -t my_nginx /app/docker/nginx

# Build rails app
docker run -d -p 3000:3000 \
    -v /app/rails_app:/app \
    --name app \
    rails_app:latest

# Build nginx
docker run -d -p 80:80 \
    --link app:app \
    --volumes-from app \
    --name nginx \
    my_nginx

# Build registry
docker run -d -p 49000:5000 \
    --name registry \
    -e SETTINGS_FLAVOR=prod \
    -e DOCKER_REGISTRY_CONFIG=/docker-registry/config/config_sample.yml \
    -e AWS_BUCKET=$DOCKER_REPOSITORY_BUCKET \
    -e STORAGE_PATH=/ \
    -e AWS_KEY=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET=$AWS_SECRET_KEY \
    -e SEARCH_BACKEND=sqlalchemy \
    registry docker-registry
