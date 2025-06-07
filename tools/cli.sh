#!/bin/bash

# IRAS ASR+ API CLI Helper
# Usage: ./cli.sh [command] [options]

set -e

# Load environment variables
if [ -f "meta/config.env" ]; then
    export $(cat meta/config.env | grep -v '^#' | xargs)
fi

# API Endpoints
SANDBOX_URL="https://apisandbox.iras.gov.sg/iras"
PRODUCTION_URL="https://apiservices.iras.gov.sg/iras"
BASE_URL=${BASE_URL:-$SANDBOX_URL}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test API connectivity
test_connection() {
    log_info "Testing connection to IRAS API..."
    
    if curl -s --connect-timeout 10 "$BASE_URL/health" > /dev/null; then
        log_info "✅ Connection successful"
    else
        log_error "❌ Connection failed"
        exit 1
    fi
}

# Initiate Corppass authentication
start_auth() {
    local state=${1:-"cli_$(date +%s)"}
    
    log_info "Initiating Corppass authentication..."
    
    local auth_url="$BASE_URL/corppass/v1/auth"
    local params="client_id=$CLIENT_ID&redirect_uri=$CALLBACK_URL&state=$state&response_type=code"
    
    local response=$(curl -s -G "$auth_url" --data-urlencode "$params" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json")
    
    echo "$response" | jq .
}

# Exchange auth code for token
exchange_token() {
    local auth_code=$1
    local state=$2
    
    if [ -z "$auth_code" ] || [ -z "$state" ]; then
        log_error "Usage: $0 token <auth_code> <state>"
        exit 1
    fi
    
    log_info "Exchanging auth code for access token..."
    
    local auth_header=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64)
    
    curl -s -X POST "$BASE_URL/corppass/v1/token" \
        -H "Authorization: Basic $auth_header" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=authorization_code&code=$auth_code&redirect_uri=$CALLBACK_URL&state=$state" | jq .
}

# Submit GST return
submit_gst() {
    local access_token=$1
    local gst_file=$2
    
    if [ -z "$access_token" ] || [ -z "$gst_file" ]; then
        log_error "Usage: $0 gst <access_token> <gst_data_file>"
        exit 1
    fi
    
    log_info "Submitting GST return..."
    
    curl -s -X POST "$BASE_URL/gst/v1/submit" \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d @"$gst_file" | jq .
}

# Submit Form C-S
submit_form_cs() {
    local access_token=$1
    local form_file=$2
    
    if [ -z "$access_token" ] || [ -z "$form_file" ]; then
        log_error "Usage: $0 formcs <access_token> <form_data_file>"
        exit 1
    fi
    
    log_info "Submitting Form C-S..."
    
    curl -s -X POST "$BASE_URL/formcs/v1/submit" \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d @"$form_file" | jq .
}

# Environment switch
switch_env() {
    local env=$1
    
    case "$env" in
        "sandbox"|"sb")
            export BASE_URL="$SANDBOX_URL"
            log_info "Switched to Sandbox environment"
            ;;
        "production"|"prod")
            export BASE_URL="$PRODUCTION_URL"
            log_info "Switched to Production environment"
            ;;
        *)
            log_error "Invalid environment. Use: sandbox or production"
            exit 1
            ;;
    esac
}

# Main command handler
case "$1" in
    "test")
        test_connection
        ;;
    "auth")
        start_auth "$2"
        ;;
    "token")
        exchange_token "$2" "$3"
        ;;
    "gst")
        submit_gst "$2" "$3"
        ;;
    "formcs")
        submit_form_cs "$2" "$3"
        ;;
    "env")
        switch_env "$2"
        ;;
    "help"|*)
        echo "IRAS ASR+ API CLI Tool"
        echo ""
        echo "Usage: $0 {command} [options]"
        echo ""
        echo "Commands:"
        echo "  test                    - Test API connectivity"
        echo "  auth [state]           - Initiate Corppass authentication"
        echo "  token <code> <state>   - Exchange auth code for token"
        echo "  gst <token> <file>     - Submit GST return"
        echo "  formcs <token> <file>  - Submit Form C-S"
        echo "  env <sandbox|prod>     - Switch environment"
        echo "  help                   - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 test"
        echo "  $0 auth my_state_123"
        echo "  $0 token ABC123 my_state_123"
        echo "  $0 gst eyJ0eXAi... gst_data.json"
        echo "  $0 env sandbox"
        ;;
esac