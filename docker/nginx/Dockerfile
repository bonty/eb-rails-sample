FROM nginx

ADD nginx-sites.conf /etc/nginx.conf
RUN mkdir -p /var/log/nginx

ENTRYPOINT sed -i "s/localhost:3000/${APP_PORT_3000_TCP_ADDR}:${APP_PORT_3000_TCP_PORT}/" /etc/nginx.conf && nginx
