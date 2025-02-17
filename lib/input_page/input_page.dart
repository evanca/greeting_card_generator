import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greeting_card_generator_sandbox/output_page/output_page.dart';
import 'package:greeting_card_generator_sandbox/ui/theme.dart';

import 'models/form_input.dart';
import 'models/occasion.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  static const _imageOffset = 48.0;
  final _formKey = GlobalKey<FormState>();
  String _recipientName = '';
  int? _age;
  Occasion _occasion = Occasion.birthday;
  double _tone = 0.5;
  String? _additionalNotes;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final formInput = FormInput(
        recipientName: _recipientName,
        age: _age,
        occasion: _occasion,
        tone: _tone,
        additionalNotes: _additionalNotes,
      );
      // TODO: Generate greeting card
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OutputPage(),
        ),
      );
      if (kDebugMode) {
        print(formInput);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: AppTheme.gradientDecoration,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double cardWidth = maxWidth > 600 ? 900 : maxWidth * 0.9;
            bool showImage = maxWidth > 700;

            return Center(
              child: Container(
                width: cardWidth,
                margin: const EdgeInsets.symmetric(vertical: 64),
                padding: const EdgeInsets.all(8),
                decoration: AppTheme.cardDecoration,
                child: Row(
                  children: [
                    if (showImage)
                      Expanded(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin:
                                  const EdgeInsets.only(right: _imageOffset),
                              decoration: AppTheme.heroImageDecoration,
                            ),
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  'assets/robot.png',
                                  width: double.infinity,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.bottomLeft,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: showImage
                                ? const EdgeInsets.fromLTRB(
                                    54, 32, 48 + _imageOffset, 32)
                                : const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  'AI-Powered Greetings',
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No more stress. Just instant, beautiful messages.',
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Recipient Name',
                                    hintText:
                                        'E.g., "Dad", "Dash", "Dr. Smith"',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter recipient name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      _recipientName = value ?? '',
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Age (optional)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) =>
                                      _age = int.tryParse(value ?? ''),
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<Occasion>(
                                  value: _occasion,
                                  decoration: const InputDecoration(
                                    labelText: 'Occasion',
                                  ),
                                  items: Occasion.values.map((occasion) {
                                    return DropdownMenuItem(
                                      value: occasion,
                                      child: Row(
                                        children: [
                                          Icon(occasion.icon, size: 20),
                                          const SizedBox(width: 8),
                                          Text(occasion.label,
                                              style: GoogleFonts.inter(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _occasion = value ?? Occasion.birthday;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                ToneSelector(
                                  tone: _tone,
                                  onChanged: (value) {
                                    setState(() {
                                      _tone = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Additional Notes (optional)',
                                    hintText:
                                        'E.g., "This is my high school friend who\'s really into hockey; she loves a good joke!"',
                                  ),
                                  maxLines: 2,
                                  maxLength: 200,
                                  onSaved: (value) => _additionalNotes = value,
                                  validator: (value) {
                                    if (_occasion == Occasion.other &&
                                        (value == null || value.isEmpty)) {
                                      return 'Please provide additional notes'
                                          ' about the occasion';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Generate',
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.auto_awesome, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ToneSelector extends StatelessWidget {
  const ToneSelector({
    super.key,
    required this.tone,
    required this.onChanged,
  });

  final double tone;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tone:',
          style: GoogleFonts.inter(
            textStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Row(
          children: [
            Text(
              'Casual',
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontStyle: FontStyle.italic,
              ),
            ),
            Expanded(
              child: Slider(
                value: tone,
                onChanged: onChanged,
              ),
            ),
            Text(
              'Formal',
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
