# Build the daemon
FROM ghcr.io/kizzycode/buildbase-rust:ubuntu AS buildenv

RUN mv /root/.cargo /root/.cargo-persistent
RUN --mount=type=tmpfs,target=/root/.cargo \
    cp -a /root/.cargo-persistent/. /root/.cargo \
    && /root/.cargo/bin/cargo install --git https://github.com/KizzyCode/UrlRedirect-rust --bins url-redirect \
    && cp /root/.cargo/bin/url-redirect /root/


# Build the real container
FROM ubuntu:latest

COPY --from=buildenv /root/url-redirect /usr/bin/
COPY files/config.toml /etc/url-redirect/config.toml

RUN adduser --system --shell=/bin/nologin --uid=1000 urlredirect
USER urlredirect
CMD ["/usr/bin/url-redirect"]
