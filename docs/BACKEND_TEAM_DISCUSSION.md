# Frontend POC Integration: Request for Backend Team Input

## Context

Our design team is starting to build frontend POCs that need to interact with the CampaignManager backend. We want to establish a proper, repeatable process for enabling these POCs to authenticate and communicate with the API.

Before we document this process for the team, we'd like your input on the **recommended approach** given our architecture.

---

## What We're Trying to Enable

A designer or frontend developer creates a new React/Vite POC (running locally or on a preview URL) and needs to:

1. **Authenticate** with the CampaignManager API
2. **Call secured endpoints** (e.g., `/api/secured/campaign/`, `/api/secured/company/`)
3. **Develop independently** without needing the full admin-console running

Typical use cases:
- Building a custom campaign viewer
- Prototyping a new workflow UI
- Creating an embedded widget for external sites

---

## What We Found in the Codebase

We explored the existing infrastructure and found:

### CORS Configuration
- `CustomCORSFilter.java` uses the `ve.allowed-origins` property
- Origins must be explicitly whitelisted (no wildcard with credentials)

### API Key Authentication
- `UserApiKeyAuthFilter.java` supports `api-key` + `api-key-secret` headers
- Keys can be created via `/api/secured/user/api-key/` (requires permission)
- API key sessions have a 5-minute timeout vs. 24-hour for OAuth sessions

### Security Config
- `/api/public/**` - Open access
- `/api/secured/**` - Requires authentication
- OAuth2/OIDC is the primary auth method
- API keys are processed before the OAuth filter

---

## Questions for the Backend Team

### 1. CORS: What's the recommended approach for POC origins?

Options we've considered:
- **Option A:** Add each POC origin to `ve.allowed-origins` as needed
- **Option B:** Create a wildcard dev/staging config (e.g., `*.preview.velocityengine.com`)
- **Option C:** Run POCs through a proxy that's already whitelisted

**What do you recommend for local development (`localhost:3000`, etc.) vs. deployed previews?**

### 2. Authentication: Is the API key system the right path?

The existing API key system seems designed for this, but we want to confirm:
- Is this the intended use case for `UserApiKey`?
- Should POCs use the same keys as integrations/automation?
- Any concerns with the 5-minute session timeout for interactive POC development?
- Should we consider a separate "dev token" mechanism?

**Alternative pattern to consider:** The [BFF (Backend-for-Frontend) pattern](https://docs.duendesoftware.com/bff/) is now recommended for browser-based apps—it keeps tokens out of browser memory entirely by having a lightweight server-side component handle auth. Is this worth considering for POCs, or overkill for our use case?

### 3. Permissions: What permissions should a POC have?

When a POC authenticates via API key:
- Does it inherit the creating user's permissions?
- Should we create a dedicated "POC" role with scoped access?
- Any endpoints that should be off-limits for POCs?

### 4. Environment: Which backend should POCs target?

- Should POCs hit a dedicated dev/staging environment?
- Is there a sandbox environment available?
- Any rate limiting concerns if multiple designers are prototyping?

### 5. Security Considerations

Current 2026 best practices emphasize:
- **Explicit origin whitelisting** - wildcards only for public, read-only APIs
- **Least privilege tokens** - scoped access, easy revocation
- **HTTPS only** for all CORS-enabled endpoints
- **Server-side origin validation** to prevent spoofing

Note: [68% of organizations lack complete API visibility](https://www.stackhawk.com/blog/best-api-security-solutions/) according to StackHawk's 2026 State of AppSec survey—we want to make sure our POC access is tracked and revocable.

**Are there any security policies or constraints we should be aware of?**

---

## What We'd Like to Document

Once we have your input, we plan to create:

1. **A "Connecting to CampaignManager API" guide** for designers/frontend devs
2. **A checklist** for backend/DevOps when enabling a new POC
3. **Standard axios configuration** for POC projects

---

## References (2026)

- [NestJS CORS 2026 Production Guide](https://copyprogramming.com/howto/nestjs-enable-cors-in-production) - Current CORS configuration patterns
- [API Security Trends 2026 - Curity](https://curity.io/blog/api-security-trends-2026/) - OAuth improvements, token exchange
- [BFF Security Framework - Duende](https://docs.duendesoftware.com/bff/) - Backend-for-Frontend pattern
- [API Security Best Practices - Aikido](https://www.aikido.dev/blog/api-security-best-practices) - Authentication & authorization standards
- [Cyber Insights 2026: API Security - SecurityWeek](https://www.securityweek.com/cyber-insights-2026-api-security/) - Current threat landscape

---

## Next Steps

Please let us know:
1. Your recommended approach for each question above
2. Any concerns or constraints we should factor in
3. Who should be involved in implementing this process

We're happy to set up a quick call to discuss if that's easier.

Thanks!
