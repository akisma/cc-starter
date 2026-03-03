# Skill: DOM Utility Testing

## Purpose
Write comprehensive tests for utility functions that depend on DOM APIs (document, window, etc.).

## When to Use
- Testing utilities that use `document.createElement`
- Testing HTML parsing/manipulation functions
- Testing browser API wrappers
- Testing functions that measure DOM elements

## Prerequisites

### Vitest Configuration
Ensure `vitest.config.ts` has jsdom environment:
```typescript
export default defineConfig({
  test: {
    environment: 'jsdom',  // Required for DOM APIs
    setupFiles: './src/test/setup.ts',
  },
});
```

### Setup File (if needed)
For global mocks or polyfills, use `src/test/setup.ts`:
```typescript
// Example: Mock window.matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: vi.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
  })),
});
```

## Testing Patterns

### 1. HTML Text Extraction
For functions that extract text from HTML:
```typescript
import { describe, it, expect } from 'vitest';
import { getTextFromHtml } from './htmlUtils';

describe('getTextFromHtml', () => {
  it('returns empty string for empty input', () => {
    expect(getTextFromHtml('')).toBe('');
  });

  it('returns plain text unchanged', () => {
    expect(getTextFromHtml('Hello World')).toBe('Hello World');
  });

  it('strips HTML tags', () => {
    expect(getTextFromHtml('<p>Hello</p>')).toBe('Hello');
    expect(getTextFromHtml('<b>Bold</b>')).toBe('Bold');
  });

  it('handles nested tags', () => {
    expect(getTextFromHtml('<p><b>Hello</b> <i>World</i></p>')).toBe('Hello World');
  });

  it('handles multiple elements', () => {
    expect(getTextFromHtml('<p>First</p><p>Second</p>')).toBe('FirstSecond');
  });

  it('preserves whitespace in content', () => {
    expect(getTextFromHtml('<p>  spaces  </p>')).toBe('  spaces  ');
  });

  it('handles empty tags', () => {
    expect(getTextFromHtml('<p></p>')).toBe('');
    expect(getTextFromHtml('<div><span></span></div>')).toBe('');
  });

  it('handles self-closing tags', () => {
    expect(getTextFromHtml('Line 1<br/>Line 2')).toBe('Line 1Line 2');
  });
});
```

### 2. HTML Transformation
For functions that modify HTML:
```typescript
describe('sanitizeHtml', () => {
  it('allows safe tags', () => {
    const input = '<p>Hello <b>bold</b></p>';
    expect(sanitizeHtml(input)).toBe(input);
  });

  it('strips dangerous tags', () => {
    const input = '<p>Safe</p><script>alert("xss")</script>';
    expect(sanitizeHtml(input)).toBe('<p>Safe</p>');
  });

  it('strips event handlers', () => {
    const input = '<p onclick="alert(1)">Click</p>';
    expect(sanitizeHtml(input)).toBe('<p>Click</p>');
  });

  it('handles malformed HTML gracefully', () => {
    const input = '<p>Unclosed';
    // Browser will auto-close, verify no crash
    expect(() => sanitizeHtml(input)).not.toThrow();
  });
});
```

