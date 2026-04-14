# Signature Pad Component (ax-signature-pad)

**Category:** Integrations
**Selector:** `ax-signature-pad`
**Standalone:** Yes
**Since:** v1.0.0
**External Library:** [signature_pad](https://github.com/szimek/signature_pad)

---

## Table of Contents

1. [Overview](#overview)
2. [Security Considerations](#security-considerations)
3. [API Reference](#api-reference)
4. [Usage Examples](#usage-examples)
5. [Styling](#styling)
6. [Accessibility](#accessibility)
7. [Integration Patterns](#integration-patterns)

---

## Overview

The Signature Pad component provides smooth signature capture functionality with support for both drawing and uploading signatures. It integrates seamlessly with Angular Forms and includes undo/redo functionality.

**Features:**

- Smooth signature drawing using signature_pad library
- Upload signature image (PNG, JPG)
- Dual mode: Draw or Upload
- Undo/Redo functionality
- Export as PNG, JPEG, or SVG
- Angular Forms integration (ControlValueAccessor)
- Drag and drop file upload
- Configurable canvas size and colors
- Mobile-friendly (touch support)

**Use Cases:**

- Document signing
- Contract approval
- Consent forms
- Delivery confirmations
- Prescription approvals
- Attendance systems

---

## Security Considerations

### Critical Security Guidelines

> **WARNING: Signature Data Must Be Handled Securely**

1. **Signature Storage:**
   - Store signatures on secure backend server
   - Use HTTPS for transmission
   - Consider encryption at rest for sensitive documents
   - Log signature capture events (timestamp, IP, user agent)

```typescript
// ✅ CORRECT - Secure signature handling
onSignatureSave(dataUrl: string) {
  const signatureData = {
    signature: dataUrl,
    timestamp: new Date().toISOString(),
    documentId: this.documentId,
    ipAddress: this.getClientIP(), // Backend sets this
    userAgent: navigator.userAgent
  };

  this.documentService.saveSignature(signatureData).subscribe({
    next: (response) => {
      // Store only reference, not the image itself in frontend state
      this.signatureId = response.signatureId;
    }
  });
}

// ❌ WRONG - Storing in localStorage
localStorage.setItem('signature', dataUrl); // NOT SECURE
```

2. **File Upload Validation:**
   - Validate file type and size
   - Scan uploaded files for malware
   - Use backend validation (don't trust client-side)
   - Restrict file size (prevent DoS)

```typescript
// ✅ CORRECT - Backend validation example
// Frontend sets restrictions
<ax-signature-pad
  [maxUploadSize]="2 * 1024 * 1024"
  acceptUpload="image/png,image/jpeg"
/>

// Backend validates again
async validateSignatureUpload(file: File): Promise<boolean> {
  // Check file type
  const allowedTypes = ['image/png', 'image/jpeg'];
  if (!allowedTypes.includes(file.mimetype)) {
    throw new Error('Invalid file type');
  }

  // Check file size (2MB max)
  if (file.size > 2 * 1024 * 1024) {
    throw new Error('File too large');
  }

  // Scan for malware (using antivirus service)
  const isClean = await antivirusService.scan(file);
  if (!isClean) {
    throw new Error('File contains malware');
  }

  return true;
}
```

3. **Audit Trail:**
   - Log when signature is created
   - Log when signature is viewed
   - Track modifications
   - Maintain immutability after signing

```typescript
interface SignatureAudit {
  signatureId: string;
  userId: string;
  documentId: string;
  action: 'created' | 'viewed' | 'verified';
  timestamp: string;
  ipAddress: string;
  userAgent: string;
  isValid: boolean;
}
```

4. **Legal Compliance:**
   - Ensure compliance with e-signature laws (e.g., ESIGN Act, eIDAS)
   - Provide clear consent language
   - Maintain signature integrity
   - Support signature verification

5. **Data Privacy:**
   - Handle signature data as PII (Personally Identifiable Information)
   - Follow GDPR/CCPA requirements
   - Provide right to deletion
   - Don't share signatures without consent

---

## API Reference

### Inputs

#### Feature Toggles

| Property       | Type      | Default | Description              |
| -------------- | --------- | ------- | ------------------------ |
| `enableDraw`   | `boolean` | `true`  | Enable signature drawing |
| `enableUpload` | `boolean` | `true`  | Enable signature upload  |
| `enableUndo`   | `boolean` | `true`  | Show undo button         |
| `enableRedo`   | `boolean` | `true`  | Show redo button         |
| `enableClear`  | `boolean` | `true`  | Show clear button        |
| `enableSave`   | `boolean` | `true`  | Show save button         |

#### Canvas Settings

| Property          | Type     | Default     | Description             |
| ----------------- | -------- | ----------- | ----------------------- |
| `width`           | `number` | `400`       | Canvas width in pixels  |
| `height`          | `number` | `200`       | Canvas height in pixels |
| `penColor`        | `string` | `'#000000'` | Pen/stroke color        |
| `penWidth`        | `number` | `2.5`       | Pen thickness           |
| `backgroundColor` | `string` | `'#ffffff'` | Canvas background color |

#### Upload Settings

| Property        | Type     | Default                  | Description                |
| --------------- | -------- | ------------------------ | -------------------------- |
| `acceptUpload`  | `string` | `'image/png,image/jpeg'` | Accepted file types        |
| `maxUploadSize` | `number` | `2097152` (2MB)          | Maximum file size in bytes |

#### State

| Property   | Type      | Default | Description              |
| ---------- | --------- | ------- | ------------------------ |
| `disabled` | `boolean` | `false` | Disable all interactions |

### Outputs

| Event             | Payload         | Description                                            |
| ----------------- | --------------- | ------------------------------------------------------ |
| `signatureChange` | `SignatureData` | Emitted when signature changes                         |
| `cleared`         | `void`          | Emitted when signature is cleared                      |
| `saved`           | `string`        | Emitted when save button is clicked (returns data URL) |

### Type Definitions

```typescript
type SignatureOutputFormat = 'png' | 'jpeg' | 'svg';
type SignatureMode = 'draw' | 'upload';

interface SignatureData {
  dataUrl: string; // Base64 encoded image
  mode: SignatureMode; // How signature was created
  isEmpty: boolean; // Whether signature exists
}
```

### Public Methods

```typescript
// Export signature as data URL
toDataURL(format?: SignatureOutputFormat): string | null

// Load signature from data URL
fromDataURL(dataUrl: string): void

// Clear signature
clear(): void

// Undo last stroke
undo(): void

// Redo last undone stroke
redo(): void

// Save signature (triggers 'saved' event)
save(): void
```

---

## Usage Examples

### Basic Signature Capture

```typescript
import { Component } from '@angular/core';
import { AxSignaturePadComponent } from '@aegisx/ui';

@Component({
  selector: 'app-basic-signature',
  standalone: true,
  imports: [AxSignaturePadComponent],
  template: ` <ax-signature-pad (signatureChange)="onSignatureChange($event)" (saved)="onSave($event)" /> `,
})
export class BasicSignatureComponent {
  onSignatureChange(data: SignatureData) {
    console.log('Signature changed:', data.isEmpty ? 'Empty' : 'Has signature');
  }

  onSave(dataUrl: string) {
    console.log('Signature saved');
    // Upload to backend
    this.signatureService.upload(dataUrl).subscribe();
  }
}
```

### With Angular Forms

```typescript
import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { AxSignaturePadComponent } from '@aegisx/ui';

@Component({
  standalone: true,
  imports: [ReactiveFormsModule, AxSignaturePadComponent],
  template: `
    <form [formGroup]="documentForm" (ngSubmit)="submitDocument()">
      <mat-form-field>
        <input matInput formControlName="name" placeholder="Your Name" />
      </mat-form-field>

      <label>Signature *</label>
      <ax-signature-pad formControlName="signature" />

      @if (documentForm.get('signature')?.hasError('required') && documentForm.get('signature')?.touched) {
        <mat-error>Signature is required</mat-error>
      }

      <button mat-raised-button type="submit" [disabled]="!documentForm.valid">Submit</button>
    </form>
  `,
})
export class DocumentFormComponent {
  documentForm: FormGroup;

  constructor(private fb: FormBuilder) {
    this.documentForm = this.fb.group({
      name: ['', Validators.required],
      signature: [null, Validators.required],
    });
  }

  submitDocument() {
    if (this.documentForm.valid) {
      const formData = this.documentForm.value;
      // Upload document with signature
      this.documentService.submit(formData).subscribe();
    }
  }
}
```

### Draw Only Mode

```typescript
@Component({
  template: ` <ax-signature-pad [enableDraw]="true" [enableUpload]="false" [width]="600" [height]="300" penColor="#0000ff" [penWidth]="3" /> `,
})
export class DrawOnlySignatureComponent {}
```

### Upload Only Mode

```typescript
@Component({
  template: ` <ax-signature-pad [enableDraw]="false" [enableUpload]="true" [maxUploadSize]="1 * 1024 * 1024" acceptUpload="image/png" (signatureChange)="onUpload($event)" /> `,
})
export class UploadOnlySignatureComponent {
  onUpload(data: SignatureData) {
    if (data.mode === 'upload' && !data.isEmpty) {
      this.validateAndSave(data.dataUrl);
    }
  }

  validateAndSave(dataUrl: string) {
    // Validate and save to backend
  }
}
```

### Document Signing Flow

```typescript
import { Component, inject, signal } from '@angular/core';
import { AxSignaturePadComponent, SignatureData } from '@aegisx/ui';
import { DocumentService } from './services/document.service';

interface Document {
  id: string;
  title: string;
  content: string;
  requiresSignature: boolean;
}

@Component({
  selector: 'app-document-signing',
  standalone: true,
  imports: [AxSignaturePadComponent],
  template: `
    <div class="document-container">
      <div class="document-content">
        <h2>{{ document.title }}</h2>
        <div [innerHTML]="document.content"></div>
      </div>

      <div class="signature-section">
        <h3>Sign Document</h3>

        <div class="consent">
          <mat-checkbox [(ngModel)]="acceptTerms"> I have read and agree to the terms of this document </mat-checkbox>
        </div>

        <ax-signature-pad [disabled]="!acceptTerms" [enableSave]="true" (signatureChange)="onSignatureChange($event)" (saved)="onSignDocument($event)" />

        <p class="legal-text">By signing this document, you agree that your electronic signature is legally binding and has the same effect as a handwritten signature.</p>

        <div class="actions">
          <button mat-raised-button color="primary" [disabled]="!canSign()" (click)="submitSignedDocument()">Submit Signed Document</button>
        </div>
      </div>
    </div>
  `,
  styles: [
    `
      .document-container {
        max-width: 800px;
        margin: 0 auto;
      }

      .signature-section {
        margin-top: 2rem;
        padding: 2rem;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
      }

      .consent {
        margin: 1rem 0;
      }

      .legal-text {
        font-size: 0.875rem;
        color: #666;
        margin-top: 1rem;
        font-style: italic;
      }

      .actions {
        margin-top: 1.5rem;
        text-align: right;
      }
    `,
  ],
})
export class DocumentSigningComponent {
  private documentService = inject(DocumentService);

  document: Document = {
    id: 'DOC-2025-001',
    title: 'Service Agreement',
    content: '<p>Agreement terms...</p>',
    requiresSignature: true,
  };

  acceptTerms = false;
  signatureData = signal<SignatureData | null>(null);

  onSignatureChange(data: SignatureData) {
    this.signatureData.set(data);
  }

  onSignDocument(dataUrl: string) {
    // Auto-save signature when save button is clicked
    this.submitSignedDocument();
  }

  canSign(): boolean {
    const sig = this.signatureData();
    return this.acceptTerms && sig !== null && !sig.isEmpty;
  }

  submitSignedDocument() {
    if (!this.canSign()) return;

    const sig = this.signatureData()!;

    const signedDocument = {
      documentId: this.document.id,
      signature: sig.dataUrl,
      signatureMode: sig.mode,
      timestamp: new Date().toISOString(),
      userConsent: this.acceptTerms,
      ipAddress: '', // Backend will set this
      userAgent: navigator.userAgent,
    };

    this.documentService.signDocument(signedDocument).subscribe({
      next: (response) => {
        console.log('Document signed successfully');
        // Show confirmation and navigate
      },
      error: (error) => {
        console.error('Failed to sign document:', error);
      },
    });
  }
}
```

---

## Integration Patterns

### Prescription Approval System

```typescript
import { Component } from '@angular/core';
import { AxSignaturePadComponent } from '@aegisx/ui';

interface Prescription {
  id: string;
  patientName: string;
  medication: string;
  dosage: string;
  instructions: string;
}

@Component({
  selector: 'app-prescription-approval',
  template: `
    <div class="prescription-form">
      <h2>Prescription Approval</h2>

      <div class="prescription-details">
        <p><strong>Patient:</strong> {{ prescription.patientName }}</p>
        <p><strong>Medication:</strong> {{ prescription.medication }}</p>
        <p><strong>Dosage:</strong> {{ prescription.dosage }}</p>
        <p><strong>Instructions:</strong> {{ prescription.instructions }}</p>
      </div>

      <div class="doctor-signature">
        <label>Doctor's Signature</label>
        <ax-signature-pad [enableUpload]="false" [height]="150" [enableSave]="true" (saved)="approvePrescription($event)" />
      </div>

      <div class="approval-info">
        <p class="warning">By signing, you certify that this prescription is medically necessary and appropriate for the patient.</p>
      </div>
    </div>
  `,
})
export class PrescriptionApprovalComponent {
  prescription: Prescription = {
    id: 'RX-2025-001',
    patientName: 'John Doe',
    medication: 'Medication Name',
    dosage: '10mg',
    instructions: 'Take once daily',
  };

  approvePrescription(signature: string) {
    this.prescriptionService
      .approve({
        prescriptionId: this.prescription.id,
        doctorSignature: signature,
        approvedAt: new Date().toISOString(),
      })
      .subscribe();
  }
}
```

### Delivery Confirmation

```typescript
@Component({
  template: `
    <div class="delivery-confirmation">
      <h2>Delivery Confirmation</h2>

      <div class="package-info">
        <p>Tracking: {{ trackingNumber }}</p>
        <p>Recipient: {{ recipientName }}</p>
      </div>

      <div class="signature-capture">
        <label>Recipient Signature</label>
        <ax-signature-pad [width]="500" [height]="200" [enableUpload]="false" (signatureChange)="onSignatureChange($event)" />
      </div>

      <div class="photo-upload">
        <label>Photo of Package</label>
        <input type="file" accept="image/*" (change)="onPhotoCapture($event)" />
      </div>

      <button mat-raised-button color="primary" [disabled]="!canConfirm()" (click)="confirmDelivery()">Confirm Delivery</button>
    </div>
  `,
})
export class DeliveryConfirmationComponent {
  trackingNumber = 'TRK-2025-12345';
  recipientName = 'John Doe';
  signature: string | null = null;
  photo: string | null = null;

  onSignatureChange(data: SignatureData) {
    this.signature = data.isEmpty ? null : data.dataUrl;
  }

  canConfirm(): boolean {
    return this.signature !== null && this.photo !== null;
  }

  confirmDelivery() {
    this.deliveryService
      .confirm({
        trackingNumber: this.trackingNumber,
        signature: this.signature!,
        photo: this.photo!,
        location: this.getCurrentLocation(),
        timestamp: new Date().toISOString(),
      })
      .subscribe();
  }
}
```

---

## Styling

### Custom Canvas Styling

```scss
ax-signature-pad ::ng-deep {
  .signature-canvas {
    border: 2px solid #1976d2;
    border-radius: 8px;
  }

  .canvas-placeholder {
    color: #1976d2;
  }
}
```

### Responsive Design

```scss
@media (max-width: 768px) {
  ax-signature-pad {
    --signature-width: 100%;
    --signature-height: 150px;
  }
}
```

---

## Accessibility

- **WCAG 2.1 AA Compliant**
- **Keyboard Navigation:** Undo (Ctrl+Z), Redo (Ctrl+Y)
- **Touch Support:** Full mobile/tablet support
- **Screen Reader:** ARIA labels for all actions
- **Focus Management:** Clear focus indicators

### Keyboard Shortcuts

| Key           | Action                    |
| ------------- | ------------------------- |
| `Tab`         | Navigate between controls |
| `Space/Enter` | Activate buttons          |
| `Escape`      | Cancel current action     |

---

## Related Components

- **[QR Code](./qrcode.md)** - QR code generation integration
- **[File Upload](../forms/file-upload.md)** - File upload patterns

---

## Changelog

**v2.0.0** (2025-01-19)

- Added dual mode (draw/upload)
- Enhanced security documentation
- Improved mobile/touch support
- Added undo/redo functionality
