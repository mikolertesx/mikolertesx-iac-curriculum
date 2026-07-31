# terraform-s3-curriculum

Nx monorepo for a React portfolio site and the AWS infrastructure that hosts it (S3 + CloudFront).

## Structure

```text
apps/
  web/                 # React (Vite) portfolio app
infra/                 # Terraform: S3, CloudFront, Route53, ACM
  modules/
    webBucket/
    cloudfrontDistribution/
```

| Project | Role |
|--------|------|
| `web` | React frontend (`npx nx serve web` / `npx nx build web`) |
| `infra` | Terraform stack; `plan` / `apply` depend on `web:build` |

## Prerequisites

- Node.js 20+
- npm
- Terraform (for infra targets)
- AWS credentials configured for the account that owns the S3 backend and site resources

## Frontend

```sh
npm install
npx nx serve web      # http://localhost:4200
npx nx build web      # → apps/web/dist
npx nx test web
```

## Infrastructure

Terraform lives in `infra/` and uploads the **built** web app from `apps/web/dist`.

```sh
npx nx run infra:init     # terraform init (once / after provider changes)
npx nx run infra:plan     # builds web, then terraform plan
npx nx run infra:apply    # builds web, then terraform apply
npx nx run infra:output
```

Or equivalently:

```sh
npm run infra:plan
npm run infra:apply
```

Remote state:

- Backend bucket: `terraform-locks-1447`
- Key: `global/curriculum/prod`
- Region: `us-east-1`

Site domain: `miguel-gro.click` (CloudFront + ACM + Route53).

## Deploy flow

1. `npx nx build web` produces static assets in `apps/web/dist`
2. Terraform `aws_s3_object` resources sync that directory to the website bucket
3. CloudFront serves the site (SPA error responses map 403/404 → `/index.html`)

## Notes

- Do not commit `.tfstate`, `.terraform/`, or `*.tfvars` with secrets
- Re-run `npx nx run infra:init` after cloning so providers/modules are installed under `infra/`
}
