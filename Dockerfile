# DEVELOPMENT DOCKERFILE ONLY
# NOT FOR PRODUCTION

FROM node:16.20.2-alpine3.18 AS builder

RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app

COPY --chown=node:node package.json yarn.lock ./

USER node
RUN yarn install --non-interactive --dev && yarn cache clean

# ----------------------------
FROM node:16.20.2-alpine3.18

USER node
WORKDIR /home/node/app
ENV NODE_ENV=development

# Copia arquivos do projeto
COPY --chown=node:node package.json yarn.lock ./
COPY --chown=node:node tsconfig.json ./
COPY --chown=node:node public ./public
COPY --chown=node:node src ./src

# Copia apenas as dependências já instaladas
COPY --chown=node:node --from=builder /home/node/app/node_modules ./node_modules

CMD ["yarn", "start"]
