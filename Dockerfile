# Build the daemon
FROM debian:stable-slim AS buildenv

ENV APT_PACKAGES build-essential ca-certificates curl
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends ${APT_PACKAGES}
RUN curl --tlsv1.3 --output rustup.sh https://sh.rustup.rs \
    && sh rustup.sh -y

RUN /root/.cargo/bin/cargo install url-redirect


# Build the real container
FROM debian:stable-slim

COPY --from=buildenv /root/.cargo/bin/url-redirect /usr/bin/
COPY ./files/config.toml /etc/url-redirect/config.toml

RUN adduser --system --shell=/bin/nologin --uid=1000 urlredirect
USER urlredirect
ENTRYPOINT [ "/usr/bin/url-redirect" ]
