import 'package:inblack_orders/core/network/api_exception.dart';

String friendlyError(ApiException e) {
  if (e.isNetworkError) {
    return e.isTimeout
        ? 'เซิร์ฟเวอร์ตอบช้าเกินไป กรุณาลองใหม่'
        : 'ไม่สามารถเชื่อมต่อได้ ตรวจสอบอินเทอร์เน็ตแล้วลองใหม่';
  }
  if (e.statusCode == 429) return 'มีการใช้งานถี่เกินไป กรุณารอสักครู่';
  if (e.isServerError) return 'เซิร์ฟเวอร์ขัดข้องชั่วคราว กรุณาลองใหม่';
  if (e.statusCode == 401) return 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่';
  return 'เกิดข้อผิดพลาด กรุณาลองใหม่';
}
