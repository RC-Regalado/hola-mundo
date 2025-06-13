FROM node:21-alpine3.18 as builder

WORKDIR /usr/src/app/
RUN  npm i -g pnpm 
COPY package*.json ./
COPY .npmrc ./
RUN pnpm install

COPY . .

RUN pnpm build

FROM  node:21-alpine3.18 AS dev

RUN npm i -g pnpm 

WORKDIR /usr/src/app/

COPY --from=builder ./usr/src/app/package*.json ./ 
COPY  --from=builder ./usr/src/app/dist ./dist
COPY --from=builder ./usr/src/app/.npmrc ./

RUN pnpm install --production \
  && pnpm prune --prod


FROM node:21-alpine3.18 as prod

WORKDIR /usr/src/app

COPY --from=dev ./usr/src/app/dist ./dist
COPY --from=dev  ./usr/src/app/node_modules ./node_modules 
COPY --from=dev ./usr/src/app/package*.json ./



CMD ["npm","run","start:prod"]

