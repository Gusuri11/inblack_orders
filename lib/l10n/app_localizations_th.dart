// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'InBlack Orders';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get backToList => 'กลับไปหน้ารายการ';

  @override
  String get discard => 'ทิ้ง';

  @override
  String get unknown => 'ไม่ทราบ';

  @override
  String get errorTimeout => 'เซิร์ฟเวอร์ตอบช้าเกินไป กรุณาลองใหม่';

  @override
  String get errorNetwork =>
      'ไม่สามารถเชื่อมต่อได้ ตรวจสอบอินเทอร์เน็ตแล้วลองใหม่';

  @override
  String get errorRateLimited => 'มีการใช้งานถี่เกินไป กรุณารอสักครู่';

  @override
  String get errorServer => 'เซิร์ฟเวอร์ขัดข้องชั่วคราว กรุณาลองใหม่';

  @override
  String get errorSessionExpired => 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่';

  @override
  String get errorGeneric => 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  @override
  String get loginSubtitle => 'เข้าสู่ระบบเพื่อติดตามคำสั่งซื้อ';

  @override
  String get usernameLabel => 'ชื่อผู้ใช้';

  @override
  String get usernameRequired => 'กรุณากรอกชื่อผู้ใช้';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get passwordRequired => 'กรุณากรอกรหัสผ่าน';

  @override
  String get showPassword => 'แสดงรหัสผ่าน';

  @override
  String get hidePassword => 'ซ่อนรหัสผ่าน';

  @override
  String get loginButton => 'เข้าสู่ระบบ';

  @override
  String loginRetryIn(int seconds) {
    return 'ลองใหม่ได้ใน $seconds วินาที';
  }

  @override
  String get loginInvalid => 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';

  @override
  String loginTooMany(int seconds) {
    return 'ลองเข้าสู่ระบบผิดหลายครั้งเกินไป กรุณารอ $seconds วินาที';
  }

  @override
  String get sessionRevoked =>
      'เพื่อความปลอดภัย เซสชันของคุณถูกยกเลิก กรุณาเข้าสู่ระบบอีกครั้ง';

  @override
  String get sessionExpired => 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบอีกครั้ง';

  @override
  String sessionResume(String message) {
    return '$message แล้วเราจะพาคุณกลับไปหน้าเดิม';
  }

  @override
  String get statusPending => 'รอชำระเงิน';

  @override
  String get statusPaid => 'ชำระเงินแล้ว';

  @override
  String get statusInProgress => 'กำลังดำเนินการ';

  @override
  String get statusCompleted => 'สำเร็จ';

  @override
  String get statusCancelled => 'ยกเลิกแล้ว';

  @override
  String get statusRefunded => 'คืนเงินแล้ว';

  @override
  String statusSemantics(String label) {
    return 'สถานะ: $label';
  }

  @override
  String get ordersTitle => 'คำสั่งซื้อ';

  @override
  String refreshFailed(String reason) {
    return 'รีเฟรชไม่สำเร็จ: $reason';
  }

  @override
  String newItems(int count) {
    return 'มี $count รายการใหม่';
  }

  @override
  String get loadingOrders => 'กำลังโหลดคำสั่งซื้อ…';

  @override
  String get searchHint => 'ค้นหาเลขคำสั่งซื้อ, Player ID, ชื่อสินค้า';

  @override
  String get clearSearch => 'ล้างคำค้น';

  @override
  String get offline => 'ออฟไลน์';

  @override
  String offlineUpdated(String time) {
    return 'ออฟไลน์ · อัปเดตล่าสุดเมื่อ $time';
  }

  @override
  String get localResults =>
      'แสดงผลจากข้อมูลในเครื่อง (ออฟไลน์) อาจไม่ครบทุกรายการ';

  @override
  String emptySearch(String query) {
    return 'ไม่พบคำสั่งซื้อที่ตรงกับ “$query”';
  }

  @override
  String get emptyFilter => 'ไม่มีคำสั่งซื้อในสถานะที่เลือก';

  @override
  String get emptyAll => 'ยังไม่มีคำสั่งซื้อ';

  @override
  String loadMoreFailed(String reason) {
    return 'โหลดเพิ่มไม่สำเร็จ: $reason';
  }

  @override
  String get loadingMore => 'กำลังโหลดรายการเพิ่ม';

  @override
  String get endOfList => 'แสดงครบทุกรายการแล้ว';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get noProduct => 'ไม่มีรายการสินค้า';

  @override
  String moreItems(int count) {
    return ' (+$count รายการ)';
  }

  @override
  String get pending => 'รอส่ง';

  @override
  String get sendFailed => 'ส่งไม่สำเร็จ';

  @override
  String sendState(String label) {
    return 'สถานะการส่ง: $label';
  }

  @override
  String copiedOrderId(String id) {
    return 'คัดลอกเลขคำสั่งซื้อ $id แล้ว';
  }

  @override
  String get loadFailed => 'ไม่สามารถโหลดข้อมูลได้';

  @override
  String get copyOrderId => 'คัดลอกเลขคำสั่งซื้อ';

  @override
  String get shareOrder => 'แชร์ลิงก์คำสั่งซื้อ';

  @override
  String totalSemantics(String amount) {
    return 'ยอดรวม $amount';
  }

  @override
  String get orderedAt => 'สั่งซื้อเมื่อ';

  @override
  String get updatedAt => 'อัปเดตล่าสุด';

  @override
  String get playerId => 'Player ID';

  @override
  String get channel => 'ช่องทาง';

  @override
  String itemsTitle(int count) {
    return 'สินค้า ($count)';
  }

  @override
  String get noItemsInOrder => 'ไม่มีรายการสินค้า';

  @override
  String get historyTitle => 'ประวัติสถานะ';

  @override
  String get noHistory => 'ยังไม่มีประวัติ';

  @override
  String notesTitle(int count) {
    return 'โน้ต ($count)';
  }

  @override
  String get noNotes => 'ยังไม่มีโน้ต';

  @override
  String attachmentsTitle(int count) {
    return 'ไฟล์แนบ ($count)';
  }

  @override
  String get noAttachments => 'ไม่มีไฟล์แนบ';

  @override
  String get deletedBanner =>
      'คำสั่งซื้อนี้ถูกลบออกจากระบบแล้ว ข้อมูลด้านล่างเป็นข้อมูลล่าสุดก่อนถูกลบ';

  @override
  String get actorSystem => 'ระบบ';

  @override
  String get actorCustomer => 'ลูกค้า';

  @override
  String get actorAdmin => 'แอดมิน';

  @override
  String get actorSupport => 'ทีมงาน';

  @override
  String byActor(String actor) {
    return 'โดย$actor';
  }

  @override
  String get noteFromSupport => 'ทีมงาน';

  @override
  String get noteFromYou => 'คุณ';

  @override
  String get notFoundTitle => 'ไม่พบคำสั่งซื้อ';

  @override
  String notFoundBody(String id) {
    return 'ไม่พบคำสั่งซื้อ $id อาจถูกลบไปแล้วหรือลิงก์ไม่ถูกต้อง';
  }

  @override
  String get outboxNetwork => 'ส่งไม่สำเร็จเพราะเชื่อมต่อเซิร์ฟเวอร์ไม่ได้';

  @override
  String get outboxNotCancellable =>
      'คำสั่งซื้อนี้ยกเลิกไม่ได้แล้ว เพราะสถานะเปลี่ยนไป';

  @override
  String get outboxNotFound => 'ไม่พบคำสั่งซื้อนี้แล้ว อาจถูกลบไปก่อนส่ง';

  @override
  String get outboxValidation => 'ข้อมูลไม่ถูกต้อง กรุณาแก้ไขแล้วลองใหม่';

  @override
  String get outboxConflict => 'สถานะคำสั่งซื้อเปลี่ยนไประหว่างรอส่ง';

  @override
  String get outboxDuplicate => 'คำขอนี้ซ้ำกับคำขอก่อนหน้า';

  @override
  String get outboxUnauthorized => 'รอเข้าสู่ระบบใหม่';

  @override
  String get outboxQueued => 'รอส่ง';

  @override
  String outboxFailedCode(String code) {
    return 'ส่งไม่สำเร็จ ($code)';
  }

  @override
  String get kindCancel => 'ยกเลิกคำสั่งซื้อ';

  @override
  String get kindNote => 'เพิ่มโน้ต';

  @override
  String get reasonRequired => 'กรุณาระบุเหตุผล';

  @override
  String reasonTooLong(int max) {
    return 'เหตุผลยาวได้ไม่เกิน $max ตัวอักษร';
  }

  @override
  String get cancelDialogTitle => 'ยกเลิกคำสั่งซื้อ?';

  @override
  String cancelDialogBody(String id) {
    return 'คำสั่งซื้อ $id จะถูกยกเลิก และไม่สามารถย้อนกลับได้';
  }

  @override
  String get cancelReasonLabel => 'เหตุผลในการยกเลิก';

  @override
  String get keepOrder => 'ไม่ยกเลิก';

  @override
  String get confirmCancel => 'ยืนยันยกเลิก';

  @override
  String get cancelOrder => 'ยกเลิกคำสั่งซื้อ';

  @override
  String get cancelQueued =>
      'บันทึกคำขอยกเลิกแล้ว จะส่งให้อัตโนมัติเมื่อออนไลน์';

  @override
  String get pendingCancel =>
      'คำขอยกเลิกรอส่ง จะส่งให้อัตโนมัติเมื่อเชื่อมต่อได้';

  @override
  String pendingCancelRetrying(String reason) {
    return 'คำขอยกเลิกรอส่ง ($reason) กำลังลองใหม่อัตโนมัติ';
  }

  @override
  String actionFailed(String kind, String reason) {
    return '$kindไม่สำเร็จ: $reason';
  }

  @override
  String conflictAsk(String status) {
    return 'สถานะคำสั่งซื้อเปลี่ยนไประหว่างรอส่ง ตอนนี้: $status ต้องการยกเลิกอีกครั้งหรือไม่?';
  }

  @override
  String conflictFinal(String status) {
    return 'ยกเลิกไม่สำเร็จ เพราะสถานะเปลี่ยนเป็น $status แล้ว';
  }

  @override
  String get cancelAgain => 'ยกเลิกอีกครั้ง';

  @override
  String get dontCancel => 'ไม่ต้องยกเลิก';

  @override
  String get acknowledge => 'รับทราบ';

  @override
  String get noteRequired => 'กรุณาพิมพ์ข้อความ';

  @override
  String noteTooLong(int max) {
    return 'ยาวได้ไม่เกิน $max ตัวอักษร';
  }

  @override
  String get noteLabel => 'เขียนโน้ตถึงทีมงาน';

  @override
  String get sendNote => 'ส่งโน้ต';

  @override
  String get outboxTitle => 'รายการรอส่ง';

  @override
  String get sendNow => 'ส่งตอนนี้';

  @override
  String get outboxEmpty => 'ไม่มีรายการที่รอส่ง';

  @override
  String get stateSending => 'กำลังส่ง…';

  @override
  String get stateFailed => 'ส่งไม่สำเร็จ';

  @override
  String get stateConflict => 'สถานะเปลี่ยน ต้องตัดสินใจ';

  @override
  String get stateQueued => 'รอส่ง';

  @override
  String get stateRequeued => 'รอส่งใหม่';

  @override
  String reasonPrefix(String reason) {
    return 'เหตุผล: $reason';
  }

  @override
  String latestServerStatus(String status) {
    return 'สถานะล่าสุดจากเซิร์ฟเวอร์: $status';
  }

  @override
  String createdAttempts(String time, int attempts) {
    return 'สร้างเมื่อ $time · พยายาม $attempts ครั้ง';
  }

  @override
  String outboxFailedCount(int count) {
    return 'รายการส่งไม่สำเร็จ $count รายการ';
  }

  @override
  String outboxPendingCount(int count) {
    return 'รายการรอส่ง $count รายการ';
  }

  @override
  String get connLive => 'Live';

  @override
  String get connReconnecting => 'กำลังเชื่อมต่อใหม่…';

  @override
  String get connOffline => 'ออฟไลน์';

  @override
  String connSemantics(String label) {
    return 'สถานะการเชื่อมต่อ: $label';
  }

  @override
  String get settingsTitle => 'ตั้งค่า';

  @override
  String get settingsOpen => 'ตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get languageThai => 'ไทย';

  @override
  String get languageEnglish => 'English';

  @override
  String get theme => 'ธีม';

  @override
  String get themeSystem => 'ตามระบบ';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeDark => 'มืด';

  @override
  String get notifications => 'แจ้งเตือนคำสั่งซื้อ';

  @override
  String get notificationsHint =>
      'แจ้งเมื่อคำสั่งซื้อสำเร็จ ถูกยกเลิก หรือคืนเงิน';

  @override
  String get notificationsDenied =>
      'การแจ้งเตือนของแอปถูกปิดอยู่ เปิดได้ที่การตั้งค่าของเครื่อง';

  @override
  String get openSystemSettings => 'เปิดการตั้งค่า';

  @override
  String get appLock => 'ล็อกแอป';

  @override
  String get appLockHint =>
      'ต้องสแกนใบหน้า / ลายนิ้วมือ / รหัสเครื่อง เมื่อกลับเข้าแอปหลังออกไปเกิน 30 วินาที';

  @override
  String get appLockUnavailable =>
      'เครื่องนี้ยังไม่ได้ตั้งค่า biometric หรือรหัสเครื่อง';

  @override
  String get appLockReason => 'ยืนยันตัวตนเพื่อเปิด InBlack Orders';

  @override
  String get appLockEnableReason => 'ยืนยันตัวตนเพื่อเปิดใช้การล็อกแอป';

  @override
  String get unlock => 'ปลดล็อก';

  @override
  String get locked => 'InBlack Orders ถูกล็อกอยู่';

  @override
  String get clearImageCache => 'ล้างแคชรูปภาพ';

  @override
  String get imageCacheCleared => 'ล้างแคชรูปภาพแล้ว';

  @override
  String version(String version, String build) {
    return 'เวอร์ชัน $version ($build)';
  }

  @override
  String get baseUrl => 'Server URL (debug)';

  @override
  String get baseUrlHint => 'ต้องปิดแล้วเปิดแอปใหม่หลังเปลี่ยน';

  @override
  String get save => 'บันทึก';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get logoutConfirm =>
      'ออกจากระบบ? ข้อมูลทั้งหมดในเครื่อง รวมถึงรายการที่ยังไม่ได้ส่ง จะถูกลบ';

  @override
  String get enableNotificationsTitle => 'รับการแจ้งเตือนคำสั่งซื้อไหม?';

  @override
  String get enableNotificationsBody =>
      'เราจะแจ้งเมื่อคำสั่งซื้อของคุณสำเร็จ ถูกยกเลิก หรือคืนเงิน';

  @override
  String get enable => 'เปิด';

  @override
  String get notNow => 'ไว้ทีหลัง';

  @override
  String get notifCompletedTitle => 'คำสั่งซื้อสำเร็จ';

  @override
  String get notifCancelledTitle => 'คำสั่งซื้อถูกยกเลิก';

  @override
  String get notifRefundedTitle => 'คืนเงินคำสั่งซื้อแล้ว';

  @override
  String notifBody(String id, String product) {
    return '$id · $product';
  }

  @override
  String notifSummaryTitle(int count) {
    return 'มีคำสั่งซื้ออัปเดต $count รายการ';
  }

  @override
  String get notifChannel => 'อัปเดตคำสั่งซื้อ';

  @override
  String get widgetOpenOrders => 'คำสั่งซื้อที่ยังไม่จบ';
}
