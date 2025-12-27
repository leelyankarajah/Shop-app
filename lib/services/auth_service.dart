// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // إيميل الأونر (الآدمن) الرئيسي
  static const String adminEmail = 'leelyanrefaat@gmail.com';

  /// تسجيل مستخدم عادي
  /// (ممكن تضيفي name / phone من فورم التسجيل لاحقاً لو حابّة)
  Future<UserCredential> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final role =
        email.trim().toLowerCase() == adminEmail.toLowerCase()
            ? 'admin'
            : 'customer';

    await _db.child('users/${cred.user!.uid}').set({
      'email': email.trim(),
      'role': role,
      'name': name?.trim() ?? '',
      'phone': phone?.trim() ?? '',
    });

    return cred;
  }

  /// تسجيل دخول مستخدم (customer)
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _ensureUserRoleExists(cred.user!, email.trim());
    return cred;
  }

  /// تسجيل دخول الأونر (admin)
  Future<UserCredential> ownerLogin({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    final uid = cred.user!.uid;

    // نقرأ الدور من الـ Realtime Database
    final roleSnap = await _db.child('users/$uid/role').get();
    final role = roleSnap.exists ? roleSnap.value?.toString() ?? '' : '';

    if (role != 'admin') {
      // مش آدمن → نسجل خروج ونرمي خطأ
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'not-admin',
        message: 'This user is not an admin.',
      );
    }

    return cred;
  }

  /// قراءة الدور
  Future<String?> getRole(String uid) async {
    try {
      final snap = await _db.child('users/$uid/role').get();
      if (!snap.exists) return null;
      return snap.value?.toString();
    } catch (_) {
      return null;
    }
  }

  /// إرسال إيميل استرجاع الباسورد
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();

  // ---------- User profile helpers (Account page) ----------

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final snap = await _db.child('users/$uid').get();
      if (!snap.exists || snap.value is! Map) return null;

      return Map<String, dynamic>.from(snap.value as Map);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? email,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name.trim();
    if (phone != null) data['phone'] = phone.trim();
    if (email != null) data['email'] = email.trim();

    if (data.isEmpty) return;

    await _db.child('users/$uid').update(data);
  }

  /// لو المستخدم موجود في Auth بس ما إله role في الداتابيز
  Future<void> _ensureUserRoleExists(User user, String email) async {
    final ref = _db.child('users/${user.uid}');
    final snap = await ref.get();

    final role =
        email.trim().toLowerCase() == adminEmail.toLowerCase()
            ? 'admin'
            : 'customer';

    if (!snap.exists) {
      await ref.set({
        'email': email.trim(),
        'role': role,
        'name': '',
        'phone': '',
      });
    } else if (!snap.child('role').exists) {
      await ref.child('role').set(role);
    }
  }
}
