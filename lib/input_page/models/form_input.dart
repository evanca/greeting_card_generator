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
}
