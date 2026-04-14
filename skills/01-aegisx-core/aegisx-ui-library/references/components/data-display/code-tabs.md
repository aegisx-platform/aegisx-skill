# Code Tabs Component

## Overview

The `ax-code-tabs` component displays code examples with syntax highlighting in a tabbed format. Built on Prism.js with the Catppuccin Mocha theme, it supports multiple programming languages (HTML, TypeScript, SCSS, CSS, Bash, JSON) and provides copy-to-clipboard functionality. The component automatically adapts to single or multiple code blocks.

### Key Features

- **Syntax Highlighting**: Prism.js with Catppuccin Mocha color theme
- **Multiple Languages**: HTML, TypeScript, SCSS, CSS, Bash, and JSON support
- **Tab Interface**: Automatic tab display for multiple code blocks
- **Copy Button**: One-click code copying with snackbar feedback
- **Single Block Mode**: Simplified UI for single code examples
- **Responsive**: Adapts to different screen sizes with horizontal scroll
- **Code Formatting**: Preserves indentation and formatting

## Installation & Import

```typescript
import { AxCodeTabsComponent } from '@aegisx/ui';
```

## Basic Usage

### Single Code Block

```typescript
// Component TypeScript
import { AxCodeTabsComponent } from '@aegisx/ui';

export class MyCodeComponent {
  htmlCode = `
    <div class="container">
      <h1>Hello World</h1>
      <p>Welcome to the component</p>
    </div>
  `;
}
```

```html
<!-- Component Template -->
<ax-code-tabs [html]="htmlCode"> </ax-code-tabs>
```

### Multiple Code Tabs

```typescript
export class CodeExampleComponent {
  codeTabs = [
    {
      label: 'TypeScript',
      language: 'typescript',
      code: `
        export class MyComponent {
          title = 'Code Tabs Demo';

          constructor() {
            console.log('Component initialized');
          }
        }
      `,
    },
    {
      label: 'HTML',
      language: 'html',
      code: `
        <div class="example">
          <h1>{{ title }}</h1>
        </div>
      `,
    },
    {
      label: 'SCSS',
      language: 'scss',
      code: `
        .example {
          padding: 2rem;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          border-radius: 8px;
        }
      `,
    },
  ];
}
```

```html
<ax-code-tabs [tabs]="codeTabs"> </ax-code-tabs>
```

## API Reference

### Inputs

| Name              | Type        | Default     | Description                                      |
| ----------------- | ----------- | ----------- | ------------------------------------------------ |
| `tabs`            | `CodeTab[]` | `[]`        | Array of code tabs to display                    |
| `showLineNumbers` | `boolean`   | `false`     | Show line numbers (reserved for future use)      |
| `html`            | `string`    | `undefined` | Single HTML code block (convenience input)       |
| `typescript`      | `string`    | `undefined` | Single TypeScript code block (convenience input) |
| `scss`            | `string`    | `undefined` | Single SCSS code block (convenience input)       |
| `css`             | `string`    | `undefined` | Single CSS code block (convenience input)        |

### Outputs

No outputs (component is display-only)

### Methods

| Name               | Signature                          | Description                                             |
| ------------------ | ---------------------------------- | ------------------------------------------------------- |
| `selectTab`        | `(index: number): void`            | Switch to a specific tab by index                       |
| `copyCode`         | `(code: string): void`             | Copy code to clipboard and show feedback                |
| `getPrismLanguage` | `(language: CodeLanguage): string` | Convert component language to Prism language identifier |

### Interfaces

**CodeTab**

```typescript
export interface CodeTab {
  label: string; // Tab label
  code: string; // Source code content
  language: CodeLanguage; // Programming language
}
```

**CodeLanguage**

```typescript
export type CodeLanguage = 'html' | 'typescript' | 'scss' | 'css' | 'bash' | 'json';
```

## Advanced Usage

### Dynamic Code Tabs

