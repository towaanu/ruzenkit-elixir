#!/usr/bin/env bash

set -e

cd /opt/build

APP_NAME="$(grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')"
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"

mkdir -p /opt/build/rel/artifacts

mix deps.clean --all

rm -rf _build

# Install updated versions of hex/rebar
mix local.rebar --force
mix local.hex --if-missing --force

export MIX_ENV=prod

# Fetch deps and compile
mix deps.get
# Run an explicit clean to remove any build artifacts from the host
mix do clean, compile --force

# cd ./deps/comeonin && make clean && make
# cd ..
echo "HERE WE GO"
cd ./deps/bcrypt_elixir && make clean && make && mix deps.compile
cd ../..
# Build the release
mix release
# Copy tarball to output
cp "_build/prod/rel/$APP_NAME/releases/$APP_VSN/$APP_NAME.tar.gz" rel/artifacts/"$APP_NAME-$APP_VSN.tar.gz"

exit 0