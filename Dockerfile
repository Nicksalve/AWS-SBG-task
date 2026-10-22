# Small official nginx image
FROM docker.io/library/nginx:alpine

# Our own nginx settings
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Our website files
COPY index.html image.png /usr/share/nginx/html/

EXPOSE 80
