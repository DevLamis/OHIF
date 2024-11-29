# syntax=docker/dockerfile:1.7-labs
# This dockerfile is used to publish the `ohif/app` image on dockerhub.
#
# It's a good example of how to build our static application and package it
# with a web server capable of hosting it as static content.
#
# docker build
# --------------
# If you would like to use this dockerfile to build and tag an image, make sure
# you set the context to the project's root directory:
# https://docs.docker.com/engine/reference/commandline/build/
#
#
# SUMMARY
# --------------
# This dockerfile has two stages:
#
# 1. Building the React application for production
# 2. Setting up our Nginx (Alpine Linux) image w/ step one's output
#


# syntax=docker/dockerfile:1.7-labs
# This dockerfile is used to publish the `ohif/app` image on dockerhub.
#
# It's a good example of how to build our static application and package it
# with a web server capable of hosting it as static content.
#
# docker build
# --------------
# If you would like to use this dockerfile to build and tag an image, make sure
# you set the context to the project's root directory:
# https://docs.docker.com/engine/reference/commandline/build/
#
#
# SUMMARY
# --------------
# This dockerfile is used as an input for a second stage to make things run faster.
#


# Stage 1: Build the application
# docker build -t ohif/viewer:latest .
# Copy Files
FROM node:20 as builder
RUN apt-get update && apt-get install -y build-essential python3
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
RUN yarn config set workspaces-experimental true
# RUN npm install -g lerna@7.4.2
ENV PATH=/usr/src/app/node_modules/.bin:$PATH

# Do an initial install and then a final install
COPY package.json yarn.lock preinstall.js lerna.json ./
COPY --parents ./addOns/package.json ./addOns/*/*/package.json ./extensions/*/package.json ./modes/*/package.json ./platform/*/package.json ./
# Run the install before copying the rest of the files
RUN yarn install
# Copy the local directory
COPY --link --exclude=node_modules --exclude=yarn.lock --exclude=package.json . .
# Do a second install to finalize things after the copy
RUN yarn install

# Build here
# After install it should hopefully be stable until the local directory changes
ENV QUICK_BUILD true
# ENV GENERATE_SOURCEMAP=false
ENV REACT_APP_CONFIG=config/default.js
RUN yarn run build

# Stage 3: Bundle the built application into a Docker container
# which runs Nginx using Alpine Linux
FROM nginxinc/nginx-unprivileged:1.25-alpine as final
#RUN apk add --no-cache bash
ENV PORT=80
RUN rm /etc/nginx/conf.d/default.conf
USER nginx
COPY --chown=nginx:nginx .docker/Viewer-v3.x /usr/src
RUN chmod 777 /usr/src/entrypoint.sh
COPY --from=builder /usr/src/app/platform/app/dist /usr/share/nginx/html
# In entrypoint.sh, app-config.js might be overwritten, so chmod it to be writeable.
# The nginx user cannot chmod it, so change to root.
USER root
RUN chmod 666 /usr/share/nginx/html/app-config.js
USER nginx
ENTRYPOINT ["/usr/src/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
