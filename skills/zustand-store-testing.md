# Skill: Zustand Store Testing

## Purpose
Generate comprehensive unit tests for Zustand stores following established patterns.

## When to Use
- After creating a new Zustand store
- When adding actions/state to an existing store
- When asked to add tests for stores

## File Conventions
- Test file: `{storeName}.test.ts` in same directory as store
- Import from `vitest`: `describe`, `it`, `expect`, `beforeEach`

## Pattern

### 1. Setup with State Reset
```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { useMyStore } from './myStore';

describe('myStore', () => {
  beforeEach(() => {
    // Reset state values WITHOUT replace:true (preserves actions)
    useMyStore.setState({
      // Reset all state properties to initial values
      someValue: '',
      someFlag: false,
      items: [],
    });
  });
```

**Critical:** Never use `setState({...}, true)` as it replaces the entire store including action functions.

### 2. Test Initial State
```typescript
  describe('initial state', () => {
    it('has correct initial values', () => {
      const state = useMyStore.getState();
      expect(state.someValue).toBe('');
      expect(state.someFlag).toBe(false);
      expect(state.items).toEqual([]);
    });
  });
```

### 3. Test Simple Setters
```typescript
  describe('setters', () => {
    it('setSomeValue updates someValue', () => {
      const { setSomeValue } = useMyStore.getState();
      setSomeValue('new value');
      expect(useMyStore.getState().someValue).toBe('new value');
    });

    it('setSomeFlag updates someFlag', () => {
      const { setSomeFlag } = useMyStore.getState();
      setSomeFlag(true);
      expect(useMyStore.getState().someFlag).toBe(true);
      setSomeFlag(false);
      expect(useMyStore.getState().someFlag).toBe(false);
    });
  });
```

### 4. Test Function Updater Patterns
For setters that accept `value | (prev) => value`:
```typescript
    it('setScale with function updater', () => {
      useMyStore.setState({ scale: 1.0 });
      const { setScale } = useMyStore.getState();

      setScale((prev) => prev + 0.1);
      expect(useMyStore.getState().scale).toBeCloseTo(1.1);
    });
```

### 5. Test Array Mutations (Add/Remove/Toggle)
```typescript
  describe('addItem', () => {
    it('creates item with correct structure', () => {
      const { addItem } = useMyStore.getState();
      addItem();

      const { items } = useMyStore.getState();
      expect(items).toHaveLength(1);
      expect(items[0].id).toBeDefined();
      expect(items[0].title).toBe('Item 1');
    });
  });

  describe('removeItem', () => {
    it('filters by ID correctly', () => {
      // Use explicit IDs to avoid Date.now() collision
      useMyStore.setState({
        items: [
          { id: 'item-1', title: 'First' },
          { id: 'item-2', title: 'Second' },
        ],
      });

      const { removeItem } = useMyStore.getState();
      removeItem('item-1');

      const { items } = useMyStore.getState();
      expect(items).toHaveLength(1);
      expect(items[0].id).toBe('item-2');
    });
  });

  describe('toggleItem', () => {
    it('adds ID when not present', () => {
      const { toggleItem } = useMyStore.getState();
      toggleItem('item-1');
      expect(useMyStore.getState().selectedIds).toContain('item-1');
    });

    it('removes ID when present', () => {
      useMyStore.setState({ selectedIds: ['item-1', 'item-2'] });
      const { toggleItem } = useMyStore.getState();
      toggleItem('item-1');
      expect(useMyStore.getState().selectedIds).not.toContain('item-1');
    });
  });
```

### 6. Test Update Actions
```typescript
  describe('updateItem', () => {
    it('updates only the specified item', () => {
      useMyStore.setState({
        items: [
          { id: 'item-1', content: '' },
          { id: 'item-2', content: '' },
        ],
      });

      const { updateItem } = useMyStore.getState();
      updateItem('item-1', 'content', 'Updated');

      const { items } = useMyStore.getState();
      expect(items[0].content).toBe('Updated');
      expect(items[1].content).toBe('');
    });
  });
```

## Common Gotchas

### Date.now() ID Collisions
When testing actions that generate IDs with `Date.now()`, consecutive calls may produce identical IDs:
```typescript
// BAD - may fail due to ID collision
addItem();
addItem();
expect(items).toHaveLength(2); // Could be 1 if same ID

// GOOD - use explicit test data
useMyStore.setState({
  items: [
    { id: 'item-1', ... },
    { id: 'item-2', ... },
  ],
});
```

### State Bleeding Between Tests
Always reset in `beforeEach`. If tests still affect each other, ensure you're resetting ALL state properties, including nested objects:
```typescript
beforeEach(() => {
  useMyStore.setState({
    nested: { deeply: { value: initialValue } }, // Reset entire object
  });
});
```

## Checklist
- [ ] `beforeEach` resets all state properties
- [ ] Initial state test covers all properties
- [ ] Each setter has at least one test
- [ ] Array mutations use explicit IDs in test data
- [ ] Function updater patterns are tested if supported
- [ ] Side effects (e.g., auto-expanding on add) are verified
