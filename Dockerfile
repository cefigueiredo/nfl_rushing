FROM elixir:1.10.4-alpine AS build

ENV MIX_ENV=prod

WORKDIR /nfl_rushing

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache openssl-dev make nodejs npm

RUN mix local.rebar --force && \
    mix local.hex --force

COPY . .

RUN mix deps.get --only ${MIX_ENV}
RUN mix compile

RUN npm ci --prefix assets
RUN cd assets && npm run deploy

RUN mix phx.digest
RUN mix release

FROM alpine:3.12

WORKDIR /app

RUN apk add ncurses-libs

COPY --from=build /nfl_rushing/_build/${MIX_ENV} /app

EXPOSE 4000

ENTRYPOINT ["/app/prod/rel/nfl_rushing/bin/nfl_rushing"]
CMD ["start"]
