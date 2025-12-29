enum ReservationStatus {
  pending,
  accepted,
  rejected,
  blocked,
  canceled,
  previous,
}

extension ReservationStatusExtension on ReservationStatus {
  /// للتحويل من String جاي من الباك إلى enum
  static ReservationStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return ReservationStatus.pending;
      case 'accepted':
        return ReservationStatus.accepted;
      case 'rejected':
        return ReservationStatus.rejected;
      case 'blocked':
        return ReservationStatus.blocked;
      case 'canceled':
      case 'cancelled':
        return ReservationStatus.canceled;
      default:
        return ReservationStatus.previous;
    }
  }

  /// اسم جاهز للعرض بالواجهة
  String get displayName {
    switch (this) {
      case ReservationStatus.pending:
        return 'pending';
      case ReservationStatus.accepted:
        return 'accepted';
      case ReservationStatus.rejected:
        return 'rejected';
      case ReservationStatus.blocked:
        return 'blocked';
      case ReservationStatus.canceled:
        return 'canceled';
      case ReservationStatus.previous:
        return 'previous';
    }
  }
}
