FROM golang:1.18.4-alpine3.16 as build
LABEL builder=true
WORKDIR /go/src/app
COPY go.mod ./
COPY go.sum ./
COPY api ./api
COPY pkg ./pkg
RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app api/main.go

FROM gcr.io/distroless/static-debian11:nonroot
COPY --from=build /go/bin/app /
ENTRYPOINT ["/app"]