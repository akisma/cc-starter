# Skill: Store-First Feature Development

## Purpose
Build features by designing state management first, then UI. This produces more testable, decoupled code with clear data flow.

## When to Use
- Building new features with significant state
- Adding CRUD operations for domain entities
- Features with complex user interactions
- When multiple components need shared state

## Process Overview

```
1. Define State Shape    →  What data does this feature need?
2. Define Actions        →  What operations modify this data?
3. Create Store + Tests  →  Implement and verify state logic
4. Build UI Components   →  Connect components to store
```

## Step 1: Define State Shape

Ask these questions:
- What data does this feature display?
- What data does the user input/modify?
- What loading/error states exist?
- What UI state is needed (expanded, selected, etc.)?

**Example: Comments Feature**
```typescript
interface Comment {
  id: string;
  parentId: string;
  content: string;
  author: string;
  createdAt: Date;
  isResolved: boolean;
}

interface CommentState {
  // Data
  comments: Comment[];

  // UI State
  expandedCommentIds: string[];
  editingCommentId: string | null;

  // Loading States
  isLoadingComments: boolean;
  isSavingComment: boolean;
}
```

## Step 2: Define Actions

Identify all state mutations:
```typescript
interface CommentActions {
  // CRUD
  addComment: (parentId: string, content: string) => void;
  updateComment: (id: string, content: string) => void;
  deleteComment: (id: string) => void;
  resolveComment: (id: string) => void;

  // UI Actions
  toggleCommentExpanded: (id: string) => void;
  setEditingComment: (id: string | null) => void;

  // Async
  fetchComments: (parentId: string) => Promise<void>;
}
```

## Step 3: Create Store with Tests

### 3a. Write Tests First (TDD approach)
```typescript
// commentStore.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { useCommentStore } from './commentStore';

describe('commentStore', () => {
  beforeEach(() => {
    useCommentStore.setState({
      comments: [],
      expandedCommentIds: [],
      editingCommentId: null,
      isLoadingComments: false,
      isSavingComment: false,
    });
  });

  describe('addComment', () => {
    it('adds comment with correct structure', () => {
      const { addComment } = useCommentStore.getState();
      addComment('parent-1', 'Great point!');

      const { comments } = useCommentStore.getState();
      expect(comments).toHaveLength(1);
      expect(comments[0]).toMatchObject({
        parentId: 'parent-1',
        content: 'Great point!',
        isResolved: false,
      });
      expect(comments[0].id).toBeDefined();
      expect(comments[0].createdAt).toBeInstanceOf(Date);
    });
  });

  describe('deleteComment', () => {
    it('removes comment by id', () => {
      useCommentStore.setState({
        comments: [
          { id: 'c1', parentId: 'p1', content: 'First', author: 'A', createdAt: new Date(), isResolved: false },
          { id: 'c2', parentId: 'p1', content: 'Second', author: 'B', createdAt: new Date(), isResolved: false },
        ],
      });

      const { deleteComment } = useCommentStore.getState();
      deleteComment('c1');

      const { comments } = useCommentStore.getState();
      expect(comments).toHaveLength(1);
      expect(comments[0].id).toBe('c2');
    });
  });

  describe('resolveComment', () => {
    it('toggles resolved state', () => {
      useCommentStore.setState({
        comments: [
          { id: 'c1', parentId: 'p1', content: 'Issue', author: 'A', createdAt: new Date(), isResolved: false },
        ],
      });

      const { resolveComment } = useCommentStore.getState();
      resolveComment('c1');

      expect(useCommentStore.getState().comments[0].isResolved).toBe(true);
    });
  });

  describe('toggleCommentExpanded', () => {
    it('adds id when not expanded', () => {
      const { toggleCommentExpanded } = useCommentStore.getState();
      toggleCommentExpanded('c1');

      expect(useCommentStore.getState().expandedCommentIds).toContain('c1');
    });

    it('removes id when already expanded', () => {
      useCommentStore.setState({ expandedCommentIds: ['c1'] });

      const { toggleCommentExpanded } = useCommentStore.getState();
      toggleCommentExpanded('c1');

      expect(useCommentStore.getState().expandedCommentIds).not.toContain('c1');
    });
  });
});
```

