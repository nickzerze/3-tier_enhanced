# Repository Guidelines

## Project Structure & Module Organization

- `web-tier/` contains the React 18 frontend. Code lives in `src/`, reusable UI in `src/components/`, and static files in `public/` or `src/assets/`.
- `app-tier/` contains the Express API and MySQL access layer. `index.js` defines HTTP routes, `TransactionService.js` owns transaction operations, and `DbConfig.js` configures database connectivity.
- `aws-3tier-terraform/` defines AWS infrastructure, split by concern (`networking.tf`, `rds.tf`, `alb.tf`, and similar). Startup scripts use `entry-script_*.sh.tpl` templates.
- EC2 bootstrap generates the active Nginx proxy configuration. Deployment ZIPs are generated locally and must not be committed.

## Build, Test, and Development Commands

Run JavaScript commands from the relevant tier:

```powershell
cd web-tier; npm ci; npm start       # install and run the React dev server
cd web-tier; npm test                # run Jest in watch mode
cd web-tier; npm run build           # create a production build
cd app-tier; npm ci; node index.js   # start the API on port 4000
```

Validate infrastructure from `aws-3tier-terraform/` before proposing deployment:

```powershell
terraform fmt -check
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```

Never apply production changes without explicit approval and a reviewed plan.

## Coding Style & Naming Conventions

Use 2-space indentation in React files, semicolons, single quotes, and PascalCase component names such as `DatabaseDemo.js`. Name hooks and functions in camelCase. Keep component styles beside their component. Format `.tf` files with `terraform fmt`; use descriptive snake_case for Terraform identifiers.

## Testing Guidelines

Frontend tests use Jest and React Testing Library. Place tests beside code as `*.test.js` and test user-visible behavior. The app tier has only a placeholder `npm test`; add tests with new backend behavior. For Terraform changes, run `fmt`, `validate`, and inspect the plan.

## Commit & Pull Request Guidelines

History is limited and has no enforced convention. Use concise, imperative subjects, optionally scoped, for example `web: add transaction loading state`. Keep commits focused. Pull requests should explain the affected tier, validation performed, configuration or infrastructure impact, and rollback considerations. Link related issues and include screenshots for visible UI changes or relevant plan excerpts for Terraform changes.

## Security & Configuration

Do not commit `terraform.tfvars`, state files, credentials, private keys, or database passwords. Keep secrets in environment variables or AWS-managed secret storage. Treat `prod`, `production`, and `live` as production environments and require explicit approval before modifying them.
