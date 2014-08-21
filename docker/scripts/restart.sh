docker stop nginx
docker stop app
docker rm nginx
docker rm app

docker run -d -p 3000:3000 \
    -v /app/rails_app:/app \
    --name app \
    rails_app:latest

docker run -d -p 80:80 \
    --link app:app \
    --volumes-from app \
    --name nginx \
    my_nginx
