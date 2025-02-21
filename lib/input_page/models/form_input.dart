import 'occasion.dart';

class FormInput {
  final String recipientName;
  final int? age;
  final Occasion occasion;
  final double tone;
  final String? additionalNotes;

  const FormInput({
    required this.recipientName,
    this.age,
    required this.occasion,
    required this.tone,
    this.additionalNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientName': recipientName,
      'age': age,
      'occasion': occasion.label,
      'tone': tone,
      'additionalNotes': additionalNotes,
    };
  }
}
