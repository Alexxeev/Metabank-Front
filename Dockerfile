FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app/

RUN flutter doctor -v
RUN flutter config --enable-web

COPY . .

RUN flutter build web --release

FROM nginx:alpine-slim

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

ENV API_URL=localhost:8080

ENTRYPOINT ash -c 'sed -i s/base_url_template/${API_URL}/g /usr/share/nginx/html/main.dart.js && /docker-entrypoint.sh && nginx -g "daemon off;"'