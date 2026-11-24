# InBlack Orders (Flutter)

แอปติดตามคำสั่งซื้อแบบ **offline-first** ตามโจทย์ Mobile Developer — Flutter (Android + iOS)

| | |
|---|---|
| Flutter / Dart | 3.47.5 stable / 3.13.4 |
| State | Riverpod 3 |
| Navigation | go_router (auth redirect + deep link) |
| Network | dio + interceptor refresh แบบ single-flight, `web_socket_channel` |
| DB | drift (SQLite) schema v5 พร้อม migration ทุกเวอร์ชันและ test |
| Model | freezed + json_serializable |
| Background | workmanager (Android WorkManager / iOS BGTaskScheduler) |
| อื่น ๆ | flutter_secure_storage, local_auth, flutter_local_notifications, cached_network_image, connectivity_plus, share_plus, app_links, home_widget (UI widget เขียน native), intl + ARB (gen-l10n) |
| Lint | `very_good_analysis` — `flutter analyze` ต้องได้ **No issues found** |

---

## 1. ติดตั้งและรัน

### สิ่งที่ต้องมี
Flutter 3.47.5 stable, Android SDK 36 (compileSdk 36, minSdk 26), Node.js 20+ สำหรับ mock server, และ Xcode 16+ บน macOS สำหรับ iOS

### Mock server
```bash
node mock-server/server.mjs            # CHAOS=1 (โหมดที่ผู้ตรวจใช้)
CHAOS=0 node mock-server/server.mjs    # ไม่มี chaos ใช้ตอนพัฒนา
```

### เตรียมโค้ด
```bash
flutter pub get
dart run build_runner build      # ไฟล์ generate (freezed/json/drift) commit ไว้แล้ว รันเฉพาะเมื่อแก้ model/table
flutter gen-l10n                 # รันอัตโนมัติตอน build อยู่แล้ว
```

### รันแอป
```bash
# Android emulator (ค่าเริ่มต้น BASE_URL = http://10.0.2.2:8787)
flutter run --flavor dev --dart-define-from-file=config/dev.json

# iOS simulator (ต้องชี้ไป localhost)
flutter run --flavor dev --dart-define-from-file=config/dev.json --dart-define=BASE_URL=http://localhost:8787
```
- **Flavor** `dev` (`com.inblack.inblack_orders.dev`, ชื่อแอป "InBlack Orders Dev") และ `prod`
- **เครื่องจริงใน LAN:** เปลี่ยน Base URL ได้ใน **ตั้งค่า → Server URL (debug)** (เฉพาะ flavor dev) และต้องเพิ่ม IP ของเครื่องที่รัน server ใน `android/app/src/dev/res/xml/network_security_config.xml`
- บัญชีทดสอบ: `alice / alice1234` (~5,000 order), `bob / bob1234` (30 order)

### Test
```bash
flutter test                                                   # unit + integration (fake server) + DB + widget + golden — ไม่ต้องเปิด mock server
flutter test --update-goldens test/goldens                      # สร้าง golden ใหม่
flutter test integration_test -d <device> --dart-define=BASE_URL=http://<host>:8787   # E2E ต้องเปิด mock server
```
ผลล่าสุด: **189 tests passed**, E2E 1 flow passed (รันบน Windows desktop กับ mock server)

### Build ไฟล์ติดตั้ง
```bash
flutter build apk --flavor dev --release --dart-define-from-file=config/dev.json   # R8 + shrinkResources เปิด
flutter build ios --simulator --flavor dev --dart-define-from-file=config/dev.json  # ต้องใช้ macOS
```

---

## 2. Architecture

