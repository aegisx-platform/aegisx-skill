---
name: aegisx-icons
description: AegisX custom SVG icon library — 59 domain icons (drug inventory, HIS, admin) with mono + colored variants. Use when adding icons to inventory/budget/procurement pages.
---

# AegisX Icons

Custom SVG icon set for the AegisX platform — 59 icons covering drug inventory, HIS modules, and admin functions.

## When Claude Should Use This Skill

- User asks to add/change icons on inventory, budget, procurement, or HIS pages
- User mentions "custom icon", "drug icon", "aegisx icon", or "svg icon"
- Building new navigation items, launcher cards, or feature headers that need domain-specific icons
- Replacing generic Material icons with domain-appropriate ones

## Icon Location

```
apps/web/src/assets/icons/aegisx/
├── svg/              ← Mono (stroke=currentColor, inherits text color)
│   ├── drug-master.svg
│   ├── dispensing.svg
│   └── ... (59 files)
├── svg-colored/      ← Colored (fixed fills, for cards/launcher)
│   ├── drug-master.svg
│   └── ... (59 files)
└── aegisx-icon-registry.ts   ← Angular MatIconRegistry helper
```

## Available Icons (59)

### Drug Inventory & Warehouse (24)
| Icon name | Thai | Use case |
|-----------|------|----------|
| `drug-master` | ข้อมูลยา | Drug Master Data |
| `tmt-catalog` | บัญชียา TMT | TMT drug catalog |
| `supplier` | บริษัทผู้จำหน่าย | Supplier management |
| `lot-tracking` | ติดตาม Lot | Lot selection |
| `purchase-requisition` | ใบขอซื้อ | PR list/form |
| `purchase-order` | ใบสั่งซื้อ | PO list/form |
| `budget-ledger` | งบประมาณ | Budget journal |
| `goods-receive` | รับเข้าคลัง | GR workflow |
| `bin-location` | ตำแหน่งจัดเก็บ | Warehouse/Bin config |
| `stock-overview` | ภาพรวมสต็อก | Stock Dashboard |
| `stock-count` | ตรวจนับสต็อก | Physical count |
| `transfer` | โอนย้ายยา | Inter-warehouse transfer |
| `drug-return` | คืนยา | Return to supplier |
| `zone-picking` | หยิบยาตามโซน | Zone Picking |
| `wave-picking` | หยิบแบบ Wave | Wave Picking |
| `delivery` | จัดส่งยา | Delivery Scheduling |
| `dispensing` | เบิก-จ่ายยา | Requisition/Dispensing |
| `auth-lock` | สิทธิ์ยาจำกัด | Drug Authorization Lock |
| `fefo-expiry` | วันหมดอายุ | FEFO alerts, Expiry list |
| `drug-interaction` | ยาตีกัน | Interaction check |
| `barcode-scan` | สแกนบาร์โค้ด | Scan dialog |
| `dashboard` | รายงาน | Reports/Dashboard |
| `alert` | แจ้งเตือนยา | Notifications |
| `ven-abc` | วิเคราะห์ VEN/ABC | Analysis reports |

### HIS Modules (25)
| Icon name | Thai | Use case |
|-----------|------|----------|
| `registration` | ลงทะเบียน | Patient registration |
| `opd` | ผู้ป่วยนอก | OPD module |
| `ipd` | ผู้ป่วยใน | IPD module |
| `emergency` | ฉุกเฉิน | Emergency |
| `pharmacy` | เภสัชกรรม | Pharmacy |
| `laboratory` | ห้องปฏิบัติการ | Lab |
| `radiology` | รังสีวิทยา | Radiology |
| `surgery` | ห้องผ่าตัด | Surgery |
| `nursing` | การพยาบาล | Nursing |
| `dental` | ทันตกรรม | Dental |
| `rehab` | เวชศาสตร์ฟื้นฟู | Rehabilitation |
| `nutrition` | โภชนาการ | Nutrition |
| `blood-bank` | ธนาคารเลือด | Blood bank |
| `infection-control` | ควบคุมการติดเชื้อ | Infection control |
| `discharge` | จำหน่ายผู้ป่วย | Discharge |
| `med-records` | เวชระเบียน | Medical records |
| `referral` | ส่งต่อ | Referral |
| `appointment` | นัดหมาย | Appointment |
| `queue` | คิว | Queue management |
| `telehealth` | แพทย์ทางไกล | Telehealth |
| `kiosk` | ตู้คีออส | Self-service kiosk |
| `nhso-claims` | เบิกจ่าย สปสช. | NHSO claims |
| `billing` | การเงิน | Billing |
| `monitoring` | ติดตามผู้ป่วย | Patient monitoring |
| `help-center` | ศูนย์ช่วยเหลือ | Help center |

