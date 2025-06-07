# Implementation Notes

## Authentication Notes
- API key expires every 90 days
- Refresh tokens are valid for 1 year
- Rate limiting resets every hour

## Quirks & Edge Cases
- Empty responses return `204 No Content`
- Bulk operations limited to 100 items
- File uploads max 10MB
- Special characters in URLs must be encoded

## Error Handling
- Always check for `error` field in response
- HTTP status codes follow REST standards
- Retry with exponential backoff for 5xx errors

## Performance Tips
- Use pagination for large datasets
- Cache responses when possible
- Batch requests when available
- Monitor rate limit headers

## Testing Notes
- Use sandbox environment: `https://sandbox-api.example.com`
- Test API key: `test_key_12345`
- Mock responses available in `/test` folder

## Common Issues
1. **401 Unauthorized**: Check API key format
2. **429 Too Many Requests**: Implement rate limiting
3. **500 Server Error**: Retry with backoff
4. **Timeout**: Increase timeout or check network