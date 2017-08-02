FROM mhart/alpine-node:5.6.0

EXPOSE 3000

WORKDIR /app
ADD . /app
RUN npm install

CMD ["node", "server.js"]
