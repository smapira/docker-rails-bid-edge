# syntax = docker/dockerfile:experimental

# FROM ruby:3.1.0 AS nodejs

# WORKDIR /tmp

# RUN curl -LO https://nodejs.org/dist/v12.18.0/node-v12.18.0-linux-x64.tar.xz
# RUN tar xvf node-v12.18.0-linux-x64.tar.xz
# RUN mv node-v12.18.0-linux-x64 node

FROM ruby:3.1-alpine

# COPY --from=nodejs /tmp/node /opt/node
# ENV PATH /opt/node/bin:$PATH

RUN --mount=type=cache,id=apk,target=/var/cache/apk apk add --update nodejs yarn
RUN --mount=type=cache,id=apk,target=/var/cache/apk \
    apk add --update \
    build-base \
    curl-dev \
    mysql-dev \
    sqlite-dev \
    ncurses-dev \
    linux-headers \
    tzdata

RUN adduser -u 1000 -D rails
RUN mkdir /app && chown rails /app
USER rails

# RUN curl -o- -L https://yarnpkg.com/install.sh | bash
# ENV PATH /home/rails/.yarn/bin:/home/rails/.config/yarn/global/node_modules/.bin:$PATH

RUN gem install bundler

WORKDIR /app

COPY --chown=rails Gemfile Gemfile.lock package.json yarn.lock /app/

RUN bundle config set app_config .bundle
RUN bundle config set path .cache/bundle

RUN --mount=type=cache,uid=1000,target=/app/.cache/bundle \
    bundle install && \
    mkdir -p vendor && \
    cp -ar .cache/bundle vendor/bundle
RUN bundle config set path vendor/bundle

COPY --chown=rails . /app

RUN --mount=type=cache,uid=1000,target=/app/.cache/node_modules \
    bin/yarn install --modules-folder .cache/node_modules && \
    cp -ar .cache/node_modules node_modules

# COPY --chown=rails . /app

RUN --mount=type=cache,uid=1000,target=/app/tmp/cache bin/rails assets:precompile

CMD ["bin/rails", "s", "-b", "0.0.0.0"]

