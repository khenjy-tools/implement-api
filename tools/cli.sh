#!/bin/bash

# API CLI Helper Script
# Usage: ./cli.sh [command] [options]

set -e  # Exit on error

# Load environment variables
if [ -f "meta/config.env" ]; then
    export $(cat meta/config.env | grep -v '^#' | xargs)
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# API Functions
api_get() {
    local endpoint=$1
    log_info "GET request to: $endpoint"
    curl -s -H "Authorization: Bearer $API_KEY" \
         -H "Content-Type: application/json" \
         "$BASE_URL/$endpoint" | jq .
}

api_post() {
    local endpoint=$1
    local data=$2
    log_info "POST request to: $endpoint"
    curl -s -X POST \
         -H "Authorization: Bearer $API_KEY" \
         -H "Content-Type: application/json" \
         -d "$data" \
         "$BASE_URL/$endpoint" | jq .
}

# Main command handler
case "$1" in
    "get")
        api_get "$2"
        ;;
    "post")
        api_post "$2" "$3"
        ;;
    "test")
        log_info "Testing API connection..."
        api_get "/"
        ;;
    "help"|*)
        echo "Usage: $0 {get|post|test} [endpoint] [data]"
        echo "Examples:"
        echo "  $0 get /users"
        echo "  $0 post /users '{\"name\":\"John\"}'"
        echo "  $0 test"
        ;;
esac