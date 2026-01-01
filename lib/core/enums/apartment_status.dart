import 'package:flutter/material.dart';

enum ApartmentStatus {
  pending,
  accepted,
  rejected,
  blocked,
  canceled,
}

extension ApartmentStatusExtension on ApartmentStatus {
  /// تحويل String من الباك إلى enum (للتوافق مع الكود القديم)
  static ApartmentStatus fromString(String? status) {
    return fromDynamic(status);
  }

  /// اسم جاهز للعرض بالواجهة
  String get displayName {
    switch (this) {
      case ApartmentStatus.pending:
        return 'Pending';
      case ApartmentStatus.accepted:
        return 'Accepted';
      case ApartmentStatus.rejected:
        return 'Rejected';
      case ApartmentStatus.blocked:
        return 'Blocked';
      case ApartmentStatus.canceled:
        return 'Canceled';
    }
  }

  /// لون الحالة
  Color get color {
    switch (this) {
      case ApartmentStatus.pending:
        return Colors.orange;
      case ApartmentStatus.accepted:
        return Colors.green;
      case ApartmentStatus.rejected:
        return Colors.red;
      case ApartmentStatus.blocked:
        return Colors.grey;
      case ApartmentStatus.canceled:
        return Colors.purple;
    }
  }

  /// أيقونة الحالة
  IconData get icon {
    switch (this) {
      case ApartmentStatus.pending:
        return Icons.hourglass_empty;
      case ApartmentStatus.accepted:
        return Icons.check_circle;
      case ApartmentStatus.rejected:
        return Icons.cancel;
      case ApartmentStatus.blocked:
        return Icons.block;
      case ApartmentStatus.canceled:
        return Icons.do_not_disturb_on;
    }
  }

  /// وصف الحالة
  String get description {
    switch (this) {
      case ApartmentStatus.pending:
        return 'Waiting for admin approval';
      case ApartmentStatus.accepted:
        return 'Approved and available for booking';
      case ApartmentStatus.rejected:
        return 'Not approved by admin';
      case ApartmentStatus.blocked:
        return 'Temporarily unavailable';
      case ApartmentStatus.canceled:
        return 'Booking was canceled';
    }
  }

  /// دالة لتحويل من رقم أو نص إلى ApartmentStatus
  static ApartmentStatus fromDynamic(dynamic value) {
    if (value == null) return ApartmentStatus.pending;

    final strValue = value.toString().toLowerCase();

    switch (strValue) {
      case '1':
      case 'pending':
        return ApartmentStatus.pending;
      case '2':
      case 'accepted':
        return ApartmentStatus.accepted;
      case '3':
      case 'rejected':
        return ApartmentStatus.rejected;
      case '4':
      case 'blocked':
        return ApartmentStatus.blocked;
      case '5':
      case 'canceled':
      case 'cancelled':
        return ApartmentStatus.canceled;
      default:
      // إذا كانت القيمة مثل 'ApartmentStatus.accepted'
        if (strValue.contains('.')) {
          final parts = strValue.split('.');
          if (parts.length > 1) {
            return fromDynamic(parts.last);
          }
        }
        return ApartmentStatus.pending;
    }
  }

  /// تحويل Enum إلى الرقم المقابل
  int get numericValue {
    switch (this) {
      case ApartmentStatus.pending:
        return 1;
      case ApartmentStatus.accepted:
        return 2;
      case ApartmentStatus.rejected:
        return 3;
      case ApartmentStatus.blocked:
        return 4;
      case ApartmentStatus.canceled:
        return 5;
    }
  }
}