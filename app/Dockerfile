FROM grafana/promtail:make-images-static-26a87c9 as promtail

FROM golang:1.12-alpine as builder

RUN apk --update add git ca-certificates musl-dev && rm -rf /var/cache/apk/*
ADD . /src

WORKDIR /src
RUN CGO_ENABLED=0 GOOS=linux GOFLAGS='-mod=vendor' GO111MODULE=on go build -a -installsuffix cgo .

FROM alpine:latest

WORKDIR /app/
RUN apk --update add tini ca-certificates && rm -rf /var/cache/apk/*

COPY --from=promtail /usr/bin/promtail /usr/bin/
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /usr/local/go/lib/time/zoneinfo.zip
COPY --from=builder /src/app .

ADD entrypoint.sh /entrypoint.sh
ADD promtail.sh /promtail.sh

ENTRYPOINT ["/sbin/tini","-s", "--", "/entrypoint.sh"]