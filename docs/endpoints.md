# API Endpoints

## Base URL

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
