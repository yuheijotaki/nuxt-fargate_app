FROM node:12

RUN mkdir -p /var/www/nuxt-fargate_app
WORKDIR /var/www/nuxt-fargate_app
COPY ./ /var/www/nuxt-fargate_app
RUN npm run build

EXPOSE 3000

ENTRYPOINT ["npm", "run", "start"]
