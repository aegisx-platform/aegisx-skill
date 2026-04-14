# Field Addition Checklist (MANDATORY)

> **ทุกครั้งที่เพิ่ม field ใหม่ ต้องทำครบทุกข้อ ห้ามข้าม ห้ามบอก "เสร็จแล้ว" จนกว่าจะผ่านทุกข้อ**

## เมื่อไหร่ต้องใช้

- เพิ่ม column ใหม่ใน DB
- เพิ่ม field ใน API request/response
- เพิ่ม field ใน frontend form/table

## Checklist (ทำตามลำดับ)

### Layer 1: Database

```
□ Migration สร้างแล้ว
□ Migration รันสำเร็จ
□ เช็ค DB ว่า column มีจริง: SELECT column_name FROM information_schema.columns WHERE ...
```

### Layer 2: Backend Schema (TypeBox)

```
□ Entity/Response schema มี field (ถ้าไม่มี Fastify STRIP ออกจาก response!)
□ Create schema มี field (ถ้าต้อง create)
□ Update schema มี field (ถ้าต้อง update)
□ Route-level inline schema มี field (เช่น batch update body schema ใน route.ts)
```

### Layer 3: Backend Logic

```
□ Repository transformToEntity มี field
□ Repository transformToDb มี field
□ Controller transformUpdateSchema มี field (ห้ามลืม! field จะถูก drop เงียบ)
□ Controller transformCreateSchema มี field (ถ้ามี create)
□ Service method type definition มี field
□ build:schemas รันแล้ว
```

### Layer 4: Frontend

```
□ Type/Interface มี field
□ Component ส่ง field ใน payload
□ Template แสดง field

```

### Layer 5: ทดสอบ (ห้ามข้าม!)

```
□ API test: POST/PUT ส่ง field → เช็ค DB ว่าบันทึก
□ API test: GET → เช็ค response มี field กลับมา
□ UI test: แก้ค่า → Save → Reload → ค่ายังอยู่
```

## วิธีเช็คเร็ว

```bash
# 1. DB
docker exec aegisx_postgres psql -U postgres -d aegisx_db -c \
  "SELECT column_name FROM information_schema.columns WHERE table_schema='inventory' AND table_name='TABLE' AND column_name='FIELD';"

# 2. Schema - grep ทุก schema file
grep -n "FIELD" apps/api/src/layers/domains/inventory/.../MODULE.schemas.ts

# 3. Route inline schema
grep -n "FIELD" apps/api/src/layers/domains/inventory/.../MODULE.route.ts

# 4. Repository
grep -n "FIELD" apps/api/src/layers/domains/inventory/.../MODULE.repository.ts

# 5. Service
grep -n "FIELD" apps/api/src/layers/domains/inventory/.../MODULE.service.ts

# 6. Controller
grep -n "FIELD" apps/api/src/layers/domains/inventory/.../MODULE.controller.ts

# 7. Build schemas
pnpm run build:schemas

# 8. Test API
curl -s "http://localhost:4200/api/..." | node -e "process.stdin.on('data',d=>console.log(JSON.parse(d).data?.[0]?.FIELD))"
```

## ถ้าพลาดข้อใดข้อหนึ่ง

- Field ไม่บันทึก → ขาด Layer 2 (route schema) หรือ Layer 3 (service/repository)
- Field บันทึกแต่ไม่แสดง → ขาด Layer 2 (Entity/Response schema) → Fastify strip
- Field แสดงแต่หายหลัง reload → ขาด Layer 3 (transformToDb) หรือ Layer 2 (Update schema)
