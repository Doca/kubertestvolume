FROM golang:1.11 AS build
ADD . /src
WORKDIR /src
RUN go get -d -v -t
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o go-kubertestvolume


FROM alpine:3.9
MAINTAINER 	Dorian Cantzen <cantzen@extrument.com>
RUN apk add curl
EXPOSE 3000
CMD ["go-kubertestvolume"]
HEALTHCHECK --interval=10s CMD wget -qO- localhost:3000

COPY --from=build /src/go-kubertestvolume /usr/local/bin/go-kubertestvolume
RUN chmod +x /usr/local/bin/go-kubertestvolume