```
┌────────────────────────── presentation (Flutter widgets) ──────────────────────────┐
│ LoginScreen  OrdersListScreen  OrderDetailScreen  OutboxScreen  SettingsScreen      │
│ AppLockGate  ConnectionIndicator  DeepLinkListener  SessionServices                 │
└───────────────▲───────────────────────────────────────────────▲────────────────────┘
                │ watch (StateNotifier / StreamProvider)        │ actions
┌───────────────┴────────────── application (Riverpod) ─────────┴────────────────────┐
│ OrdersListController  OrderDetailController  LoginController  AuthStatus            │
│ OutboxActions  RealtimeControl  Settings  AppLockController  LogoutService          │
└───────▲──────────────────────────▲───────────────────────────▲─────────────────────┘
        │ read (Stream query)       │ write                     │
┌───────┴────────── data ──────────┴───────────────────────────┴─────────────────────┐
│ drift AppDatabase  ◄── จุดเดียวที่ UI อ่าน                                             │
│   orders · order_details · outbox · sync_state · notified_log                        │
│ OrderSyncEngine   OrderDetailRepository   OrdersRepository   OutboxProcessor         │
│ RealtimeClient + OrderEventApplier   OrderNotifier   HomeWidgetSync                  │
│ SessionManager (single-flight refresh)  AuthInterceptor  SecureTokenStorage          │
└───────▲──────────────────────────▲─────────────────────────────────────────────────┘
        │ HTTP (dio)               │ WebSocket
     mock server             /ws (hello / order.* / heartbeat)

Background isolate (workmanager) ──► OutboxProcessor.drain → OrderSyncEngine.sync
                                     → OrderNotifier → HomeWidgetSync   (DB เดียวกัน)
```

โฟลเดอร์หลัก: `lib/core` (database, network, connectivity, notifications, settings, format, home_widget), `lib/features/<feature>/{data,application,presentation}`, `lib/background`, `lib/app` (router, deep link, services)

### Data flow

**Sync**
1. login → `prepareForUser` (ถ้าเป็นผู้ใช้คนละคนกับคนก่อนจะล้าง DB) → preload 200 รายการ (4 หน้า) ใน transaction เดียว และเก็บ `syncSeq` กับ cursor ของหน้าถัดไป
2. ครั้งถัดไปดึง `/orders/changes?since=syncSeq` วนตาม `hasMore` แล้ว upsert ตาม `version`, ลบ tombstone และบันทึก `syncSeq` ใหม่ใน transaction เดียวกัน
3. ได้ `410` จะ preload ใหม่ทั้งหมด **ไม่แตะ outbox** (กรณี server ถูก reset ก็เข้าทางนี้)
4. เลื่อนรายการเกินข้อมูลในเครื่อง → `loadOlder()` / หน้าถัดไปของ filter หรือคำค้น
5. ตาราง `sync_state` เก็บขอบเขตของช่วงที่โหลดต่อเนื่องครบแล้ว (`oldest_*`) รายการแสดงเฉพาะแถวในขอบเขตนี้ จึงไม่มีรูจาก order เก่าที่หลุดเข้ามาทาง change feed

**Outbox**
1. ผู้ใช้กด → insert ลงตาราง `outbox` (สร้าง `Idempotency-Key` ตอนนี้ และ cancel เก็บ `If-Match` เป็น version ที่ผู้ใช้เห็น)
2. UI แสดงผลแบบ optimistic จาก outbox (badge "ยกเลิกแล้ว" + "รอส่ง", โน้ตที่ "รอส่ง") โดยไม่เขียนทับแถว `orders` resync จึงไม่ทำให้สถานะรอส่งหาย
3. `OutboxProcessor.drain()` ส่งทีละ order ตามลำดับ (FIFO ต่อ order ถ้าตัวหัวค้างอยู่ ตัวหลังจะรอ):
   - **สำเร็จ:** บันทึกผลจาก server แล้วลบแถว
   - **network / timeout / 5xx / 429 / `request_in_progress`:** backoff + jitter เคารพ `Retry-After` และ **ใช้ key เดิม** เกิน 8 ครั้งจะเป็น `failed` ให้ผู้ใช้สั่ง "ลองใหม่"
   - **`409 version_conflict`:** สถานะ `conflict` เก็บ `current` จาก server ไว้แล้วแสดงให้ผู้ใช้เลือก "ยกเลิกอีกครั้ง" (key ใหม่ + version ใหม่) หรือ "ไม่ต้องยกเลิก"
   - **`422` / `404` / `400`:** `failed` ย้อน optimistic state กลับ บอกเหตุผล และให้ "ทิ้ง"
   - **`401`:** หยุดรอจนกว่าจะ login ใหม่
