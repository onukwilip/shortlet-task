FROM node:gallium-alpine

WORKDIR /app

COPY ./package.json .

RUN npm install -f

COPY . .

RUN npx tsc --build

CMD [ "npm", "start" ]


