# Skill: CampaignManager Data Models

## Purpose
Understand the core data models and their relationships in the CampaignManager system for building consistent frontend features.

## When to Use
- Designing new features that work with campaigns, companies, or content
- Understanding data relationships
- Creating TypeScript types for API responses
- Building forms that create/edit entities

## Core Entity Hierarchy

```
Company
  └── Campaign
        └── Phase
              └── Step
                    ├── CC Variables (content fields)
                    ├── Assets (files, images)
                    └── Chat (AI conversations)
```

## Entity Definitions

### Company
The top-level organizational unit. Users belong to companies.

```typescript
type TCompany = {
  id: number;
  name: string;
  nameUrl: string;              // URL-safe slug
  logoUri: string | null;
  disabled: boolean;
  securityDomain: string | null;
  modifiedBy: number | null;
  modifiedTime: string;
};

// Short version for lists/references
type TCompanyShortInfo = {
  id: number;
  name: string;
  nameUrl: string;
};
```

### Campaign
A content project containing phases and steps. Can be a working campaign or a template.

```typescript
type TCampaignType =
  | "CAMPAIGN"           // Active working campaign
  | "DRAFT_TEMPLATE"     // Template in development
  | "PUBLISHED_TEMPLATE"; // Template ready for use

type Campaign = {
  id: number;
  companyId: number;
  type: TCampaignType;
  name: string;
  nameUrl: string;
  archive: boolean;
  aiModelId: number | null;
  microSiteContextFolder: string | null;
  applicationId: string | null;
  applicationState: string | null;
  auditTrailDays: number;
  modifiedBy: number | null;
  modifiedTime: string;
};

// List item includes extra metadata
type CampaignListItem = Campaign & {
  companyName: string;
  companyLogo: string | null;
  modifiedByName: string | null;
  lastModifiedById: number | null;
  lastModifiedByName: string | null;
  lastModifiedTime: string | null;
  firstPhaseId: number | null;
  firstStepId: number | null;
};
```

### Phase
A major section/chapter within a campaign containing steps.

```typescript
type TPhase = {
  id: number;
  campaignId: number;
  seq: number;                        // Order position
  name: string;
  hidden: boolean;                    // Hidden from end users
  microSiteContextFolder: string | null;
  classes: string[] | null;           // CSS classes for styling
};

// Phase with its child steps
type PhaseWithSteps = TPhase & {
  steps: TStep[]
};
```

### Step
A single page/screen within a phase containing content fields.

```typescript
type TStep = {
  id: number;
  phaseId: number;
  seq: number;                        // Order position
  name: string;
  hidden: boolean;                    // Hidden from end users
  hiddenDocView: boolean;             // Hide document preview
  documentTemplateId: number | null;  // Associated template
  microSiteContextFolder: string | null;
  classes: string[] | null;           // CSS classes
  modifiedBy: number | null;
  modifiedTime: string;
};
```

### CC Variable (Content Component)
A content field within a step - the actual editable content.

```typescript
type TCcVariable = {
  id: number;
  stepId: number;
  key: string;                        // Unique identifier
  type: CCVariableType;
  content: string;                    // The actual content/value
  ovrContent: string | null;          // Override content
  result: string | null;              // Computed/AI-generated result
  prompt: string | null;              // AI prompt if applicable
  patchedPrompt: string | null;
  dependencies: string[];             // Keys this depends on
  classes: string[] | null;
  hidden: boolean;
  modifiedBy: number | null;
  modifiedTime: string;
};

type CCVariableType =
  | "TEXT"           // Plain text
  | "RICH_TEXT"      // HTML content
  | "IMAGE"          // Image reference
  | "PROMPT"         // AI prompt
  | "COMPUTED"       // Derived value
  | "SESSION_PROMPT" // Chat-based prompt
  // ... more types
```

### Asset
Files and generated content attached to a step.