4. ตัวกระตุ้น: ตอนกด, เปิดหน้ารายการ, แอปกลับมา foreground, เน็ตกลับมา, timer ตาม `nextAttemptAt` และ background worker

**Realtime**
1. `RealtimeClient` ทำงานเฉพาะเมื่อ login + foreground + มีเน็ต (`connectivity_plus`)
2. ได้ `hello` → Live, reset backoff และถ้า `hello.syncSeq` ≠ ของในเครื่องจะเรียก `/orders/changes`
3. `order.*` → `OrderEventApplier`
   - `UPDATE ... WHERE version < ใหม่` เพื่อให้ event ที่ซ้ำหรือสลับลำดับไม่ทับของใหม่
   - จำ seq ที่ถูกลบไว้ ทำให้ event ที่มาช้าไม่ทำให้ order ที่ลบไปแล้วกลับมา
   - ถ้า seq กระโดดจะ debounce 2 วิ แล้วเติมด้วย changes
4. Watchdog: ถ้าเงียบเกิน `heartbeat × 2 + 5 วิ` จะตัดแล้วต่อใหม่ (ส่ง ping ทุก heartbeat)
5. Backoff: 1, 2, 4 … สูงสุด 30 วิ แบบ jitter 50–100%
6. Token: ส่ง `auth` ก่อนหมดอายุ 10 วิ โดยใช้ refresh ตัวเดียวกับ HTTP • close `4001` → refresh แล้วต่อใหม่ทันที • `4003` → จบ session • handshake ไม่ผ่าน → เรียก `/me` ให้ interceptor refresh แล้วลองใหม่

---

## 3. ADR (การตัดสินใจหลัก)

