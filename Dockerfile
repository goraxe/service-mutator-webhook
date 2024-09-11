FROM debian:bookworm-slim
WORKDIR /opt
COPY ./bin/mutating-webhook .
CMD ["./mutating-webhook", "--tls-cert", "/etc/opt/tls.crt", "--tls-key", "/etc/opt/tls.key"]