### Admin & System (10)
| Icon name | Thai | Use case |
|-----------|------|----------|
| `users` | ผู้ใช้งาน | User management |
| `rbac` | สิทธิ์การใช้งาน | Role-based access |
| `organization` | หน่วยงาน | Organization structure |
| `settings` | ตั้งค่า | System settings |
| `audit-log` | ประวัติการใช้งาน | Audit trail |
| `report-builder` | สร้างรายงาน | Report builder |
| `integration` | เชื่อมต่อระบบ | API integration |
| `notifications` | การแจ้งเตือน | Notification settings |
| `multi-site` | หลายสาขา | Multi-site config |
| `migration` | ย้ายข้อมูล | Data migration |

## How to Use

### 1. Register icons (once, in AppComponent or APP_INITIALIZER)

```typescript
import { AegisxIconRegistry } from './path/to/aegisx-icon-registry';

export class AppComponent {
  private iconRegistry = inject(AegisxIconRegistry);

  constructor() {
    // Register drug inventory icons (mono SVGs)
    this.iconRegistry.registerDrugInventoryIcons('assets/icons/aegisx/svg');
  }
}
```

### 2. Use in templates

```html
<!-- Mono icon (inherits text color) -->
<mat-icon svgIcon="drug-master"></mat-icon>

<!-- With color -->
<mat-icon svgIcon="fefo-expiry" class="text-[var(--ax-warning-default)]"></mat-icon>

<!-- Sized -->
<mat-icon svgIcon="dispensing" class="!w-8 !h-8"></mat-icon>

<!-- In navigation -->
<a routerLink="/inventory/drugs">
  <mat-icon svgIcon="drug-master"></mat-icon>
  <span>รายการยา</span>
</a>
```

### 3. Colored variant (for launcher cards / feature tiles)

```html
<img
  src="assets/icons/aegisx/svg-colored/drug-master.svg"
  alt="Drug Master"
  width="48"
  height="48"
/>
```

## Design Specs

- **ViewBox**: `0 0 24 24`
- **Stroke**: `currentColor`, width `1.5px`
- **Line cap/join**: `round`
- **Fill**: `none` (accent areas use `currentColor` at `0.1-0.2` opacity)
- **Style**: Stroke-based, consistent with Lucide/Heroicons

## Semantic Colors

```html
<!-- Navigation (inactive) -->
<mat-icon svgIcon="..." class="text-[var(--ax-text-secondary)]"></mat-icon>

<!-- Navigation (active) -->
<mat-icon svgIcon="..." class="text-[var(--ax-primary)]"></mat-icon>

<!-- Status: success -->
<mat-icon svgIcon="goods-receive" class="text-[var(--ax-success-default)]"></mat-icon>

<!-- Status: warning (expiry, low stock) -->
<mat-icon svgIcon="fefo-expiry" class="text-[var(--ax-warning-default)]"></mat-icon>

<!-- Status: error (expired, locked) -->
<mat-icon svgIcon="auth-lock" class="text-[var(--ax-error-default)]"></mat-icon>
```

## Anti-Patterns

- ❌ Don't use generic Material icons when a domain icon exists (e.g., use `drug-master` not `medication`)
- ❌ Don't hardcode colors on mono SVGs — they use `currentColor` and inherit from CSS
- ❌ Don't import colored SVGs via MatIconRegistry — use `<img>` for colored variants
- ❌ Don't create new icons without checking this list first
