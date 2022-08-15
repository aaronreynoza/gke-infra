# create base image with all packages, proper entrypoint, and directories created
FROM node:16.13.0-alpine3.14 AS base

EXPOSE 3000
# all of our code will live in `/app`
WORKDIR /app

# using the base image, create an image containing all of our files
# and dependencies installed, devDeps and test directory included
FROM base AS dependencies

COPY package*.json ./
RUN npm i

COPY *.js ./

# release ready image, devDeps are pruned and tests removed for size control
FROM dependencies AS release

ENV NODE_ENV=production

# `node` user is created in base node image
# we want to use this non-root user for running the server in case of attack
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user
USER node

CMD ["npm", "start"]