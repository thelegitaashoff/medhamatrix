class CounselingSession {
  final String id;
  final String counselor;
  final String dateIso;
  final String timeSlot;
  final String agoraChannel;
  final DateTime createdAt;

  const CounselingSession({
    required this.id,
    required this.counselor,
    required this.dateIso,
    required this.timeSlot,
    required this.agoraChannel,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'counselor': counselor,
      'dateIso': dateIso,
      'timeSlot': timeSlot,
      'agoraChannel': agoraChannel,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CounselingSession.fromJson(Map<String, dynamic> json) {
    return CounselingSession(
      id: (json['id'] ?? '').toString(),
      counselor: (json['counselor'] ?? '').toString(),
      dateIso: (json['dateIso'] ?? '').toString(),
      timeSlot: (json['timeSlot'] ?? '').toString(),
      agoraChannel: (json['agoraChannel'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}