| # | เรื่อง | ตัดสินใจ | เหตุผล / trade-off |
|---|---|---|---|
| 1 | State | **Riverpod** (Notifier + StreamProvider) | override ง่ายใน test ไม่ผูกกับ widget tree และ logic ไม่อยู่ใน `setState` |
| 2 | DB | **drift** + `shareAcrossIsolates` | stream query ทำให้ UI อ่านจาก DB อย่างเดียว, migration มีเครื่องมือ (`make-migrations` + `SchemaVerifier`), background isolate ใช้ DB เดียวกันได้ |
| 3 | เวลาใน DB | epoch ms (UTC) แทน `DateTime` ของ drift | ค่า default ของ drift เก็บเป็นวินาที ซึ่งทำให้เรียง order ที่สร้างห่างกันไม่ถึง 1 วิผิด |
| 4 | รายการ | หน้าต่าง LIMIT จาก DB + ดึงจาก server เมื่อหมด (ไม่ใช้ package paging) | ควบคุมขอบเขตเองได้ จึงไม่มีรูของข้อมูล และคำค้นออนไลน์ใช้ "รายการ id จาก server" แต่อ่านแถวจาก DB (playerId / สินค้าทุกชิ้นไม่มีในเครื่อง) |
| 5 | Refresh | `SessionManager.refresh()` ใช้ `Future` ร่วมกัน + เทียบ token ที่ fail กับ token ปัจจุบัน | server ตรวจ reuse ถ้า refresh ซ้อนกัน session จะถูกเพิกถอน • **ไม่ retry เมื่อเน็ตหลุด** (server อาจรับไปแล้ว ส่งซ้ำ = reuse) • 503 → retry ≤ 3 ครั้ง ไม่ logout |
| 6 | Outbox | ตารางใน DB + key สร้างตอนกด + FIFO ต่อ order + optimistic อ่านจาก outbox | รอดจากการถูก kill, ไม่เกิดผลซ้ำแม้ response หาย (server replay), resync ไม่ทำให้ "รอส่ง" หาย • trade-off: action หลังตัวที่ค้างจะรอ |
| 7 | Realtime merge | `version` เป็นตัวตัดสินเสมอ ไม่เลื่อน `syncSeq` จาก WS | change feed เป็นแหล่งจริงของ `syncSeq` ส่วน WS เป็นแค่ทางลัด ข้อมูลไม่เพี้ยนแม้ event ซ้ำหรือสลับลำดับ |
| 8 | Background | workmanager periodic 15 นาที, constraint ต้องมีเน็ต, **foreground lease** ใน `sync_state.foreground_until` (ต่ออายุทุก 60 วิ หมดใน 90 วิ) | ไม่ทำงานซ้อนกับ sync ตอนเปิดแอป และกัน refresh ซ้อนข้าม isolate |
| 9 | Notification | dedupe ด้วยตาราง `notified_log (order_id, version)` | ใช้ร่วมกันทั้ง WS / foreground sync / background • เกิน 3 → สรุป • ไม่แจ้ง order ที่กำลังดู และไม่แจ้งการยกเลิกที่ผู้ใช้ทำเอง |
| 10 | Deep link | `app_links` + ปิด Flutter deep linking แล้ว map URI เป็น path ของ go_router เอง | ได้ path เดียวกันทั้งจากลิงก์, notification และ widget • ตอนยังไม่ login: redirect ไป `/login?from=…` แล้วพากลับไปหน้าเดิม (เปิดเฉพาะ path `/orders…`) |
| 11 | Secure storage | `flutter_secure_storage` (Keystore / Keychain `first_unlock_this_device`) | background task อ่าน token ได้หลังปลดล็อกครั้งแรก และไม่ติดไปกับ backup • Android `allowBackup=false` |
| 12 | Home widget | `home_widget` ส่งข้อมูลอย่างเดียว ส่วน UI เขียน native: Android `AppWidgetProvider` (Kotlin + RemoteViews), iOS WidgetKit (SwiftUI) | ตามข้อบังคับ ไม่ render จาก Flutter • widget ไม่ยิง network เอง |
| 13 | Cleartext | อนุญาตเฉพาะ flavor **dev** และเฉพาะ `10.0.2.2`, `localhost`, `127.0.0.1` | prod ใช้ HTTPS เท่านั้น |

### Certificate pinning (ถ้าขึ้น production)
จะทำ **public-key (SPKI) pinning** ที่ dio (`HttpClient.badCertificateCallback` / `SecurityContext`) โดย pin **อย่างน้อย 2 key** คือ key ปัจจุบันและ key สำรองที่ออกไว้ล่วงหน้า ก่อนหมุน certificate จะออกเวอร์ชันแอปที่มี key ใหม่ล่วงหน้าอย่างน้อย 1 รอบ release และใช้ remote config ปิด pinning ฉุกเฉินได้ (มี expiry) เพื่อไม่ให้ผู้ใช้เวอร์ชันเก่าเชื่อมต่อไม่ได้ทั้งหมด

### iOS background ไม่รับประกันเวลา
`BGAppRefreshTask` ระบบเป็นผู้ตัดสินว่าจะรันเมื่อไร (ขึ้นกับแบตเตอรี่และพฤติกรรมการใช้งาน) และอาจไม่รันเลยถ้าผู้ใช้ force-quit แอป จึงออกแบบรับมือดังนี้:
- background เป็น "โบนัส" ส่วนความถูกต้องมาจาก foreground: ทุกครั้งที่กลับเข้าแอปจะ sync และส่ง outbox ทันที
- outbox อยู่ใน DB จึงไม่หายไม่ว่า background จะได้รันหรือไม่
- งานใน background สั้นและ idempotent: drain → changes → notification → widget
- dedupe notification ด้วย (order, version) ทำให้เปิดแอปทีหลังแล้วไม่แจ้งซ้ำกับที่ background แจ้งไปแล้ว

