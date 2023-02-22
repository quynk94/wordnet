FROM ruby:3.2.1

RUN apt-get update -qq \
	&& apt-get install -y --fix-missing --no-install-recommends \
	build-essential \
	libxml2-dev \
	libxslt1-dev \
	nano \
	tzdata \
	imagemagick \
	ffmpeg \
	vim \
	nodejs \
	npm \
	curl \
	&& apt-get clean

RUN gem install bundler:2.4.7

# Install Nodejs
ENV NODE_VERSION 18.14.1

RUN npm install n -g && n $NODE_VERSION

## install yarn
ENV YARN_VERSION 1.22.19
RUN npm install -g yarn@$YARN_VERSION

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

EXPOSE 3030

ENV BUNDLE_PATH /ruby_gems
