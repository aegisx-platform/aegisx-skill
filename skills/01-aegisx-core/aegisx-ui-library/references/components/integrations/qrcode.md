# QR Code Component (ax-qrcode)

**Category:** Integrations
**Selector:** `ax-qrcode`
**Standalone:** Yes
**Since:** v1.0.0
**External Library:** [angularx-qrcode](https://github.com/cordobo/angularx-qrcode)

---

## Table of Contents

1. [Overview](#overview)
2. [Security Considerations](#security-considerations)
3. [API Reference](#api-reference)
4. [Preset Templates](#preset-templates)
5. [Usage Examples](#usage-examples)
6. [Styling](#styling)
7. [Accessibility](#accessibility)
8. [Integration Patterns](#integration-patterns)

---

## Overview

The QR Code component is a feature-rich wrapper around the angularx-qrcode library, providing easy-to-use preset templates for common use cases, download functionality, and theming support.

**Features:**

- Simple URL/text QR codes
- Preset templates (vCard, WiFi, Email, SMS, Phone)
- Download as PNG, SVG, or JPEG
- Copy to clipboard
- Size presets (small, medium, large, custom)
- Customizable colors and styling
- Center logo/image support
- Error correction levels
- Theming integration

**Use Cases:**

- Contact information sharing (vCard)
- WiFi network sharing
- Event tickets
- Payment links
- Product information
- Website URLs
- App store links

---

## Security Considerations

### Critical Security Guidelines

> **WARNING: Be Careful with Sensitive Data in QR Codes**

1. **Data Exposure:**
   - QR codes are easily scannable and shareable
   - Don't encode passwords, API keys, or secrets
   - Use placeholder credentials in documentation

```typescript
// ❌ WRONG - Real credentials
<ax-qrcode
  [wifi]="{ ssid: 'MyNetwork', password: 'MyR3alP@ssw0rd', security: 'WPA' }"
/>

// ✅ CORRECT - Placeholder for demo
<ax-qrcode
  [wifi]="{ ssid: 'NETWORK_NAME', password: 'YOUR_WIFI_PASSWORD', security: 'WPA' }"
/>

// ✅ BEST - Use service to get WiFi credentials securely
<ax-qrcode [wifi]="wifiCredentials$ | async" />
```

2. **URL Validation:**
   - Validate URLs before generating QR codes
   - Prevent injection of malicious links
   - Use HTTPS for sensitive operations

```typescript
// ✅ CORRECT - Validate URL
validateAndGenerateQR(url: string): void {
  try {
    const parsedUrl = new URL(url);

    // Only allow HTTPS
    if (parsedUrl.protocol !== 'https:') {
      throw new Error('Only HTTPS URLs allowed');
    }

    // Validate domain whitelist (if needed)
    const allowedDomains = ['yourapp.com', 'yourdomain.com'];
    if (!allowedDomains.includes(parsedUrl.hostname)) {
      throw new Error('Domain not allowed');
    }

    this.qrData = url;
  } catch (error) {
    this.showError('Invalid URL');
  }
}
```

3. **vCard Data Privacy:**
   - Don't include sensitive personal information
   - Provide user control over what data to include
   - Consider data minimization

```typescript
// ✅ CORRECT - Allow user to select what to share
@Component({
  template: `
    <mat-checkbox [(ngModel)]="includePhone">Include Phone</mat-checkbox>
    <mat-checkbox [(ngModel)]="includeEmail">Include Email</mat-checkbox>

    <ax-qrcode [vCard]="generateVCard()" />
  `,
})
export class ContactShareComponent {
  includePhone = false;
  includeEmail = false;

  generateVCard(): VCardData {
    return {
      firstName: 'John',
      lastName: 'Doe',
      phone: this.includePhone ? '+1234567890' : undefined,
      email: this.includeEmail ? 'john@example.com' : undefined,
    };
  }
}
```

4. **WiFi Credentials:**
   - Only generate WiFi QR codes for guest networks
   - Use temporary passwords for events
   - Rotate passwords after sharing

---

## API Reference

### Inputs

#### Core Data

| Property | Type     | Default | Description                        |
| -------- | -------- | ------- | ---------------------------------- |
| `data`   | `string` | `''`    | Raw QR code data (text, URL, etc.) |

#### Preset Templates

| Property | Type                | Default | Description                |
| -------- | ------------------- | ------- | -------------------------- |
| `vCard`  | `VCardData \| null` | `null`  | Contact information preset |
| `wifi`   | `WiFiData \| null`  | `null`  | WiFi network preset        |
| `email`  | `EmailData \| null` | `null`  | Email mailto preset        |
| `sms`    | `SMSData \| null`   | `null`  | SMS message preset         |
| `phone`  | `string \| null`    | `null`  | Phone number preset        |
| `url`    | `string \| null`    | `null`  | URL preset                 |

#### Size Settings

| Property     | Type               | Default    | Description                             |
| ------------ | ------------------ | ---------- | --------------------------------------- |
| `size`       | `number`           | `200`      | Custom size in pixels                   |
| `sizePreset` | `QRCodeSizePreset` | `'medium'` | Size preset (small/medium/large/custom) |

#### QR Code Settings

| Property               | Type                         | Default    | Description            |
| ---------------------- | ---------------------------- | ---------- | ---------------------- |
| `errorCorrectionLevel` | `'L' \| 'M' \| 'Q' \| 'H'`   | `'M'`      | Error correction level |
| `elementType`          | `'canvas' \| 'svg' \| 'img'` | `'canvas'` | Rendering type         |
| `margin`               | `number`                     | `4`        | Margin around QR code  |

#### Styling

| Property      | Type                  | Default     | Description           |
| ------------- | --------------------- | ----------- | --------------------- |
| `colorDark`   | `string`              | `'#000000'` | QR code dark color    |
| `colorLight`  | `string`              | `'#ffffff'` | QR code light color   |
| `imageSrc`    | `string \| undefined` | -           | Center logo image URL |
| `imageHeight` | `number \| undefined` | -           | Logo height           |
| `imageWidth`  | `number \| undefined` | -           | Logo width            |

#### Features

| Property           | Type      | Default    | Description          |
| ------------------ | --------- | ---------- | -------------------- |
| `showDownload`     | `boolean` | `false`    | Show download button |
| `showCopy`         | `boolean` | `false`    | Show copy button     |
| `downloadFileName` | `string`  | `'qrcode'` | Download file name   |

### Outputs

| Event        | Payload                | Description                                 |
| ------------ | ---------------------- | ------------------------------------------- |
| `downloaded` | `QRCodeDownloadFormat` | Emitted when QR code is downloaded          |
| `copied`     | `string`               | Emitted when QR data is copied to clipboard |

### Type Definitions

```typescript
type QRCodeSizePreset = 'small' | 'medium' | 'large' | 'custom';
type QRCodeErrorCorrectionLevel = 'L' | 'M' | 'Q' | 'H';
type QRCodeElementType = 'canvas' | 'svg' | 'img';
type QRCodeDownloadFormat = 'png' | 'svg' | 'jpeg';

interface VCardData {
  firstName: string;
  lastName: string;
  organization?: string;
  title?: string;
  email?: string;
  phone?: string;
  mobile?: string;
  address?: {
    street?: string;
    city?: string;
    state?: string;
    postalCode?: string;
    country?: string;
  };
  website?: string;
  note?: string;
}

interface WiFiData {
  ssid: string;
  password?: string;
  security: 'WPA' | 'WEP' | 'nopass';
  hidden?: boolean;
}

interface EmailData {
  to: string;
  subject?: string;
  body?: string;
}

interface SMSData {
  phone: string;
  message?: string;
}

// Size Presets
const SIZE_PRESETS = {
  small: 128,
  medium: 200,
  large: 300,
  custom: 200, // Uses 'size' input value
};
```

### Error Correction Levels

| Level | Recovery Capacity | Use Case                  |
| ----- | ----------------- | ------------------------- |
| `L`   | ~7%               | Clean environments        |
| `M`   | ~15%              | Standard use (default)    |
| `Q`   | ~25%              | Outdoor, potential damage |
| `H`   | ~30%              | High-damage environments  |

---

## Preset Templates

### vCard (Contact Information)

```typescript
<ax-qrcode
  [vCard]="{
    firstName: 'John',
    lastName: 'Doe',
    organization: 'AegisX Inc.',
    title: 'Software Engineer',
    email: 'john.doe@example.com',
    phone: '+1-555-0123',
    mobile: '+1-555-0124',
    website: 'https://example.com'
  }"
  [showDownload]="true"
  downloadFileName="contact-john-doe"
/>
```

### WiFi Network

```typescript
<ax-qrcode
  [wifi]="{
    ssid: 'PLACEHOLDER_NETWORK_NAME',
    password: 'YOUR_PASSWORD_HERE',
    security: 'WPA'
  }"
  [showDownload]="true"
/>
```

### Email

```typescript
<ax-qrcode
  [email]="{
    to: 'support@example.com',
    subject: 'Product Inquiry',
    body: 'I would like more information about...'
  }"
/>
```

### SMS

```typescript
<ax-qrcode
  [sms]="{
    phone: '+1-555-0199',
    message: 'Hello from QR code!'
  }"
/>
```

### Phone Number

```typescript
<ax-qrcode
  [phone]="'+1-555-0100'"
/>
```

### URL

```typescript
<ax-qrcode
  [url]="'https://aegisx.io'"
  [showDownload]="true"
/>
```

---

## Usage Examples

### Basic QR Code

```typescript
import { Component } from '@angular/core';
import { AxQrCodeComponent } from '@aegisx/ui';

@Component({
  selector: 'app-basic-qr',
  standalone: true,
  imports: [AxQrCodeComponent],
  template: ` <ax-qrcode [data]="'https://aegisx.io'" /> `,
})
export class BasicQRComponent {}
```

### Custom Styling and Size

```typescript
@Component({
  template: ` <ax-qrcode [data]="'Hello World'" colorDark="#1976d2" colorLight="#e3f2fd" sizePreset="large" errorCorrectionLevel="H" /> `,
})
export class StyledQRComponent {}
```

### With Logo/Brand

```typescript
@Component({
  template: ` <ax-qrcode [url]="'https://yourapp.com'" colorDark="#000000" [imageSrc]="'/assets/logo.png'" [imageHeight]="40" [imageWidth]="40" errorCorrectionLevel="H" /> `,
})
export class BrandedQRComponent {}
```

### Download and Copy Features

```typescript
@Component({
  template: ` <ax-qrcode [data]="qrData" [showDownload]="true" [showCopy]="true" downloadFileName="my-qrcode" (downloaded)="onDownloaded($event)" (copied)="onCopied($event)" /> `,
})
export class InteractiveQRComponent {
  qrData = 'https://example.com';

  onDownloaded(format: string) {
    console.log(`Downloaded as ${format}`);
  }

  onCopied(data: string) {
    console.log('Copied to clipboard:', data);
  }
}
```

### Dynamic vCard from User Profile

```typescript
import { Component, inject } from '@angular/core';
import { AxQrCodeComponent, VCardData } from '@aegisx/ui';

@Component({
  template: `
    <div class="qr-container">
      <h2>Share Your Contact</h2>

      <div class="privacy-controls">
        <mat-checkbox [(ngModel)]="includePhone"> Include Phone Number </mat-checkbox>
        <mat-checkbox [(ngModel)]="includeEmail"> Include Email </mat-checkbox>
        <mat-checkbox [(ngModel)]="includeAddress"> Include Address </mat-checkbox>
      </div>

      <ax-qrcode [vCard]="buildVCard()" [showDownload]="true" [showCopy]="true" sizePreset="large" downloadFileName="my-contact" />
    </div>
  `,
})
export class ProfileQRComponent {
  private userService = inject(UserService);

  includePhone = true;
  includeEmail = true;
  includeAddress = false;

  buildVCard(): VCardData {
    const user = this.userService.getCurrentUser();

    return {
      firstName: user.firstName,
      lastName: user.lastName,
      organization: user.company,
      title: user.jobTitle,
      email: this.includeEmail ? user.email : undefined,
      phone: this.includePhone ? user.phone : undefined,
      address: this.includeAddress
        ? {
            street: user.address?.street,
            city: user.address?.city,
            state: user.address?.state,
            postalCode: user.address?.zip,
            country: user.address?.country,
          }
        : undefined,
      website: user.website,
    };
  }
}
```

---

## Integration Patterns

### Event Ticket System

```typescript
import { Component } from '@angular/core';
import { AxQrCodeComponent } from '@aegisx/ui';

interface Ticket {
  id: string;
  eventName: string;
  attendee: string;
  seat: string;
  validationUrl: string;
}

@Component({
  selector: 'app-event-ticket',
  standalone: true,
  imports: [AxQrCodeComponent],
  template: `
    <div class="ticket">
      <h2>{{ ticket.eventName }}</h2>
      <p>Attendee: {{ ticket.attendee }}</p>
      <p>Seat: {{ ticket.seat }}</p>

      <!-- QR code for validation -->
      <ax-qrcode [data]="ticket.validationUrl" sizePreset="large" errorCorrectionLevel="Q" />

      <p class="ticket-id">Ticket ID: {{ ticket.id }}</p>
    </div>
  `,
})
export class EventTicketComponent {
  ticket: Ticket = {
    id: 'TKT-2025-001',
    eventName: 'Tech Conference 2025',
    attendee: 'John Doe',
    seat: 'A-15',
    validationUrl: 'https://events.example.com/validate/TKT-2025-001',
  };
}
```

### WiFi Guest Network Sharing

```typescript
import { Component, signal } from '@angular/core';
import { AxQrCodeComponent } from '@aegisx/ui';

@Component({
  template: `
    <div class="wifi-share">
      <h2>Guest WiFi</h2>

      <button mat-raised-button (click)="generateGuestPassword()">Generate New Password</button>

      @if (guestWiFi()) {
        <ax-qrcode [wifi]="guestWiFi()" [showDownload]="true" sizePreset="large" downloadFileName="guest-wifi" />

        <div class="wifi-info">
          <p><strong>Network:</strong> {{ guestWiFi()!.ssid }}</p>
          <p><strong>Password:</strong> {{ guestWiFi()!.password }}</p>
          <p class="note">This password expires in 24 hours</p>
        </div>
      }
    </div>
  `,
})
export class GuestWiFiComponent {
  guestWiFi = signal<WiFiData | null>(null);

  generateGuestPassword() {
    // PLACEHOLDER: Generate secure temporary password
    const password = this.generateSecurePassword();

    this.guestWiFi.set({
      ssid: 'Guest-Network',
      password: password,
      security: 'WPA',
    });

    // Backend: Store with expiration
    this.wifiService.createGuestAccess(password, 24).subscribe();
  }

  private generateSecurePassword(): string {
    // PLACEHOLDER: Use secure random generator
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    let password = '';
    for (let i = 0; i < 12; i++) {
      password += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return password;
  }
}
```

### Payment QR Code

```typescript
import { Component, computed, signal } from '@angular/core';
import { AxQrCodeComponent } from '@aegisx/ui';

@Component({
  template: `
    <div class="payment-qr">
      <h2>Payment Request</h2>

      <div class="amount">
        <mat-form-field>
          <input matInput type="number" [(ngModel)]="amount" placeholder="Amount" />
        </mat-form-field>
      </div>

      <ax-qrcode [data]="paymentUrl()" [showDownload]="true" sizePreset="large" errorCorrectionLevel="M" />
    </div>
  `,
})
export class PaymentQRComponent {
  amount = signal(100);

  // PLACEHOLDER: Replace with your payment provider URL format
  paymentUrl = computed(() => {
    const paymentId = this.generatePaymentId();
    return `https://payment.example.com/pay/${paymentId}?amount=${this.amount()}`;
  });

  private generatePaymentId(): string {
    // PLACEHOLDER: Generate unique payment ID
    return `PAY-${Date.now()}`;
  }
}
```

---

## Accessibility

- **Alt Text:** Images rendered with appropriate alt attributes
- **Copy Button:** Accessible with keyboard and screen readers
- **Download Button:** ARIA labels for assistive technologies

---

## Related Components

- **[Signature Pad](./signature-pad.md)** - Signature capture integration
- **[File Upload](../forms/file-upload.md)** - File integration patterns

---

## Changelog

**v2.0.0** (2025-01-19)

- Added preset templates (vCard, WiFi, Email, SMS, Phone)
- Enhanced security documentation
- Added download and copy features
- Improved theming support
