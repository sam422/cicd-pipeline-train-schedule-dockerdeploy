FROM node:16-alpine3.11
WORKDIR /home/node
COPY package*.json /home/node/
RUN npm install
RUN chown -R node:node /home/node/
USER node
COPY . .
EXPOSE 8081
CMD [ "npm", "start" ]
