FROM elixir:1.10-alpine

RUN set -ex && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    inotify-tools \
    nodejs-npm

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix archive.install --force hex phx_new

ENV MIX_BUILD_PATH /tmp/_build/
ENV MIX_DEPS_PATH /tmp/deps/

WORKDIR /app
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY assets/ /app/assets
RUN cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development

COPY . /app
RUN mix compile

CMD ["mix", "phx.server"]
