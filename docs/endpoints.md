# API Endpoints

## Base URL
### Sandbox Environment
https://apisandbox.iras.gov.sg/iras\



### Production Environment
https://apiservices.iras.gov.sg/iras

## Authentication Endpoints

### Initiate Corppass Authentication
**GET** `/corppass/v1/auth`

**Parameters:**
- `client_id` (required) - Your registered client ID
- `redirect_uri` (required) - Your registered callback URL
- `state` (required) - Unique identifier for request
- `response_type` (required) - Must be "code"

**Response:**
json
{
  "redirect_url": "https://stg-id.singpass.gov.sg/auth?..."
}


## Echange Auth Code for Token

### POST /corppass/v1/token

**Headers**
Authorization: Basic <base64_encoded_client_credentials>
Content-Type: application/x-www-form-urlencoded

**Body (form-encoded):**
grant_type=authorization_code
code=<auth_code_from_callback>
redirect_uri=<callback_url>
state=<same_state_from_auth>

**Response:**
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "read write"
}


# Submission Endpoints
## Submit GST Return (F5/F8)

### POST /gst/v1/submit

**Headers**
Authorization: Bearer <access_token>
Content-Type: application/json

**Request Body**
{
  "returnType": "F5",
  "taxPeriod": "2024Q1",
  "companyUEN": "200123456K",
  "submissionDate": "2024-01-31",
  "gstData": {
    "totalSales": 100000.00,
    "totalPurchases": 80000.00,
    "outputTax": 7000.00,
    "inputTax": 5600.00,
    "netGST": 1400.00
  }
}

**Response**
{
  "submissionId": "GST2024010001",
  "status": "SUCCESS",
  "message": "GST return submitted successfully",
  "timestamp": "2024-01-31T10:30:00Z"
}

### Submit Corporate Income Tax Return (Form C-S)
### POST /formcs/v1/submit

**Headers**
Authorization: Bearer <access_token>
Content-Type: application/json


**Request Body**
{
  "formType": "C-S",
  "yearOfAssessment": "2024",
  "companyUEN": "200123456K",
  "submissionDate": "2024-11-30",
  "financialData": {
    "revenue": 1000000.00,
    "totalExpenses": 800000.00,
    "adjustments": 0.00,
    "taxableIncome": 200000.00,
    "taxRate": 0.17,
    "taxPayable": 34000.00
  }
}


**Response**
{
  "submissionId": "CS2024110001",
  "status": "SUCCESS",
  "message": "Form C-S submitted successfully",
  "timestamp": "2024-11-30T14:45:00Z"
}


# Error Responses
## Standard Error Format
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Invalid request parameters",
    "details": [
      {
        "field": "companyUEN",
        "message": "Invalid UEN format"
      }
    ]
  },
  "timestamp": "2024-01-31T10:30:00Z"
}


## Common Error Codes
# Error Codes Reference

| Code | Description | Action |
|------|-------------|--------|
| INVALID_TOKEN | Access token expired or invalid | Re-authenticate |
| INVALID_REQUEST | Request validation failed | Check request format |
| RATE_LIMIT_EXCEEDED | Too many requests | Implement rate limiting |
| SERVER_ERROR | Internal server error | Retry with backoff |
| MAINTENANCE | System under maintenance | Check maintenance schedule |


## Rate Limiting

No specific rate limits documented
Implement reasonable delays between requests
Monitor response headers for rate limit information

## Maintenance Hours (Singapore Time)
### Sandbox Environment

Daily: 1:00 PM – 3:00 PM, 8:00 PM – 10:00 PM
Weekly: Wednesday 3:00 PM – 11:59 PM

### Production Environment

Weekly: Wednesday 2:00 AM – 6:00 AM, Sunday 2:00 AM – 8:30 AM










## Endpoints Overview

| Method | Endpoint     | Description     | Auth Required |
| ------ | ------------ | --------------- | ------------- |
| GET    | `/health`    | Health check    | No            |
| GET    | `/data`      | Get all data    | Yes           |
| POST   | `/data`      | Create new data | Yes           |
| PUT    | `/data/{id}` | Update data     | Yes           |
| DELETE | `/data/{id}` | Delete data     | Yes           |

## GET /data

Retrieve all data entries.

**Parameters:**

- `limit` (optional) - Number of results (default: 10)
- `offset` (optional) - Pagination offset (default: 0)

**Response:**
{
"data": [...],
"total": 100,
"limit": 10,
"offset": 0
}

## POST /data

### Create a new data entry.

\*\*\* Request Body:
{
"name": "string",
"value": "string",
"active": boolean
}

\*\*\* Response:
{
"id": "string",
"name": "string",
"value": "string",
"active": boolean,
"created_at": "2024-01-01T00:00:00Z"
}
