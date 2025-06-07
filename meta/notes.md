# IRAS ASR+ API Implementation Notes

## Critical Implementation Requirements

### Corppass Authentication Flow
1. **Server-to-Server Only**: Desktop applications require internet server proxy
2. **State Parameter**: Must be unique per request, used for XSRF protection
3. **Callback URL**: Must be exact match with registered URL
4. **SSL Required**: Self-signed certificates not accepted

### Client Credentials Management
- **Client ID**: Unique per registered app
- **Client Secret**: Keep secure, reset if compromised
- **App Name**: Should reflect actual software name
- **Changes**: Require 1-2 weeks to process, avoid if possible

### Multi-Client Architecture

#### Scenario A: Single Domain/Server
- One callback URL handles all client requests
- Use state parameter to identify clients
- Manage tokens centrally

#### Scenario B: Multi-Domain/Private Servers
- Requires proxy/gateway server
- Central callback URL for auth code exchange
- Distribute tokens to respective domains

## Environment-Specific Notes

### Sandbox Environment
- **Purpose**: Testing and validation only
- **Whitelisting**: Form C-S API requires account whitelisting
- **Test Data**: Use provided test case scenarios
- **Validation**: Must complete before production access

### Production Environment
- **Connectivity Test**: Required before go-live
- **First Submission**: Coordinate with IRAS for verification
- **Client Rollout**: Start with one client, expand after verification

## Data Submission Guidelines

### GST Returns (F5/F8)
- **Quarterly**: Submit by due dates
- **Validation**: Front-end validations required
- **Format**: JSON payload with financial data
- **Testing**: Use provided test case scenarios

### Form C-S Submissions
- **Annual**: Submit by end November
- **Complexity**: More