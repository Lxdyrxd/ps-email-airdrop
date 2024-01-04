FROM node:16-alpine

ENV APP_ENV=production
ENV APP_SECRET=nosecret
#should be overriden
ENV APP_URL=http://localhost:3000
ENV API_PORT=3000

ENV MYSQL_HOST=airdrop_db
ENV MYSQL_PORT=3306
ENV MYSQL_DB=airdrop
ENV MYSQL_USER=root
ARG MYSQL_PASSWORD
ENV MYSQL_POOL=5

ARG ADMIN_WALLET
ARG APILLON_KEY
ARG APILLON_SECRET
ARG COLLECTION_UUID

ARG SMTP_HOST
ARG SMTP_PORT
ARG SMTP_USERNAME
ARG SMTP_PASSWORD
ARG SMTP_EMAIL_FROM
ARG SMTP_NAME_FROM

RUN echo $MYSQL_HOST

ENV appDir /app
RUN mkdir -p /app

WORKDIR ${appDir}

# Install MySQL client
RUN apk --no-cache add mysql-client

RUN npm install -g typescript pm2@latest

ADD ./package-lock.json ${appDir}
ADD ./package.json ${appDir}
ADD ./ ${appDir}/

RUN npm install 
RUN npm run build

EXPOSE 3000
RUN chmod +x ./bin/docker-start.sh ./bin/create-database.sh
CMD ["./bin/docker-start.sh"]