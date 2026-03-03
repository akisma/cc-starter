# Skill: CampaignManager API Integration

## Purpose
Build frontend features that integrate with the CampaignManager backend API following established patterns.

## When to Use
- Creating new API calls to the CampaignManager backend
- Building features that fetch or mutate data
- Connecting React components to backend services

## API Architecture Overview

### Base URL Pattern
All authenticated endpoints use the `/api/secured/` prefix:
```
/api/secured/{resource}/              # List/Create
/api/secured/{resource}/{id}          # Get/Update/Delete
/api/secured/{resource}/{id}/{action} # Custom actions
```

### HTTP Client Setup
Use the shared axios instance:
```typescript
import axiosInstance from "../utils/axios/axiosInstance";
```

## API Function Patterns

### Naming Convention
```typescript
// Pattern: {action}{Entity}Api
getCampaignsApi()      // GET list
getCampaignDataApi()   // GET single
createCampaignApi()    // POST create
updateCampaignApi()    // PUT update
deleteCampaignApi()    // DELETE
renameCampaignApi()    // PATCH partial update
```

### Standard CRUD Operations

#### GET List (with pagination & filters)
```typescript
type GetCampaignsRes = {
  items: CampaignListItem[];
  totalItems: number;
};

export const getCampaignsApi = ({
  currentPage = 1,
  pageSize,
  companyId,
  name,
  sortBy,
  orderBy,
  signal,
}: {
  currentPage?: number;
  pageSize?: number;
  companyId?: number | null;
  name?: string;
  sortBy?: string;
  orderBy?: 'ASC' | 'DESC';
  signal?: AbortSignal;  // For request cancellation
}) => {
  return axiosInstance.get<GetCampaignsRes>(`/api/secured/global/campaign/`, {
    params: {
      companyId,
      pageNum: currentPage - 1,  // Backend is 0-indexed
      pageSize,
      name,
      sortBy,
      orderBy,
    },
    signal,
  });
};
```

#### GET Single
```typescript
export const getCampaignDataApi = ({
  campaignId,
}: {
  campaignId: number | string;
}) => {
  return axiosInstance.get<Campaign>(`/api/secured/campaign/${campaignId}`);
};
```

#### POST Create
```typescript
export const createCampaignApi = ({
  name,
  companyId,
  type,
}: {
  name: string;
  type: TCampaignType;
  companyId: number;
}) => {
  return axiosInstance.post<Campaign>(`/api/secured/campaign/`, {
    type,
    name,
    companyId,
  });
};
```

#### PUT Update
```typescript
export const updateCompanyApi = ({
  payload,
  companyId,
  rebuild,
}: {
  payload: TCompanyForm;
  companyId: number;
  rebuild: boolean;
}) => {
  return axiosInstance.put<TCompany>(
    `/api/secured/company/${companyId}`,
    { ...payload },
    { params: { rebuild } }
  );
};
```

#### DELETE
```typescript
export const deleteCampaignApi = ({
  campaignId,
  removeFiles,
}: {
  campaignId: number;
  removeFiles: boolean;
}) => {
  return axiosInstance.delete<string>(`/api/secured/campaign/${campaignId}`, {
    params: { removeFiles },
  });
};
```

#### PATCH Partial Update
```typescript
export const renameCampaignApi = ({
  campaignId,
  name,
}: {
  campaignId: number;
  name: string;
}) => {
  return axiosInstance.patch<void>(
    `/api/secured/campaign/${campaignId}/rename`,
    { name }
  );
};
```

### Custom Actions
```typescript
// PUT for state changes
export const publishCampaignApi = ({ campaignId }: { campaignId: number }) => {
  return axiosInstance.put<string>(
    `/api/secured/campaign/${campaignId}/publish/`,
    {}
  );
};

export const archiveCampaignApi = ({ campaignId }: { campaignId: number }) => {
  return axiosInstance.put<string>(
    `/api/secured/campaign/${campaignId}/archive/`,
    {}
  );
};

// POST for operations that create/trigger something
export const cloneCampaignApi = ({
  campaignId,
  cloneFormValues,
}: {
  campaignId: number;
  cloneFormValues: CloneFormValues;
}) => {
  const { name, ...params } = cloneFormValues;
  return axiosInstance.put<CloneCampaignRes>(
    `/api/secured/campaign/${campaignId}/clone/`,
    { name },
    { params }
  );
};
```

