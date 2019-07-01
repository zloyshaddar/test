FROM nginx

RUN apt-get update && apt-get install -y git && git clone https://github.com/ngx-api-utils/ngx-api-utils /tmp && cp -rf /tmp/src/* /usr/share/nginx/html
