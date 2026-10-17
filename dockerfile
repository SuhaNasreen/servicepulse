FROM nginx:1.30.6-alpine-slim
COPY site/ /usr/share/nginx/html/
EXPOSE 80