### 3. HTML Splitting/Pagination
For functions that split HTML by content length:
```typescript
describe('splitHtmlByLimit', () => {
  describe('content within limit', () => {
    it('returns all content when under limit', () => {
      const html = '<p>Short</p>';
      const result = splitHtmlByLimit(html, 100);

      expect(result.current).toBe(html);
      expect(result.remainder).toBe('');
    });

    it('returns all content at exactly the limit', () => {
      const html = '<p>Hello</p>'; // 5 chars of text
      const result = splitHtmlByLimit(html, 5);

      expect(result.current).toBe(html);
      expect(result.remainder).toBe('');
    });
  });

  describe('content exceeds limit', () => {
    it('splits content when exceeding limit', () => {
      const html = '<p>This is a long sentence.</p>';
      const result = splitHtmlByLimit(html, 10);

      expect(result.remainder.length).toBeGreaterThan(0);
      expect(getTextLength(result.current)).toBeLessThanOrEqual(10);
    });

    it('preserves HTML structure in both parts', () => {
      const html = '<p>First part. Second part.</p>';
      const result = splitHtmlByLimit(html, 15);

      // Both parts should have valid HTML
      expect(result.current).toMatch(/<p>.*<\/p>/);
      expect(result.remainder).toMatch(/<p>.*<\/p>/);
    });
  });

  describe('edge cases', () => {
    it('handles empty HTML', () => {
      const result = splitHtmlByLimit('', 100);
      expect(result.current).toBe('');
      expect(result.remainder).toBe('');
    });

    it('handles HTML with only tags (no text)', () => {
      const result = splitHtmlByLimit('<p></p>', 100);
      expect(result.current).toBe('<p></p>');
    });

    it('handles very small limit', () => {
      const result = splitHtmlByLimit('<p>Hello</p>', 1);
      // Should not crash, should produce valid split
      expect(result.current).toBeDefined();
    });
  });
});
```

### 4. Element Measurement
For functions that measure DOM elements:
```typescript
describe('measureElement', () => {
  it('returns dimensions of element', () => {
    // Create test element
    const div = document.createElement('div');
    div.style.width = '100px';
    div.style.height = '50px';
    document.body.appendChild(div);

    const result = measureElement(div);

    expect(result.width).toBe(100);
    expect(result.height).toBe(50);

    // Cleanup
    document.body.removeChild(div);
  });

  it('handles detached elements', () => {
    const div = document.createElement('div');
    // Not appended to document

    const result = measureElement(div);

    expect(result.width).toBe(0);
    expect(result.height).toBe(0);
  });
});
```

### 5. Event-Based Utilities
For utilities involving DOM events:
```typescript
describe('onClickOutside', () => {
  it('calls handler when clicking outside element', () => {
    const handler = vi.fn();
    const element = document.createElement('div');
    document.body.appendChild(element);

    const cleanup = onClickOutside(element, handler);

    // Simulate click outside
    document.body.click();

    expect(handler).toHaveBeenCalled();

    cleanup();
    document.body.removeChild(element);
  });

  it('does not call handler when clicking inside element', () => {
    const handler = vi.fn();
    const element = document.createElement('div');
    document.body.appendChild(element);

    const cleanup = onClickOutside(element, handler);

    // Simulate click inside
    element.click();

    expect(handler).not.toHaveBeenCalled();

    cleanup();
    document.body.removeChild(element);
  });
});
```

## Test Categories Checklist

### Input Handling
- [ ] Empty string/null/undefined
- [ ] Plain text (no HTML)
- [ ] Valid HTML
- [ ] Malformed HTML
- [ ] HTML with only tags (no text content)

### Edge Cases
- [ ] Very long input
- [ ] Very short input
- [ ] Unicode characters
- [ ] Special HTML entities (`&amp;`, `&lt;`, etc.)
- [ ] Nested structures (deeply nested tags)

### Output Validation
- [ ] Return type is correct
- [ ] HTML structure is preserved where expected
- [ ] No memory leaks (cleanup created elements)

## Common Gotchas

### jsdom Limitations
Some APIs behave differently in jsdom vs real browsers:
- `getBoundingClientRect()` returns zeros for non-rendered elements
- CSS calculations may not work
- Some newer APIs may not be implemented

### Element Cleanup
Always remove elements you add to the document:
```typescript
let element: HTMLElement;

beforeEach(() => {
  element = document.createElement('div');
  document.body.appendChild(element);
});

afterEach(() => {
  document.body.removeChild(element);
});
```

### Async DOM Operations
For utilities with async behavior:
```typescript
it('handles async operation', async () => {
  const result = await asyncDomUtil(element);
  expect(result).toBeDefined();
});
```