```typescript
type AssetType = "GENERATED" | "UPLOADED" | "LINKED";

type AssetPublishState =
  | "CREATED"
  | "PUBLISHED"
  | "ERROR"
  | "READY_FOR_REVIEW"
  | "ASSET_APPROVED"
  | "PUBLICATION_APPROVED";

type TAsset = {
  id: number;
  campaignId: number;
  stepId: number;
  title: string;
  ref: string | null;                 // File reference/path
  type: AssetType;
  approved: boolean;
  publishToMicroSite: boolean;
  microSiteTargetFolder: string | null;
  publishedState: AssetPublishState;
  deployedUrl: string | null;
  operationDate: string | null;
  createdTime: string;
  modifiedBy: number | null;
  modifiedTime: string;
};
```

### Chat
AI conversation attached to a step.

```typescript
type Chat = {
  id: number;
  campaignId: number;
  stepId: number;
  title: string;
  systemPrompt: string | null;
  createdTime: string;
  modifiedTime: string;
};

type ChatMessage = {
  id: number;
  chatId: number;
  role: "user" | "assistant" | "system";
  content: string;
  timestamp: string;
};
```

### User
System user with company memberships.

```typescript
type TUser = {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  position: string;
  lastLoginTime: string;
  deleted: boolean;
  disabled: boolean;
};

// User's relationship to a company
type TCompanyUser = {
  userId: number;
  companyId: number;
  companyName: string;
  userName: string;
  email: string;
  position: string;
  securityGroups: (string | null)[];
  lastLoginTime: string;
  disabled: boolean;
};
```

## Common Patterns

### ModifiedInfo Mixin
Many entities track who modified them:
```typescript
type TModifiedInfo = {
  modifiedBy: number | null;
  modifiedTime: string;  // ISO date string
};
```

### Move/Reorder Operations
Phases and steps can be reordered:
```typescript
type TMovePhaseStepType = "AFTER" | "BEFORE";

// Used in move APIs
movePhaseApi({ phaseId, targetPhaseId, moveType: "AFTER" })
moveStepApi({ stepId, targetStepId, moveType: "BEFORE" })
```

### Pagination Response
List endpoints return paginated results:
```typescript
type PaginatedResponse<T> = {
  items: T[];
  totalItems: number;
};

// Request params
type PaginationParams = {
  pageNum: number;    // 0-indexed!
  pageSize: number;
  sortBy?: string;
  orderBy?: 'ASC' | 'DESC';
};
```

## URL Structure Patterns

### Frontend Routes
```typescript
// Campaign step view
/campaigns/company/{companyId}/campaign/{campaignId}/phase/{phaseId}/step/{stepId}

// Chat view
/campaigns/company/{companyId}/chat/{chatId}

// Company details
/companies/{companyId}/details/users
/companies/{companyId}/details/microsite
```

### API Endpoints
```typescript
// Resource follows hierarchy
/api/secured/company/{companyId}
/api/secured/campaign/{campaignId}
/api/secured/campaign/{campaignId}/phase/{phaseId}
/api/secured/campaign/{campaignId}/phase/{phaseId}/step/{stepId}
```

## ID Relationships Quick Reference

| Entity | Parent | Key Fields |
|--------|--------|------------|
| Company | - | `id` |
| Campaign | Company | `id`, `companyId` |
| Phase | Campaign | `id`, `campaignId`, `seq` |
| Step | Phase | `id`, `phaseId`, `seq` |
| CC Variable | Step | `id`, `stepId`, `key` |
| Asset | Step | `id`, `campaignId`, `stepId` |
| Chat | Step | `id`, `campaignId`, `stepId` |
| User | - | `id` |
| CompanyUser | Company, User | `companyId`, `userId` |

## Type File Organization
```
src/
├── globalTypes.d.ts          # Shared types across app
├── types/
│   ├── index.ts              # Re-exports
│   ├── campaigns.ts          # Campaign-specific types
│   ├── companies.ts          # Company types
│   └── ...
└── store/slices/
    ├── campaignSlice.ts      # Contains Campaign type
    ├── companiesSlice.ts     # Contains TCompany type
    └── ccVariablesSlice.ts   # Contains TCcVariable type
```

## Checklist for New Features
- [ ] Identify which entities the feature touches
- [ ] Check existing types in `globalTypes.d.ts` and store slices
- [ ] Use existing types rather than creating duplicates
- [ ] Follow the naming conventions (T prefix for types, I prefix for interfaces)
- [ ] Consider relationships - loading a Step may need Phase context
- [ ] Handle null/undefined for optional fields
