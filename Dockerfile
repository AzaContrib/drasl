FROM golang:alpine AS builder

# Install build dependencies
RUN apk add --no-cache make gcc musl-dev nodejs npm

# Set up the workspace
WORKDIR /app
COPY . .

# Build and install the application
RUN make prebuild && make build
RUN make install prefix=/out/usr

# Create the final multi-stage image
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/usr /usr

# Set the entrypoint to the compiled binary
CMD ["/usr/bin/drasl"]
