FROM node:16-alpine3.11
WORKDIR /home/node
COPY package*.json /home/node/
RUN npm install
COPY . .
RUN chown -R node:node /home/node/
USER node
EXPOSE 8081
CMD [ "npm", "start" ]
