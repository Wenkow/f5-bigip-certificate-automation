# Let's Encrypt Certificate Automation with F5XC and BIG-IP

## Overview

This Terraform project automates the lifecycle of Let's Encrypt TLS certificates using DNS-01 challenges with **F5 Distributed Cloud (F5XC)**. Issued certificates are uploaded to **F5 BIG-IP**, where corresponding **Client SSL Profiles** are created or updated.

When executed on a recurring schedule (e.g., via CI/CD pipelines), the module also handles **automatic certificate renewal**, ensuring continued trust and uptime. **Wildcard** certificates are supported.

## Features

* ✅ Requests **Let's Encrypt certificates** (including wildcard domains)
* 🔒 Use **DNS-01 challenge** via **F5 Distributed Cloud**
* ⬆️ Uploads both the end-entity certificate and intermediate to BIG-IP
* 📎 Automatically includes the correct **Let's Encrypt intermediate CA** in the SSL certificate chain
* 🔁 **Automatically renews** certificates on repeated runs
* 🛡 Creates or updates **Client SSL Profiles** using uploaded certificates
* 📆 Supports **GitLab CI/CD** with remote Terraform state and state locking

## GitLab CI/CD Integration

This repository includes a `.gitlab-ci.yaml.dist` file which can be renamed to `.gitlab-ci.yaml` to enable pipeline automation in GitLab.

Benefits of GitLab CI/CD:

* Stores **Terraform state** securely and remotely
* Enables **state locking** to prevent concurrent runs
* Automates renewals and deployments on schedule or commit
* Gitops allows approval access using merge requests 

To enable remote state with GitLab, rename the `backend.tf.dist` file to `backend.tf`:

```bash
mv backend.tf.dist backend.tf
```

Your GitLab project must define the following **CI/CD variables**:

* `TF_VAR_email_address`
* `TF_VAR_F5XC_API_TOKEN`
* `TF_VAR_F5XC_TENANT_NAME`
* `TF_VAR_F5XC_GROUP_NAME`
* `TF_VAR_BIGIP_HOST`
* `TF_VAR_BIGIP_PORT`
* `TF_VAR_BIGIP_USERNAME`
* `TF_VAR_BIGIP_PASSWORD`
* `TF_VAR_global_parent_ssl_profile`

> ❗️ These variables are required for both the pipeline and Terraform execution. Do not hardcode credentials in the codebase.

## Required Variables

| Name                        | Description                                  |
| --------------------------- | -------------------------------------------- |
| `email_address`             | Email for Let's Encrypt account registration |
| `F5XC_API_TOKEN`            | API token for F5 Distributed Cloud           |
| `F5XC_TENANT_NAME`          | Tenant name in F5XC                          |
| `F5XC_GROUP_NAME`           | RRset name for DNS validation (alfanum chars)|
| `BIGIP_HOST`                | IP or hostname of the BIG-IP device          |
| `BIGIP_PORT`                | Port for BIG-IP REST API (if not 443)        |
| `BIGIP_USERNAME`            | Username for BIG-IP REST API                 |
| `BIGIP_PASSWORD`            | Password for BIG-IP REST API                 |
| `global_parent_ssl_profile` | Parent SSL profile to inherit on BIG-IP      |

## Cert Definition (`domains.tf`)

Certificates are defined in the `locals` block using the `dns_challenge_certs` map. See domains.tf.dist file.

Required fields per certificate:

* `cn`: Common Name of the certificate
* `san`: Subject Alternative Names (list of domain names)

Optional fields:

* `partition`: BIG-IP partition name (defaults to `Common` if not specified)
* `parent_ssl_profile`: Overrides the global SSL profile for that specific certificate

```hcl
locals {
  dns_challenge_certs = {
    "name_of_the_certificate_object_which_will_appear_in_bigip" = {
      cn  = "acme1.example.com"
      san = ["acme1.example.com"]
    }

    "wildcard.example.com" = {
      cn  = "*.example.com"
      san = ["*.example.com"]
    }

    "main.example.com" = {
      cn                  = "main.example.com"
      san                 = ["main.example.com"]
      partition           = "another_partition"
      parent_ssl_profile  = "custom-clientssl"
    }
  }
}
```

## Best Practices

* Use GitLab CI/CD to automate recurring runs and certificate renewals
* Enable Terraform state locking to avoid concurrent executions
* Store credentials and sensitive inputs as GitLab CI/CD variables
* Run the pipeline periodically (e.g., daily or weekly) to catch upcoming expirations

## Planned Improvements

* Secrets handling via HashiCorp Vault or GitLab's secret backends
* Renewal monitoring and alerting (e.g., email, Slack)
* More robust error handling and retry logic

## License

MIT License

---

**Maintained by:** Martin Kylian