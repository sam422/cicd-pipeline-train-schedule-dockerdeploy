FROM node:16-alpine3.11
USER node
WORKDIR /home/node
COPY package*.json /home/node/.
RUN npm install
COPY . .
EXPOSE 8081
CMD [ "npm", "start" ]
