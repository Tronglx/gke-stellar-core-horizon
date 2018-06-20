FROM stellar/base:latest

MAINTAINER Hiroki Tanaka <hiroki.tanaka@ttjworld.com>

ENV STELLAR_CORE_VERSION 9.2.0-551-7561c1d5
ENV STELLAR_HOME /opt/stellar
ENV CORE_HOME ${STELLAR_HOME}/core

EXPOSE 11625
EXPOSE 11626

# dependencies
RUN apt-get update && \
  apt-get install -y curl git libpq-dev libsqlite3-dev libsasl2-dev postgresql-client postgresql postgresql-contrib sudo vim zlib1g-dev && \
  apt-get clean

# install stellar-core
RUN wget -O stellar-core.deb https://s3.amazonaws.com/stellar.org/releases/stellar-core/stellar-core-${STELLAR_CORE_VERSION}_amd64.deb && \
  dpkg -i stellar-core.deb && \
  rm stellar-core.deb

# setup user
RUN groupadd --gid 1000 stellar
RUN useradd --uid 10011001 --gid 1000 --home-dir /home/stellar --no-log-init stellar && \
  mkdir -p /home/stellar && \
  chown -R stellar:stellar /home/stellar

# deploy files
RUN mkdir -p ${STELLAR_HOME}
RUN ln -s ${STELLAR_HOME} /stellar
RUN ln -s ${STELLAR_HOME}/core/etc/stellar-core.cfg /stellar-core.cfg
ADD bin ${CORE_HOME}/bin
RUN mkdir -p ${CORE_HOME}/etc/
ADD etc ${CORE_HOME}/etc/
RUN chown -R stellar:stellar ${CORE_HOME}
ADD start /
RUN chmod +x start

USER stellar
RUN mkdir ${CORE_HOME}/work
WORKDIR ${CORE_HOME}/work

CMD ["/init", "--", "/start"]
