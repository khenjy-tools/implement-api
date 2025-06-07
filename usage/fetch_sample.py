import os
import requests
import json
import base64
from pathlib import Path
from dotenv import load_dotenv
from urllib.parse import urlencode, parse_qs, urlparse

# Load environment variables
load_dotenv('meta/config.env')

# IRAS API Configuration
SANDBOX_BASE_URL = "https://apisandbox.iras.gov.sg/iras"
PRODUCTION_BASE_URL = "https://apiservices.iras.gov.sg/iras"
BASE_URL = os.getenv('BASE_URL', SANDBOX_BASE_URL)
CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECRET = os.getenv('CLIENT_SECRET')
CALLBACK_URL = os.getenv('CALLBACK_URL')

# API Endpoints
ENDPOINTS = {
    'corppass_auth': '/corppass/v1/auth',
    'corppass_token': '/corppass/v1/token',
    'gst_submission': '/gst/v1/submit',
    'form_cs_submission': '/formcs/v1/submit'
}

def get_headers(access_token=None):
    """Get request headers with optional authorization"""
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'IRAS-API-Client/1.0'
    }
    
    if access_token:
        headers['Authorization'] = f'Bearer {access_token}'
    
    return headers

def initiate_corppass_auth(state=None):
    """Step 1: Initiate Corppass authentication"""
    if not state:
        state = f"auth_{int(time.time())}"
    
    params = {
        'client_id': CLIENT_ID,
        'redirect_uri': CALLBACK_URL,
        'state': state,
        'response_type': 'code'
    }
    
    url = f"{BASE_URL}{ENDPOINTS['corppass_auth']}?" + urlencode(params)
    
    try:
        response = requests.get(url, headers=get_headers(), timeout=30)
        response.raise_for_status()
        
        # Return the redirect URL for client to access
        return {
            'redirect_url': response.json().get('redirect_url'),
            'state': state
        }
    except requests.exceptions.RequestException as e:
        print(f"Corppass auth initiation failed: {e}")
        return None

def exchange_auth_code(auth_code, state):
    """Step 2: Exchange auth code for access token"""
    auth_string = base64.b64encode(f"{CLIENT_ID}:{CLIENT_SECRET}".encode()).decode()
    
    headers = {
        'Authorization': f'Basic {auth_string}',
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    
    data = {
        'grant_type': 'authorization_code',
        'code': auth_code,
        'redirect_uri': CALLBACK_URL,
        'state': state
    }
    
    url = f"{BASE_URL}{ENDPOINTS['corppass_token']}"
    
    try:
        response = requests.post(url, headers=headers, data=data, timeout=30)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Token exchange failed: {e}")
        return None

def submit_gst_return(access_token, gst_data):
    """Submit GST Return (F5/F8)"""
    url = f"{BASE_URL}{ENDPOINTS['gst_submission']}"
    
    try:
        response = requests.post(
            url,
            headers=get_headers(access_token),
            json=gst_data,
            timeout=30
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"GST submission failed: {e}")
        return None

def submit_form_cs(access_token, form_cs_data):
    """Submit Corporate Income Tax Return (Form C-S)"""
    url = f"{BASE_URL}{ENDPOINTS['form_cs_submission']}"
    
    try:
        response = requests.post(
            url,
            headers=get_headers(access_token),
            json=form_cs_data,
            timeout=30
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Form C-S submission failed: {e}")
        return None

def health_check():
    """Test API connectivity"""
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=10)
        return response.status_code == 200
    except:
        return False

if __name__ == "__main__":
    # Test connectivity
    if health_check():
        print("✅ API connectivity successful")
    else:
        print("❌ API connectivity failed")
    
    # Example auth flow
    auth_result = initiate_corppass_auth()
    if auth_result:
        print(f"Redirect to: {auth_result['redirect_url']}")
        print(f"State: {auth_result['state']}")