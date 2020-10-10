FROM elixir:1.9-alpine

RUN set -ex && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    bash \
    git \
    inotify-tools \
    nodejs-npm

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix archive.install --force hex phx_new 1.5.0

ENV APP_DIR=/app
WORKDIR $APP_DIR

COPY mix.exs mix.lock $APP_DIR/
RUN mix deps.get

COPY config/ $APP_DIR/config
RUN mix deps.compile

COPY assets/ $APP_DIR/assets
RUN cd $APP_DIR/assets && npm install && node node_modules/webpack/bin/webpack.js --mode development

COPY . $APP_DIR/
RUN mix compile

CMD ["mix", "phx.server"]
