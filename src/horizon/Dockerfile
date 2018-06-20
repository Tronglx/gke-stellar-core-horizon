FROM stellar/base:latest

MAINTAINER Hiroki Tanaka <hiroki.tanaka@ttjworld.com>

ENV HORIZON_VERSION 0.13.0
ENV STELLAR_HOME /opt/stellar
ENV HORIZON_HOME ${STELLAR_HOME}/horizon

EXPOSE 8000

# dependencies
RUN apt-get update && \
  apt-get install -y curl git libpq-dev libsqlite3-dev libsasl2-dev postgresql-client postgresql postgresql-contrib sudo vim zlib1g-dev && \
  apt-get clean

# install horizon
RUN wget -O horizon.tar.gz https://github.com/stellar/go/releases/download/horizon-v${HORIZON_VERSION}/horizon-v${HORIZON_VERSION}-linux-amd64.tar.gz && \
  tar -zxvf horizon.tar.gz && \
  mv /horizon-v${HORIZON_VERSION}-linux-amd64/horizon /usr/local/bin && \
  chmod +x /usr/local/bin/horizon && \
  rm -rf horizon.tar.gz /horizon-v${HORIZON_VERSION}-linux-amd64

# setup user
RUN useradd --uid 10011001 --home-dir /home/stellar --no-log-init stellar && \
  mkdir -p /home/stellar && \
  chown -R stellar:stellar /home/stellar

# deploy files
RUN mkdir -p ${STELLAR_HOME}
RUN ln -s ${STELLAR_HOME} /stellar
RUN ln -s ${STELLAR_HOME}/horizon/etc/horizon.env /horizon.env
ADD bin ${HORIZON_HOME}/bin
RUN chmod +x ${HORIZON_HOME}/bin/*
ADD etc ${HORIZON_HOME}/etc/
RUN chown -R stellar:stellar ${HORIZON_HOME}
ADD start /
RUN chmod +x start

USER stellar
WORKDIR ${HORIZON_HOME}

CMD ["/init", "--", "/start"]
