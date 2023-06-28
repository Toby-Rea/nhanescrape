FROM rust:1.67-slim AS builder
RUN cargo install html-query

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y curl jq parallel

COPY --from=builder /usr/local/cargo/bin/hq /usr/local/bin/hq

CMD [ "/bin/bash", "./scripts/jobs.sh" ]
