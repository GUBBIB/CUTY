class UserModel {
  final String name;
  final String visaType;
  final int points;
  final String visaExpiry;
  final String university; // Added University Name field
  final String workPermitDate;
  final bool isWorkPermitApproved;

  const UserModel({
    required this.name,
    required this.visaType,
    required this.points,
    required this.visaExpiry,
    required this.university,
    this.workPermitDate = '',
    this.isWorkPermitApproved = false,
  });

  // Factory for dummy data
  factory UserModel.dummy() {
    return const UserModel(
      name: 'User Name',
      visaType: '비자 정보 없음',
      points: 0, // 0 will be treated as unbound in UI or text changed
      visaExpiry: '-',
      university: 'University Name',
      workPermitDate: '- ~ -',
      isWorkPermitApproved: false, // Changed to false to trigger "Clock" or similar logic if we use it, or just for consistency
    );
  }
}
