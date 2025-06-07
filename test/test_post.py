import os
import requests
import json
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv('meta/config.env')

# Base configuration
BASE_URL = os.getenv('BASE_URL', 'https://api.example.com')
API_KEY = os.getenv('API_KEY')
HEADERS = {
    'Authorization': f'Bearer {API_KEY}',
    'Content-Type': 'application/json',
    'User-Agent': 'API-Client/1.0'
}

def make_request(method, endpoint, data=None, params=None):
    """Universal request function"""
    url = f"{BASE_URL}/{endpoint.lstrip('/')}"
    
    try:
        response = requests.request(
            method=method.upper(),
            url=url,
            headers=HEADERS,
            json=data,
            params=params,
            timeout=30
        )
        response.raise_for_status()
        return response.json()
    
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")
        return None

def get_data(endpoint, params=None):
    """GET request wrapper"""
    return make_request('GET', endpoint, params=params)

def post_data(endpoint, data):
    """POST request wrapper"""
    return make_request('POST', endpoint, data=data)

def put_data(endpoint, data):
    """PUT request wrapper"""
    return make_request('PUT', endpoint, data=data)

def delete_data(endpoint):
    """DELETE request wrapper"""
    return make_request('DELETE', endpoint)

if __name__ == "__main__":
    # Test the connection
    result = get_data('/')
    print(f"API Response: {result}")