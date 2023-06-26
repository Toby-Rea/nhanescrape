FROM rust:1.67-slim as builder
RUN cargo install html-query

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y curl jq parallel

COPY --from=builder /usr/local/cargo/bin/hq /usr/local/bin/hq

ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user

COPY . .

ENTRYPOINT [ "/bin/bash", "scrape.sh" ]