```typescript
export class DynamicCodeComponent {
  codeTabs: CodeTab[] = [];

  ngOnInit() {
    this.loadCodeExamples();
  }

  loadCodeExamples() {
    this.codeTabs = [
      {
        label: 'App Component',
        language: 'typescript',
        code: this.getAppComponentCode(),
      },
      {
        label: 'Template',
        language: 'html',
        code: this.getTemplateCode(),
      },
      {
        label: 'Styles',
        language: 'scss',
        code: this.getStylesCode(),
      },
    ];
  }

  private getAppComponentCode(): string {
    return `
      import { Component } from '@angular/core';

      @Component({
        selector: 'app-root',
        templateUrl: './app.component.html',
        styleUrls: ['./app.component.scss']
      })
      export class AppComponent {
        title = 'My Application';
      }
    `;
  }

  private getTemplateCode(): string {
    return `<h1>{{ title }}</h1>`;
  }

  private getStylesCode(): string {
    return `h1 { color: #333; font-size: 2rem; }`;
  }
}
```

### Copy with Custom Feedback

```typescript
export class CodeWithFeedbackComponent {
  @ViewChild(AxCodeTabsComponent) codeComponent!: AxCodeTabsComponent;

  codeTabs: CodeTab[] = [
    {
      label: 'Example',
      language: 'typescript',
      code: 'const greeting = "Hello, World!";',
    },
  ];

  customCopyCode() {
    // The component handles copy internally
    // You can add custom logic before/after
    this.codeComponent.copyCode(this.codeTabs[0].code);
  }
}
```

### Language-Specific Formatting

```typescript
export class FormattedCodeComponent {
  codeTabs: CodeTab[] = [
    // JSON with formatting
    {
      label: 'Config',
      language: 'json',
      code: JSON.stringify(
        {
          version: '1.0.0',
          name: 'my-app',
          scripts: {
            build: 'ng build',
            serve: 'ng serve',
          },
        },
        null,
        2,
      ),
    },
    // Bash with comments
    {
      label: 'Setup',
      language: 'bash',
      code: `
        # Install dependencies
        npm install

        # Start development server
        npm start

        # Build for production
        npm run build
      `,
    },
  ];
}
```

## Styling & Theming

The code tabs component uses a built-in Catppuccin Mocha color theme. The styling cannot be easily overridden but uses consistent colors for syntax highlighting.

### Theme Colors

```
Base Colors:
- Background: #1e1e2e (dark purple)
- Header: #181825 (darker)
- Text: #cdd6f4 (light)

Syntax Colors:
- Comments: #6c7086 (muted)
- Strings: #a6e3a1 (green)
- Numbers: #fab387 (orange)
- Keywords: #cba6f7 (purple)
- Functions: #89b4fa (blue)
```

### Custom Wrapper Styling

```scss
// Style the outer container
::ng-deep .code-tabs {
  border-radius: 12px;
  margin: 2rem 0;
}

// Custom button styling
::ng-deep .code-tabs__copy-btn {
  transition: all 0.2s ease;

  &:hover {
    transform: scale(1.05);
  }
}

// Responsive code
@media (max-width: 768px) {
  ::ng-deep .code-tabs__code {
    font-size: 12px;
    padding: 16px;
  }

  ::ng-deep .code-tabs__tab-btn {
    padding: 4px 12px;
    font-size: 12px;
  }
}
```

## Accessibility

The code tabs component includes accessibility features for developers:

### Keyboard Navigation

- **Tab**: Navigate between tabs and copy button
- **Enter/Space**: Switch to selected tab
- **Ctrl/Cmd + C**: Standard copy shortcut (browser default)

### ARIA Labels

```html
<button mat-icon-button class="code-tabs__copy-btn" aria-label="Copy code to clipboard">
  <mat-icon>content_copy</mat-icon>
