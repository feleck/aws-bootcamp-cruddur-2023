FROM node:16.20-bullseye-slim

ENV PORT=3000

COPY --chown=node:node . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install && apt update 
# && apt install -y curl
EXPOSE ${PORT}
USER node
CMD ["npm", "start"]