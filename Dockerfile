FROM golang:alpine AS builder

COPY . /go/src/github.com/rclone/rclone/
WORKDIR /go/src/github.com/rclone/rclone/

RUN apk add --no-cache make bash gawk git
RUN \
  CGO_ENABLED=0 \
  make
RUN ./rclone version

# Begin final image
FROM alpine:latest

RUN apk --no-cache add ca-certificates fuse3 tzdata && \
  echo "user_allow_other" >> /etc/fuse.conf

COPY --from=builder /go/src/github.com/rclone/rclone/rclone /usr/local/bin/

RUN addgroup -g 1009 rclone && adduser -u 1009 -Ds /bin/sh -G rclone rclone

WORKDIR /data
ENV XDG_CONFIG_HOME=/config

COPY --from=builder /go/src/github.com/rclone/rclone/startup.sh /home/rclone
RUN chmod 755 /home/rclone/startup.sh

CMD ["sh","/home/rclone/startup.sh"]