### ถ้าจะเปลี่ยนเป็น remote push (APNs / FCM)
1. ส่ง device token ไปที่ backend หลัง login และลบตอน logout
2. backend ส่ง push เมื่อสถานะเป็น COMPLETED / CANCELLED / REFUNDED โดยแนบ `orderId` และ `version` (ไม่ใส่ข้อมูลส่วนตัว)
3. ให้ push เป็น data/silent push ที่ปลุกแอปไปเรียก `/orders/changes` แล้วใช้ `OrderNotifier` เดิม (dedupe เดิมยังใช้ได้) หรือเป็น alert push ที่มี payload `inblack://orders/{id}` ให้ DeepLinkListener เดิมรับต่อ
4. iOS เปิด capability Push + Background Modes (remote-notification) • Android เพิ่ม `firebase_messaging` และ channel เดิม
5. ลด periodic background sync ลงเหลือไว้เป็นตัวสำรอง

---

## 4. Feature

| # | Feature | สถานะ | หมายเหตุ |
|---|---|---|---|
| F1 | Login & Session | ✅ ครบ | validate, 429 นับถอยหลัง, Keystore/Keychain, single-flight refresh (มี test 5 request พร้อมกัน), 503 ไม่ logout, session หมด → login พร้อมข้อความและจำปลายทาง, logout ล้าง token / DB / outbox / งาน background / notification / widget / แคชรูป |
| F2 | App Lock | ✅ ครบ (ยังไม่ทดสอบบนเครื่องจริง) | เปิดต้องยืนยันก่อน, ล็อกเมื่ออยู่ background เกิน 30 วิ, รหัสเครื่องใช้แทนได้, ปิดบังเนื้อหาตอน inactive (App Switcher), เครื่องที่ไม่มี biometric/รหัส → ให้ออกจากระบบ |
| F3 | รายการคำสั่งซื้อ | ✅ ครบ | infinite scroll, filter หลายค่า + จำนวน, debounce 300ms (คำค้นเก่าที่มาช้าถูกทิ้ง), pull-to-refresh พร้อม summary, state ครบ, badge มีไอคอน + ข้อความ + สี, status ที่ไม่รู้จักแสดงและกรองได้, ปุ่ม "มี N รายการใหม่" |
| F4 | Offline-first | ✅ ครบ | UI อ่านจาก DB เท่านั้น, แถบออฟไลน์ + อัปเดตล่าสุด, preload 200, changes / tombstone / 410, ค้นหาตอนออฟไลน์พร้อมป้าย, server reset ฟื้นตัวได้ |
| F5 | Realtime | ✅ ครบ | foreground เท่านั้น, merge ตาม version, watchdog, backoff + jitter, หยุดเมื่อไม่มีเน็ต, เติมช่องว่าง, ต่ออายุด้วย `auth`, Live / กำลังเชื่อมต่อใหม่… / ออฟไลน์ |
| F6 | รายละเอียด | ✅ ครบ | ข้อมูลครบ + รูป (cache / placeholder), ETag/304, อัปเดตอัตโนมัติ, คัดลอก / แชร์, แจ้งเมื่อถูกลบ, ข้อความไทยยาว + อีโมจิที่ 200% (มี test) |
| F7 | Outbox | ✅ ครบ | ดูหัวข้อ 2 |
| F8 | Background Sync | ✅ Android / ⚠️ iOS | Android ใช้ WorkManager (unique periodic + network constraint + backoff) • iOS ลงทะเบียน BGTask ใน `Info.plist` / `AppDelegate` แล้ว แต่ **ยังไม่ได้ build/ทดสอบบน iOS** |
| F9 | Notification | ✅ ครบ (Android) | dedupe, สรุปเมื่อเกิน 3, ไม่แจ้ง order ที่กำลังดู, ขอ permission ผ่านการ์ดในหน้ารายการ (ไม่ขอตอนเปิดแอปครั้งแรก) + toggle ใน Settings, กดแล้วเปิด deep link |
| F10 | Deep Link | ✅ ครบ | `inblack://orders/{id}`, `inblack://orders?status=…`, cold start / background / ยังไม่ login, id ไม่มี → หน้าไม่พบ, back กลับหน้ารายการ |
| F11 | แจ้งปัญหาพร้อมรูป | ❌ ไม่ได้ทำ | ให้ความสำคัญกับ MUST ก่อน ถ้าทำต่อจะใช้ image_picker → ย่อรูป (`image` package บน isolate) → ตัด EXIF → upload ผ่าน outbox แบบ multipart (key เดิม) |
| F12 | Home Widget | ✅ Android / ⚠️ iOS | Android native AppWidget ทำครบ (จำนวน order ที่ยังไม่จบ + 3 รายการล่าสุด, กดแล้วเปิด deep link, ล้างหลัง logout) • iOS มีโค้ด WidgetKit ใน `ios/OrdersWidget/` แต่ต้องเพิ่ม Widget Extension target + App Group `group.com.inblack.orders` ใน Xcode (ทำบน Windows ไม่ได้) |
| F13 | Settings / ภาษา / ธีม | ✅ ครบ | ไทย/อังกฤษเปลี่ยนทันที (รวมรูปแบบวันที่และตัวเลข), ธีม 3 แบบ, toggle แจ้งเตือน / ล็อกแอป, ล้างแคชรูป, เวอร์ชัน + build, Base URL (dev) |
| F14 | Accessibility | ✅ ส่วนใหญ่ | semantics ทุกปุ่ม/badge/การ์ด, ตัวอักษร 200% ไม่ล้น (test + golden), touch target ≥ 48dp, สี badge ผ่าน WCAG AA (มี test คำนวณ contrast) • ยังไม่ได้ทดสอบด้วย TalkBack / VoiceOver จริง |
| F15 | State Restoration | ⚠️ บางส่วน | filter/คำค้นอยู่ใน controller (รอดการหมุนจอและเปลี่ยนธีม) แต่ **ยังไม่รอด process death** และยังไม่เก็บ scroll / draft โน้ต |

