FROM node:lts-slim

WORKDIR /front

COPY ./app/package*.json ./

RUN npm install

COPY ./app/ .

ENV CI=true CHOKIDAR_USEPOLLING=true

# CMD ["npm", "start"]
