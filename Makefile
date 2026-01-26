.PHONY: all build clean run tui test docker docker-run docker-stop

# Default target
all: build

# Build both server and TUI
build: build-server build-tui

# Build server with C++ library
build-server:
	@echo "Building server..."
	cd server && g++ -shared -fPIC -o libprocess.so process.cpp -lpthread
	cd server && CGO_ENABLED=1 go build -o trading-pipeline .

# Build TUI client
build-tui:
	@echo "Building TUI client..."
	cd tui && go build -o tui-client .

# Run the server
run: build-server
	@echo "Starting server..."
	cd server && LD_LIBRARY_PATH=. ./trading-pipeline

# Run the TUI client
tui: build-tui
	@echo "Starting TUI..."
	cd tui && ./tui-client

# Run test script
test: build
	@echo "Running tests..."
	cd server && LD_LIBRARY_PATH=. ../scripts/test.sh

# Clean build artifacts
clean:
	rm -f server/libprocess.so server/trading-pipeline
	rm -f tui/tui-client

# Docker commands
docker:
	@echo "Building Docker image..."
	docker build -t trading-pipeline .

docker-run: docker
	@echo "Starting container..."
	docker-compose up -d
	@echo "Server running at http://localhost:8080"
	@echo "Run 'make tui' to connect"

docker-stop:
	@echo "Stopping container..."
	docker-compose down