Bonus: ไม่ได้ทำ

---

## 5. Test

| ประเภท | ไฟล์ |
|---|---|
| Unit | `token_refresh_test` (single-flight 5 request, 2 รอบ, 503, เน็ตหลุด, reuse, revoked), `retry_policy_test`, `outbox_processor_test` (response หาย → key เดิม → server ทำครั้งเดียว, Retry-After, 409, 422, 404, FIFO, max attempts, ถูก kill), `realtime_client_test` (fake_async: foreground, backoff, watchdog, ping, 4001/4003, offline, ต่ออายุ token), `order_event_applier_test`, `formatters_test`, `order_status_test`, `deep_links_test`, `day6_services_test` |
| Integration (fake server ผ่าน dio adapter) | `order_sync_engine_test` (preload, pagination, changes + hasMore, tombstone, 410, server reset), `orders_list_controller_test`, `order_detail_test` |
| Database | `app_database_test` (DAO / query), `test/drift/app_database/migration_test.dart` (v1→v5 ทั้ง schema และข้อมูล) |
| UI | `orders_list_screen_test`, `order_detail_screen_test`, `widget_test` (login, สลับภาษา) |
| Golden | `test/goldens/` 3 ภาพ: สว่าง, มืด, ข้อความไทยยาว + 200% |
| E2E | `integration_test/login_cancel_flow_test.dart` (login → list → detail → cancel กับ mock server) |

---

## 6. ทดสอบกับ mock server จริง (`CHAOS=1`)

