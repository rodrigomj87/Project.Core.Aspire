FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG KEYCLOAK_AUTHORITY
ARG API_URL
ENV KEYCLOAK_AUTHORITY=$KEYCLOAK_AUTHORITY
ENV API_URL=$API_URL
RUN npm run build

FROM nginx:alpine AS final
COPY --from=build /app/dist/project-core-web/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
