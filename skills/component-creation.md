# Skill: React Component Creation

## Purpose
Create well-structured React components following established patterns for maintainability and testability.

## When to Use
- Creating new UI components
- Building feature pages/views
- Adding reusable UI elements

## Project Conventions

### File Structure
```
src/
├── components/          # Reusable UI components
│   ├── ComponentName.tsx
│   └── ComponentName.test.tsx (if complex)
├── pages/               # Page-level components (route targets)
│   └── PageName.tsx
├── hooks/               # Custom hooks
│   └── useHookName.ts
└── store/               # Zustand stores
    └── storeName.ts
```

### Naming
- Components: PascalCase (`BookPreview.tsx`)
- Hooks: camelCase with `use` prefix (`useClickOutside.ts`)
- Stores: camelCase with `Store` suffix (`bookStore.ts`)

## Component Patterns

### 1. Simple Presentational Component
For UI elements with minimal logic:
```typescript
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export const Button = ({ label, onClick, variant = 'primary', disabled = false }: ButtonProps) => {
  return (
    <button
      className={`btn btn-${variant}`}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
};
```

### 2. Component with Store Connection
For components that read/write global state:
```typescript
import { useMyStore } from '@/store/myStore';

export const ItemList = () => {
  // Select only what you need (prevents unnecessary re-renders)
  const items = useMyStore((s) => s.items);
  const addItem = useMyStore((s) => s.addItem);
  const removeItem = useMyStore((s) => s.removeItem);

  return (
    <div className="item-list">
      {items.map((item) => (
        <ItemRow
          key={item.id}
          item={item}
          onRemove={() => removeItem(item.id)}
        />
      ))}
      <button onClick={addItem}>Add Item</button>
    </div>
  );
};
```

### 3. Component with Local + Global State
When you need both:
```typescript
export const EditableTitle = ({ itemId }: { itemId: string }) => {
  // Global state
  const title = useMyStore((s) =>
    s.items.find((c) => c.id === itemId)?.title ?? ''
  );
  const updateTitle = useMyStore((s) => s.updateItemTitle);

  // Local state for edit mode
  const [isEditing, setIsEditing] = useState(false);
  const [draft, setDraft] = useState(title);

  const handleSave = () => {
    updateTitle(itemId, draft);
    setIsEditing(false);
  };

  if (isEditing) {
    return (
      <input
        value={draft}
        onChange={(e) => setDraft(e.target.value)}
        onBlur={handleSave}
        onKeyDown={(e) => e.key === 'Enter' && handleSave()}
        autoFocus
      />
    );
  }

  return <h2 onClick={() => setIsEditing(true)}>{title}</h2>;
};
```

### 4. Component with Custom Hook Extraction
When logic becomes complex, extract to a hook:
```typescript
// hooks/useItemEditor.ts
export const useItemEditor = (itemId: string) => {
  const item = useMyStore((s) =>
    s.items.find((c) => c.id === itemId)
  );
  const updateContent = useMyStore((s) => s.updateItemContent);

  const [isSaving, setIsSaving] = useState(false);

  const save = useCallback(async (content: string) => {
    setIsSaving(true);
    updateContent(itemId, content);
    // Could add debounce, API sync, etc.
    setIsSaving(false);
  }, [itemId, updateContent]);

  return { item, save, isSaving };
};

// components/ItemEditor.tsx
export const ItemEditor = ({ itemId }: { itemId: string }) => {
  const { item, save, isSaving } = useItemEditor(itemId);

  if (!item) return null;

  return (
    <div className="item-editor">
      <h2>{item.title}</h2>
      <RichTextEditor
        content={item.content}
        onChange={save}
        disabled={isSaving}
      />
    </div>
  );
};
```

### 5. Conditional Rendering Patterns
Avoid deep ternary chains. Use early returns or component mapping:

**Instead of:**
```typescript
// BAD - hard to read
return (
  <div>
    {isLoading ? (
      <Spinner />
    ) : error ? (
      <Error message={error} />
    ) : data ? (
      <DataView data={data} />
    ) : (
      <Empty />
    )}
  </div>
);
```

**Use:**
```typescript
// GOOD - early returns
if (isLoading) return <Spinner />;
if (error) return <Error message={error} />;
if (!data) return <Empty />;

return <DataView data={data} />;
```

**Or component mapping for tabs/views:**
```typescript
const viewComponents: Record<ViewType, React.FC> = {
  preview: PreviewView,
  edit: EditView,
  settings: SettingsView,
};

const ViewComponent = viewComponents[currentView];
return <ViewComponent />;
```

## Props Design Guidelines

### Required vs Optional
```typescript
interface Props {
  // Required - component won't work without it
  id: string;

  // Optional with sensible default
  variant?: 'small' | 'medium' | 'large';

  // Optional callback (component works without it)
  onClose?: () => void;
}
```

### Callback Naming
- `onClick`, `onChange`, `onSubmit` - for standard DOM events
- `onItemSelect`, `onItemRemove` - for domain-specific actions

### Children vs Render Props
```typescript
// Use children for simple composition
<Card>
  <CardHeader>Title</CardHeader>
  <CardBody>Content</CardBody>
</Card>

// Use render props for data-driven rendering
<DataFetcher
  url="/api/items"
  render={(data) => <ItemList items={data} />}
/>
```

## Checklist for New Components
- [ ] Props interface defined with clear types
- [ ] Sensible defaults for optional props
- [ ] Store selectors are granular (not selecting entire store)
- [ ] Complex logic extracted to custom hooks
- [ ] No deep ternary chains in JSX
- [ ] Loading/error/empty states handled
- [ ] Key prop used correctly in lists
- [ ] Component is focused (single responsibility)
