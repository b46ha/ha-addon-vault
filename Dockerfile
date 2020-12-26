ARG VERSION=1.15.3
ARG BUILD_FROM
ARG TEMPIO_VERSION=2020.10.2

FROM vault AS builder
FROM homeassistant/home-assistant as habuilder


FROM ${BUILD_FROM}

# FROM hassioaddons/base:latest

# Create a vault user and group first so the IDs get set the same way,
# even as the rest of this may change over time.
RUN addgroup vault && \
    adduser -S -G vault vault

# Set up certificates, our base tools, and Vault.
RUN set -eux; \
    apk add --no-cache ca-certificates libcap su-exec dumb-init tzdata

COPY --from=builder /bin/vault /bin/vault
COPY --from=habuilder /usr/bin/tempio /usr/bin/tempio

RUN mkdir -p /vault/logs && \
    mkdir -p /vault/file && \
    mkdir -p /vault/config && \
    mkdir -p /vault/raft && \
    chown -R vault:vault /vault

# Expose the logs directory as a volume since there's potentially long-running
# state in there
# VOLUME /vault/logs

# Expose the file directory as a volume since there's potentially long-running
# state in there
# VOLUME /vault/raft

# 8200/tcp is the primary interface that applications use to interact with
# Vault.
EXPOSE 8200 8201

# The entry point script uses dumb-init as the top-level process to reap any
# zombie processes created by Vault sub-processes.
#
# For production derivatives of this container, you should add the IPC_LOCK
# capability so that Vault can mlock memory.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY vault.hcl.template  /vault/config/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["server"]

LABEL io.hass.version="VERSION" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"