### 3b. Implement the Store
```typescript
// commentStore.ts
import { create } from 'zustand';

interface Comment {
  id: string;
  parentId: string;
  content: string;
  author: string;
  createdAt: Date;
  isResolved: boolean;
}

interface CommentState {
  comments: Comment[];
  expandedCommentIds: string[];
  editingCommentId: string | null;
  isLoadingComments: boolean;
  isSavingComment: boolean;

  addComment: (parentId: string, content: string) => void;
  updateComment: (id: string, content: string) => void;
  deleteComment: (id: string) => void;
  resolveComment: (id: string) => void;
  toggleCommentExpanded: (id: string) => void;
  setEditingComment: (id: string | null) => void;
}

export const useCommentStore = create<CommentState>((set, get) => ({
  comments: [],
  expandedCommentIds: [],
  editingCommentId: null,
  isLoadingComments: false,
  isSavingComment: false,

  addComment: (parentId, content) => {
    const newComment: Comment = {
      id: Date.now().toString(),
      parentId,
      content,
      author: 'Current User', // Would come from auth
      createdAt: new Date(),
      isResolved: false,
    };
    set((s) => ({ comments: [...s.comments, newComment] }));
  },

  updateComment: (id, content) =>
    set((s) => ({
      comments: s.comments.map((c) =>
        c.id === id ? { ...c, content } : c
      ),
    })),

  deleteComment: (id) =>
    set((s) => ({
      comments: s.comments.filter((c) => c.id !== id),
      expandedCommentIds: s.expandedCommentIds.filter((cid) => cid !== id),
    })),

  resolveComment: (id) =>
    set((s) => ({
      comments: s.comments.map((c) =>
        c.id === id ? { ...c, isResolved: !c.isResolved } : c
      ),
    })),

  toggleCommentExpanded: (id) =>
    set((s) => ({
      expandedCommentIds: s.expandedCommentIds.includes(id)
        ? s.expandedCommentIds.filter((cid) => cid !== id)
        : [...s.expandedCommentIds, id],
    })),

  setEditingComment: (id) => set({ editingCommentId: id }),
}));

// Selectors
export const useCommentsByParent = (parentId: string) =>
  useCommentStore((s) => s.comments.filter((c) => c.parentId === parentId));
```

### 3c. Run Tests
```bash
npm test -- commentStore
```

## Step 4: Build UI Components

Now that state logic is tested, build UI:

```typescript
// components/CommentList.tsx
import { useCommentStore, useCommentsByParent } from '@/store/commentStore';

interface CommentListProps {
  parentId: string;
}

export const CommentList = ({ parentId }: CommentListProps) => {
  const comments = useCommentsByParent(parentId);
  const expandedIds = useCommentStore((s) => s.expandedCommentIds);
  const toggleExpanded = useCommentStore((s) => s.toggleCommentExpanded);
  const deleteComment = useCommentStore((s) => s.deleteComment);
  const resolveComment = useCommentStore((s) => s.resolveComment);

  if (comments.length === 0) {
    return <p className="text-gray-500">No comments yet</p>;
  }

  return (
    <div className="comment-list">
      {comments.map((comment) => (
        <CommentItem
          key={comment.id}
          comment={comment}
          isExpanded={expandedIds.includes(comment.id)}
          onToggle={() => toggleExpanded(comment.id)}
          onDelete={() => deleteComment(comment.id)}
          onResolve={() => resolveComment(comment.id)}
        />
      ))}
    </div>
  );
};
```

```typescript
// components/AddCommentForm.tsx
import { useState } from 'react';
import { useCommentStore } from '@/store/commentStore';

interface AddCommentFormProps {
  parentId: string;
}

export const AddCommentForm = ({ parentId }: AddCommentFormProps) => {
  const [content, setContent] = useState('');
  const addComment = useCommentStore((s) => s.addComment);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!content.trim()) return;

    addComment(parentId, content);
    setContent('');
  };

  return (
    <form onSubmit={handleSubmit} className="add-comment-form">
      <textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        placeholder="Add a comment..."
      />
      <button type="submit" disabled={!content.trim()}>
        Add Comment
      </button>
    </form>
  );
};
```

## Benefits of This Approach

1. **Testable Logic** - State mutations tested independently of UI
2. **Clear Data Flow** - Components are thin, just connecting to store
3. **Reusable State** - Multiple components can share the same store
4. **Easier Debugging** - State changes are predictable and traceable
5. **Better Type Safety** - TypeScript interfaces defined upfront

## Checklist

### Before Writing Code
- [ ] State shape documented (what data exists)
- [ ] Actions documented (what mutations are needed)
- [ ] Selectors identified (what derived data is needed)

### Store Implementation
- [ ] Store file created with types
- [ ] All actions implemented
- [ ] Selectors exported for common queries
- [ ] Tests written and passing

### UI Implementation
- [ ] Components use granular selectors (not entire store)
- [ ] Loading/error states handled
- [ ] Forms clear after submission
- [ ] Optimistic updates considered (if needed)
