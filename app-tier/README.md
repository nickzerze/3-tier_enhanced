# Application Tier

Express and MySQL API used by the three-tier demonstration. The service creates
the `transactions` table on startup and listens on port `4000` by default.

For local development, provide `DB_HOST`, `DB_USER`, `DB_PWD`, and
`DB_DATABASE`, then run:

```bash
npm ci
node index.js
```

Set `PORT` to change the listener and `CORS_ORIGIN` only when a trusted
cross-origin frontend needs direct API access. The deployed frontend uses the
same public origin through Nginx. The API has no authentication and is intended
for demonstration, not production data.

