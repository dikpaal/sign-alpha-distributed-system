# Real-Time Crypto Trading Data Pipeline

A real-time data acquisition pipeline that streams cryptocurrency market data using Go and C++.

## Features

- Real-time price streaming from Binance WebSocket API
- C++ signal processing (moving averages, high/low tracking)
- Thread-safe REST API endpoints
- WebSocket server for live price broadcasts

## Architecture

```
Binance WebSocket → Go Backend → C++ Processing
                         ↓
              WebSocket Server + REST API
```

## API Endpoints

- `GET /api/price` - Current BTC price
- `GET /api/stats` - Moving average, high, low from C++ processor
- `WS /ws` - Real-time price stream

## Build & Run

```bash
cd src
make
./trading-pipeline
```

## Test

```bash
curl http://localhost:8080/api/price
curl http://localhost:8080/api/stats
```
