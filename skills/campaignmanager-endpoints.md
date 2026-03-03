# Skill: CampaignManager API Endpoints

## Purpose
Understand what backend endpoints are available in CampaignManager so you can build frontend features that interact with the API.

## When to Use
- Planning what features a POC can support
- Discovering available API operations
- Understanding the API structure before writing frontend code

## API Discovery

### Swagger UI (Dev/QA Only)
Swagger documentation is auto-generated and available on non-production environments:

| Environment | URL |
|-------------|-----|
| Local | `https://localhost:8080/swagger-ui.html` |
| Dev | `https://dev-app.velocityengine.co/swagger-ui.html` |
| QA | `https://qa-app.velocityengine.co/swagger-ui.html` |

**Note:** Swagger is NOT available in production. Documentation is auto-generated from controllers (no custom descriptions).

---

## API Structure

### Base Paths
```
/api/public/**    → No authentication required
/api/secured/**   → Requires authentication (OAuth or API key)
```

### URL Patterns
```
/api/secured/{resource}/                    → List / Create
/api/secured/{resource}/{id}                → Get / Update / Delete
/api/secured/{campaignId}/{resource}/       → Campaign-scoped resources
/api/secured/{campaignId}/{phaseId}/{resource}/  → Phase-scoped resources
```

---

## Available Endpoints by Domain

### Core Entities

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/company` | CompanyRest | Company CRUD, enable/disable |
| `/api/secured/campaign` | CampaignRest | Campaign CRUD, clone, publish, archive, migrate, git repo actions |
| `/api/secured/global` | GlobalEntitiesAccessRest | Cross-company campaign/template lists |
| `/api/secured/{campaignId}/phase` | PhaseRest | Phase CRUD within campaigns |
| `/api/secured/{campaignId}/{phaseId}/step` | StepRest | Step CRUD within phases |

### Content & Computation

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/{campaignId}/cc` | CCItemRest | CC Variables (content components) |
| `/api/secured/{campaignId}/env` | EnvItemRest | Environment variables |
| `/api/secured/{campaignId}/computation` | CampaignComputationRest | Run computations, execute campaigns, set ccItem execution state |
| `/api/secured/{campaignId}/template` | TemplateRest | Campaign templates |
| `/api/secured/document-template` | DocumentTemplateRest | Document templates |

### Chat & AI

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/chat` | ChatRest | Chat CRUD, messages |
| `/api/secured/chat-settings` | ChatSettingsRest | Chat configuration |
| `/api/secured/chat/override` | ChatOverrideRest | Chat overrides |
| `/api/secured/ai/model-configuration` | AIModelConfigurationRest | AI model configs |
| `/api/secured/llm-utils` | LLMUtilsRest | LLM utilities |
| `/api/secured/open-ai/api-key` | OpenAiApiKeyRest | OpenAI API key management |

### Assets & File Storage

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/{campaignId}/asset` | AssetRest | Campaign assets |
| `/api/secured/fs/public` | PublicRootFileStorageRest | Public file storage |
| `/api/secured/fs/private` | PrivateRootFileStorageRest | Private file storage |
| `/api/secured/fs/public-companies/` | PublicCompanyFileStorageRest | Company public files |
| `/api/secured/fs/private-companies` | PrivateCompanyFileStorageRest | Company private files |
| `/api/secured/fs/template/{templateName}` | TemplateFileStorageRest | Template files |
| `/api/secured/app/{applicationId}/fs` | ApplicationFileStorageRest | Application files |

