# This is a multi stage docker buid

# stage 1
FROM golang:1.22 as base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

# stage 2 -> using distroless image for better security by reducing the image size.

FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD [ "./main" ]