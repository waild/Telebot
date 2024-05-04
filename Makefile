APP=$(shell basename -s .git $(shell git remote get-url origin) | tr 'A-Z' 'a-z')
REGISTRY=ghcr.io/waild
VERSION=$(shell git describe --tags --abbrev=0 --always)-$(shell git rev-parse --short HEAD)
TARGETOS?=linux #linux darwin windows
TARGETARCH?=amd64 #amd64 arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v ./

get:
	go get

build: format get
	echo $(TARGETOS) $(TARGETARCH)
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o telebot -ldflags="-X 'Telebot/cmd.appVersion=${VERSION}'"

image:	
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg="TARGETOS=${TARGETOS}" --build-arg="TARGETARCH=${TARGETARCH}"

linux:
	TARGETOS=linux TARGETARCH=amd64 make image

mac:
	TARGETOS=darwin TARGETARCH=amd64 make image

windows:
	TARGETOS=windows TARGETARCH=amd64 make image

linuxarm: 
	TARGETOS=linux TARGETARCH=arm64 make image

windowsarm: 
	TARGETOS=windows TARGETARCH=arm64 make image

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf Telebot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}