### Company Features

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/company/{companyId}/microsite` | CompanyMicroSiteRest | Microsite config |
| `/api/secured/company/{companyId}/microsite/fs` | MicroSiteFileStorageRest | Microsite files |
| `/api/secured/company/{companyId}/audit/config` | CompanyAuditConfigurationRest | Audit settings |
| `/api/secured/microsite/{micrositeId}/user` | MicrositeUserRest | Microsite users |

### Users & Permissions

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/user` | UserRest | User CRUD, github auth |
| `/api/secured/user/api-key` | UserApiKeyRest | API key management |
| `/api/secured/user-preferences` | UserPreferencesRest | User preferences |
| `/api/secured/user/{userId}/permissions-global` | UserGlobalPermissionsRest | Global permissions |
| `/api/secured/user/{userId}/permissions-company/{companyId}` | UserCompanyPermissionsRest | Company permissions |
| `/api/secured/user/{userId}/permissions-override/global` | GlobalPermissionsOverrideRest | Permission overrides |
| `/api/secured/user/{userId}/permissions-override/company/{companyId}` | CompanyPermissionsOverrideRest | Company overrides |
| `/api/secured/permissions-group` | PermissionsGroupRest | Permission groups |
| `/api/secured/sys-permissions` | SysPermissionsRest | System permissions |

### Internationalization

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/i18n` | GlobalI18NRest | Global labels/translations |
| `/api/secured/campaign/{campaignId}/i18n` | CampaignI18NRest | Campaign-specific labels |
| `/api/secured/dictionary` | DictionaryRest | Dictionary entries |

### Audit & System

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/audit-bt` | AuditBTRest | Audit trail |
| `/api/secured/audit-bt/{uuid}/revision` | AuditRest | Audit revisions |
| `/api/secured/asset/` | AssetAuditRest | Asset audit |
| `/api/secured/system` | SystemRest | System info |
| `/api/secured/comment` | CommentRest | Comments |

### Applications & Integrations

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/secured/app` | ApplicationRest | Applications CRUD |
| `/api/secured/intercom` | IntercomHelperRest | Intercom integration |

### Public Endpoints (No Auth Required)

| Endpoint Base | Controller | Purpose |
|---------------|------------|---------|
| `/api/public` | PublicRest | Public operations |
| `/api/public/website` | WebSiteMetadataRest | Website metadata |

---

## Common Operations

### List Campaigns
```
GET /api/secured/global/campaign/
Query params: companyId, pageNum, pageSize, types, name, sortBy, orderBy
```

### Get Campaign
```
GET /api/secured/campaign/{campaignId}
```

### Get Campaign with Full Data
```
GET /api/secured/campaign/{campaignId}/data
Query params: initProps (e.g., "I18N", "ENV,CC,I18N")
```

### List Phases & Steps
```
GET /api/secured/{campaignId}/phase/with-steps
```

### Get CC Variables for Step
```
GET /api/secured/{campaignId}/cc/{stepId}
```

### Update CC Variable Content
```
PUT /api/secured/{campaignId}/cc/{stepId}/content/bulk
Body: { "key1": "value1", "key2": "value2" }
```

### Chat Operations
```
GET  /api/secured/chat/{campaignId}/{stepId}     → List chats for step
POST /api/secured/chat/{campaignId}/{stepId}     → Create chat
GET  /api/secured/chat/{chatId}/messages         → Get messages
POST /api/secured/chat/{chatId}/message          → Send message
```

---

## Source Code Reference

Backend controllers are located at:
```
CampaignManager/commons-service-api/src/main/java/com/ve/cm/web/api/
```

To understand an endpoint's full capabilities, read the corresponding `*Rest.java` file.

---

## What Can You Build?

Based on these endpoints, a POC can:

| Feature | Key Endpoints |
|---------|---------------|
| Campaign browser/viewer | `/global/campaign/`, `/campaign/{id}` |
| Content editor | `/cc/{stepId}`, `/cc/{stepId}/content/bulk` |
| Chat interface | `/chat/`, `/chat/{id}/messages` |
| Asset manager | `/asset/`, file storage endpoints |
| User/permissions admin | `/user/`, `/permissions-*` |
| Company management | `/company/`, `/company/{id}/microsite` |
| Template browser | `/document-template/`, `/template/` |

---

## Checklist Before Building

- [ ] Identify which endpoints your feature needs
- [ ] Check Swagger UI on dev for exact request/response shapes
- [ ] Verify you have appropriate permissions for those endpoints
- [ ] Confirm CORS is configured for your POC origin (coordinate with backend)
- [ ] Set up authentication (API key or OAuth - coordinate with backend)
