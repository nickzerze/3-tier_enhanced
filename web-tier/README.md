# Web Tier

React frontend for the three-tier demonstration. In AWS, the application is
built during EC2 bootstrap and served by Nginx, which proxies `/api/` requests
to the internal Application Load Balancer.

```bash
npm ci
npm start                 # local development server
npm test -- --watchAll=false
npm run build             # production bundle
```

The browser uses relative `/api` URLs. A separate local API therefore requires
a development proxy or equivalent routing.