| สถานการณ์ | ผล |
|---|---|
| 8 request พร้อมกันหลัง token หมดอายุ × 3 รอบ (`ACCESS_TTL=5`) | refresh 3 ครั้งพอดี, `refreshReuseDetected: 0` |
| `/admin/reset` | session จบ → login ใหม่ → 410 → resync สำเร็จ |
| WS drop / close 1012 / 4001 / stall | กลับมา Live ใน 0.85 / 1.0 / 0.4 / 35.7 วิ |
| เลื่อนรายการ alice | 50 → 450 แถว (เกิน preload ดึงจาก server ต่อ), status `ON_HOLD` ที่ไม่รู้จักแสดงได้ |

---

## 7. ปัญหาที่รู้อยู่ / สิ่งที่จะทำต่อ

- **iOS ยังไม่ได้ build:** พัฒนาบน Windows ไม่มี Mac • ยังไม่มี iOS flavor scheme (`dev`/`prod` ฝั่ง Xcode), Widget Extension target, Privacy Manifest และ iOS simulator build
- **F11 (แจ้งปัญหาพร้อมรูป):** ไม่ได้ทำ
- **F15:** ยังไม่รอด process death
- **Android ยังไม่ได้ทดสอบบนเครื่อง/emulator จริง** (ไม่มี emulator ในเครื่องพัฒนา) • ทดสอบผ่าน unit/widget/golden test + E2E บน Windows desktop + build release APK (R8) สำเร็จ ยังไม่ได้เปิด APK บนเครื่องจริงว่า R8 ไม่ทำให้ crash
- **flutter_local_notifications 22:** ใช้เวอร์ชันนี้เพราะ 23 ต้อง compileSdk 37
- **หลังรีสตาร์ทแอป:** ยังไม่รู้เวลาหมดอายุของ access token จึงพึ่ง `4001` / `401` แทนการต่ออายุล่วงหน้า
- **Outbox แบบ FIFO ต่อ order:** action ที่ตามหลังตัวที่ล้มเหลวถาวรจะรอจนผู้ใช้ "ทิ้ง" ตัวนั้น
- **จำนวนบน filter chip:** มาจาก server ตอนเปิดแอปแบบออฟไลน์จึงไม่มีตัวเลข
- **ยังไม่ได้ทำ:** วัด frame time จริง (Bonus), CI, การเปิด system settings จากแอปเมื่อปฏิเสธ notification (ตอนนี้แสดงข้อความแนะนำแทน)

## 8. สมมติฐาน

- `status` เก็บเป็นข้อความดิบ (ไม่ใช่ enum) เพราะ server เพิ่มค่าใหม่ได้
- แสดงเวลา Asia/Bangkok (UTC+7 ไม่มี DST) เสมอ ไม่ว่าเครื่องจะตั้ง timezone อะไร
- ตอนออฟไลน์รายการแสดงทุกแถวที่มีในเครื่อง (อาจไม่ต่อเนื่อง) ส่วนตอนออนไลน์แสดงเฉพาะช่วงที่โหลดต่อเนื่องครบ
- session หมดอายุแต่ login กลับมาเป็นผู้ใช้เดิม → เก็บข้อมูลในเครื่องไว้ ส่วน logout เอง → ล้างทุกอย่าง

## 9. การใช้ AI

- **เครื่องมือ:** Claude Code (Claude Opus) ใน VS Code
- **ใช้กับ:** วางแผนงาน, ร่างและเขียนโค้ดเกือบทุกส่วน (data layer, sync, outbox, realtime, UI, platform config), เขียน test, ไล่แก้ build และเขียนเอกสารนี้ รวมถึงการลองกับ mock server จริงผ่าน test ชั่วคราว
- **ผู้สมัครเป็นผู้:** กำหนดลำดับงานรายวัน, ทดสอบแอปด้วยตัวเอง, ตรวจและ commit • **รับผิดชอบความถูกต้องของโค้ดทุกบรรทัดใน repo**
