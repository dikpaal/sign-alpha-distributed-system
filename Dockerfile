# Build stage
FROM golang:1.23-alpine AS builder

# Install build dependencies
RUN apk add --no-cache gcc g++ musl-dev

WORKDIR /app

# Copy server source
COPY server/ ./

# Build C++ shared library
RUN g++ -shared -fPIC -o libprocess.so process.cpp -lpthread

# Build Go binary
RUN CGO_ENABLED=1 go build -o trading-pipeline .

# Runtime stage
FROM alpine:latest

RUN apk add --no-cache libstdc++ libgcc

WORKDIR /app

# Copy binaries from builder
COPY --from=builder /app/trading-pipeline .
COPY --from=builder /app/libprocess.so .

# Expose port
EXPOSE 8080

# Set library path and run
ENV LD_LIBRARY_PATH=/app
CMD ["./trading-pipeline"]