### File Upload
```typescript
export const uploadCompanyLogoApi = ({
  companyId,
  formData,
}: {
  companyId: number | string;
  formData: FormData;
}) => {
  return axiosInstance.post<TCompany>(
    `/api/secured/company/${companyId}/uploadLogo`,
    formData,
    {
      headers: { "Content-Type": "multipart/form-data" },
    }
  );
};

export const importCampaignApi = ({
  formData,
  companyId,
}: {
  formData: FormData;
  companyId: number;
}) => {
  return axiosInstance.post<CampaignListItem>(
    `/api/secured/campaign/${companyId}/import-campaign/`,
    formData,
    {
      headers: { "Content-Type": "multipart/form-data" },
    }
  );
};
```

### File Download
```typescript
export const exportCampaignApi = ({
  campaignId,
  params,
}: {
  campaignId: number;
  params: string;
}) => {
  return axiosInstance.get<Blob>(`/api/secured/campaign/${campaignId}/export`, {
    responseType: "blob",
    params: { initProps: params || undefined },
  });
};
```

## Common Endpoint Patterns

### Resource Hierarchy
```
/api/secured/campaign/{campaignId}
/api/secured/campaign/{campaignId}/phase/{phaseId}
/api/secured/campaign/{campaignId}/phase/{phaseId}/step/{stepId}
/api/secured/{campaignId}/cc/{stepId}              # CC Variables
/api/secured/chat/{campaignId}/{stepId}            # Chat
```

### Key Endpoints Reference

| Resource | List | Single | Create | Update | Delete |
|----------|------|--------|--------|--------|--------|
| Campaign | GET /global/campaign/ | GET /campaign/{id} | POST /campaign/ | PUT /campaign/ | DELETE /campaign/{id} |
| Company | GET /company/ | GET /company/{id} | POST /company/ | PUT /company/{id} | DELETE /company/{id} |
| Phase | GET /campaign/{id}/phases | - | POST /campaign/{id}/phase | PUT /campaign/{id}/phase | DELETE /campaign/{id}/phase/{phaseId} |
| Step | - | - | POST /campaign/{id}/phase/{phaseId}/step | PUT /campaign/{id}/phase/{phaseId}/step | DELETE /campaign/{id}/phase/{phaseId}/step/{stepId} |
| Chat | GET /chat/{campaignId}/{stepId} | GET /chat/{chatId} | POST /chat/{campaignId}/{stepId} | PUT /chat/{id} | DELETE /chat/{id} |

## Request Cancellation
Always support AbortSignal for list/search requests:
```typescript
// In API function
export const searchApi = ({ query, signal }: { query: string; signal?: AbortSignal }) => {
  return axiosInstance.get('/api/secured/search', { params: { query }, signal });
};

// In component/hook
const controller = new AbortController();
searchApi({ query, signal: controller.signal });

// On cleanup or new search
controller.abort();
```

## Error Handling
Errors are handled via a utility:
```typescript
import { handleRequestError, TCustomError } from "../../utils/handleRequestError";

try {
  const { data } = await someApi();
} catch (e: any) {
  const customError = handleRequestError(e);
  return rejectWithValue(customError);
}
```

## File Organization

**In the CampaignManager codebase** (`ve-admin-console/web-ui/src/api/`), API functions are organized by resource:

```
CampaignManager/ve-admin-console/web-ui/src/api/
├── campaigns.api.ts      # Campaign CRUD & actions
├── companies.api.ts      # Company CRUD
├── phases.api.ts         # Phase operations
├── steps.api.ts          # Step operations
├── chat.api.ts           # Chat & messages
├── cc-variables.api.ts   # Content component variables
├── assets.api.ts         # Asset management
├── computation.api.ts    # Computation/execution
├── document-templates.api.ts
├── env-variables.api.ts
├── user.api.ts
└── [resource].api.ts     # One file per resource domain
```

**When creating new API functions:** Add them to the existing file for that resource, or create a new `{resource}.api.ts` file if it's a new domain.

## Checklist for New API Functions
- [ ] Follow naming convention: `{action}{Entity}Api`
- [ ] Use typed parameters with destructuring
- [ ] Return typed axios response: `axiosInstance.get<ResponseType>`
- [ ] Include `signal?: AbortSignal` for list/search requests
- [ ] Use `params` for query parameters, body for POST/PUT data
- [ ] Place in appropriate `src/api/{resource}.api.ts` file
- [ ] Export response types if they'll be reused
