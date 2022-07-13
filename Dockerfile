FROM golang:1.18.4-alpine3.16@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df as build
LABEL builder=true
WORKDIR /go/src/app
COPY go.mod ./
COPY go.sum ./
COPY api ./api
COPY pkg ./pkg
RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app api/main.go

FROM gcr.io/distroless/static-debian11:nonroot@sha256:59d91a17dbdd8b785e61da81c9095b78099cad8d7757cc108f49e4fb564ef8b3
COPY --from=build /go/bin/app /
ENTRYPOINT ["/app"]