FROM debian:9

ENV VERSION 0.1.0
ENV CONSOLIDATED_DIR /app/releases/$VERSION/lib/ruzenkit-$VERSION/consolidated

WORKDIR /opt/build

RUN \
  apt-get update -y && \
  apt-get install -y git wget vim locales gnupg build-essential make gcc libc-dev && \
  locale-gen en_US.UTF-8 && \
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  rm erlang-solutions_1.0_all.deb && \
  apt-get update -y && \
  apt-get install -y esl-erlang=1:21.3.8.17-1 && \
  apt-get install -y elixir=1.8.2-1

CMD ["/bin/bash"]
