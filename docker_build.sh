#!/bin/sh
docker run -v $(pwd):/opt/build --rm -it elixir-debian:9 /opt/build/bash_scripts/build.sh