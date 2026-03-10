FROM node:20 as BUILD
WORKDIR /app
COPY package*.json /app/
RUN npm ci
COPY . . 
RUN npm run build 

FROM nginx:alpine 
COPY --from=BUILD /app/dist /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]
