enum ApartmentStatus {
  pending,
  accepted,
  rejected,
  blocked,
  canceled,
}

extension ApartmentStatusExtension on ApartmentStatus {
  /// تحويل String من الباك إلى enum
  static ApartmentStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return ApartmentStatus.pending;
      case 'accepted':
        return ApartmentStatus.accepted;
      case 'rejected':
        return ApartmentStatus.rejected;
      case 'blocked':
        return ApartmentStatus.blocked;
      case 'canceled':
      case 'cancelled':
        return ApartmentStatus.canceled;
      default:
        return ApartmentStatus.pending;
    }
  }

  /// اسم جاهز للعرض بالواجهة
  String get displayName {
    switch (this) {
      case ApartmentStatus.pending:
        return 'pending';
      case ApartmentStatus.accepted:
        return 'accepted';
      case ApartmentStatus.rejected:
        return 'rejected';
      case ApartmentStatus.blocked:
        return 'blocked';
      case ApartmentStatus.canceled:
        return 'canceled';
    }
  }
}
