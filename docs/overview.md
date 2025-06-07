# IRAS ASR+ API Integration Overview

## About IRAS ASR+ (Accounting Software Register Plus)

IRAS ASR+ Digital Products provide APIs for seamless submission of tax returns directly from accounting and tax software to IRAS.

## Available APIs

### 1. Submission of GST Returns (F5, F8)
- **Frequency**: Quarterly submissions
- **Purpose**: Submit GST returns and listings directly to IRAS
- **Authentication**: Corppass required

### 2. Submission of Corporate Income Tax Returns (Form C-S)
- **Deadline**: By End November
- **Purpose**: Submit corporate tax returns seamlessly
- **Authentication**: Corppass required

### 3. Corppass Authentication API
- **Purpose**: Secure authentication and authorization
- **Integration**: Required once for all ASR+ APIs

## Environments

### Sandbox Environment (Testing)
- **URL**: `https://apisandbox.iras.gov.sg/iras`
- **Developer Portal**: `https://apisandbox.iras.gov.sg/iras/devportal/sb`
- **Purpose**: API validation and testing

### Production Environment (Live)
- **URL**: `https://apiservices.iras.gov.sg/iras`
- **Developer Portal**: `https://apiservices.iras.gov.sg/iras/devportal`
- **Purpose**: Live submissions

## Authentication Flow

1. **Initiate Corppass Authentication**
   - Server-to-server GET request to `/corppass/v1/auth`
   - Returns redirect URL for Singpass login

2. **User Authentication**
   - User redirected to Singpass login page
   - User provides consent for data submission

3. **Auth Code Exchange**
   - Auth code received at callback URL
   - Exchange code for access token via `/corppass/v1/token`

4. **API Submissions**
   - Use access token for authenticated API calls

## Key Requirements

### Technical Prerequisites
- Server-to-server connection support
- HTTP/2, TLS 1.2/1.3 protocol support
- Internet accessibility
- Valid SSL certificate
- Registered callback URL

### Callback URL Requirements
- Must use FQDN (Fully Qualified Domain Name)
- HTTPS with valid SSL certificate
- No IP addresses, port numbers, or wildcards
- No query parameters allowed
- Separate URLs for Sandbox and Production

## Important Contacts

- **API Marketplace & Onboarding**: digital_partnerships@iras.gov.sg
- **ASR+ Enquiries**: asr_plus@iras.gov.sg
- **API Technical Support**: api_support@iras.gov.sg

## Quick Start Guide

1. Register at go.gov.sg/asrplus-api
2. Set up Sandbox environment
3. Register callback URL
4. Complete validation testing
5. Set up Production environment
6. Perform connectivity test
7. Go live with first client
8. Apply for ASR+ listing