

FROM golang:1.22.1 as builder
ARG TARGETARCH
ARG TARGETOS
WORKDIR /go/src/app
COPY . .
RUN make build TARGETARCH=${TARGETARCH} TARGETOS=${TARGETOS} 

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/telebot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./telebot" ]