</button>
```

### Screen Reader Support

- Tab labels are announced clearly
- Copy button intent is announced
- Code blocks are marked as `<pre><code>` for proper semantic meaning

### Color Independence

- Copy button has icon + tooltip (not color-only)
- Tab highlighting uses both color and text styling
- Code syntax uses multiple colors for distinction

### Focus Management

- Clear focus indicators on all interactive elements
- Focus visible on tab buttons and copy button
- Tab order follows logical flow

## Common Patterns

### Documentation with Code Examples

```typescript
export class ComponentDocComponent {
  calendarCodeTabs: CodeTab[] = [
    {
      label: 'TypeScript',
      language: 'typescript',
      code: `
        import { AxCalendarComponent } from '@aegisx/ui';

        export class MyCalendarComponent {
          events = [
            {
              id: '1',
              title: 'Meeting',
              start: new Date(),
              color: 'primary'
            }
          ];
        }
      `,
    },
    {
      label: 'Template',
      language: 'html',
      code: `
        <ax-calendar
          [events]="events"
          [initialView]="'dayGridMonth'"
          (eventClick)="onEventClick($event)">
        </ax-calendar>
      `,
    },
  ];
}
```

### API Response Examples

```typescript
export class ApiDocComponent {
  apiTabs: CodeTab[] = [
    {
      label: 'Request',
      language: 'bash',
      code: `curl -X GET \\
  https://api.example.com/users \\
  -H "Authorization: Bearer TOKEN" \\
  -H "Content-Type: application/json"`,
    },
    {
      label: 'Response',
      language: 'json',
      code: JSON.stringify(
        {
          success: true,
          data: [
            { id: 1, name: 'John', email: 'john@example.com' },
            { id: 2, name: 'Jane', email: 'jane@example.com' },
          ],
        },
        null,
        2,
      ),
    },
  ];
}
```

### Multi-Language Implementation

```typescript
export class ImplementationPatternComponent {
  implementationTabs: CodeTab[] = [
    {
      label: 'Angular',
      language: 'typescript',
      code: `
        // Angular implementation
        @Component({})
        export class MyComponent {
          ngOnInit() {
            this.loadData();
          }
        }
      `,
    },
    {
      label: 'Vue',
      language: 'javascript',
      code: `
        // Vue implementation (shown as typescript)
        export default {
          name: 'MyComponent',
          mounted() {
            this.loadData();
          }
        }
      `,
    },
    {
      label: 'Configuration',
      language: 'json',
      code: JSON.stringify(
        {
          components: ['angular', 'vue'],
          version: '1.0.0',
        },
        null,
        2,
      ),
    },
  ];
}
```

### Conditional Code Display

```typescript
export class ConditionalCodeComponent {
  environment = 'production';

  get codeTabs(): CodeTab[] {
    const baseTabs: CodeTab[] = [
      {
        label: 'TypeScript',
        language: 'typescript',
        code: 'export class AppComponent {}',
      },
    ];

    if (this.environment === 'development') {
      baseTabs.push({
        label: 'Debug',
        language: 'bash',
        code: 'ng serve --port 4201 --watch',
      });
    }

    return baseTabs;
  }
}
```

## Supported Languages

| Language   | Identifier   | Use Cases                         |
| ---------- | ------------ | --------------------------------- |
| HTML       | `html`       | Templates, markup examples        |
| TypeScript | `typescript` | Component code, services          |
| SCSS       | `scss`       | Styling with variables and mixins |
| CSS        | `css`        | Stylesheet examples               |
| Bash       | `bash`       | CLI commands, scripts             |
| JSON       | `json`       | Configuration, API responses      |

## Troubleshooting

### Code Not Syntax Highlighting

**Issue**: Code appears white text without color highlighting

**Solution**:

- Ensure `language` property matches one of supported languages
- Check browser console for Prism.js errors
- Verify imports: `import Prism from 'prismjs'`
- Check that language-specific Prism file is imported

### Copy Button Not Working

**Issue**: Copy button doesn't copy code to clipboard

**Solution**:

- Verify browser supports Clipboard API
- Check for browser console errors related to clipboard
- Ensure code string is properly trimmed (component does this automatically)
- Check MatSnackBar is imported

### Tabs Not Switching

**Issue**: Clicking tabs doesn't switch active tab

**Solution**:

- Ensure `tabs` array contains valid `CodeTab` objects
- Verify each tab has unique `label` for track identification
- Check that `activeTabIndex` state is properly managed
- Inspect browser DevTools for event handler errors

### Code Block Width Issues

**Issue**: Long lines overflow or don't scroll properly

**Solution**:

```scss
::ng-deep .code-tabs__code {
  overflow-x: auto;
  white-space: pre;
  word-wrap: normal;
}
```

### Single vs Multiple Block Confusion

**Issue**: Using convenience inputs (`[html]`, `[typescript]`) with `[tabs]`

**Solution**: Use either:

- Convenience inputs for single block: `[html]="code"` or `[typescript]="code"`
- Or `[tabs]` input for multiple blocks
- Don't mix both approaches

## Performance Considerations

- Component reuses Prism.js instance
- Syntax highlighting is cached when tabs don't change
- Code blocks only highlighted when tab is visible
- Use `track` functions in loops to prevent unnecessary re-renders

## Browser Support

- Chrome/Edge: Latest 2 versions (Clipboard API required)
- Firefox: Latest 2 versions (Clipboard API required)
- Safari: Latest 2 versions (Clipboard API required)
- Mobile: iOS Safari 13.4+, Chrome Android 60+
