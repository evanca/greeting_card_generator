import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greeting_card_generator_sandbox/greeting/greeting_controller.dart';
import 'package:greeting_card_generator_sandbox/ui/palette.dart';
import 'package:greeting_card_generator_sandbox/ui/theme.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:screenshot/screenshot.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final _screenshotController = ScreenshotController();
  late bool _isTakingScreenshot;

  @override
  void initState() {
    _isTakingScreenshot = false;
    super.initState();
  }

  void _toggleIsTakingScreenshot() {
    setState(() {
      _isTakingScreenshot = !_isTakingScreenshot;
    });
  }

  Future<void> _handleScreenshot() async {
    _toggleIsTakingScreenshot();
    Uint8List? screenshot = await _screenshotController.capture();

    if (screenshot != null) {
      await WebImageDownloader.downloadImageFromUInt8List(
        uInt8List: screenshot,
        name: 'greeting_card.png',
      );
    }
    _toggleIsTakingScreenshot();
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
            bool isMobile = maxWidth <= 600;
            double cardWidth = isMobile ? maxWidth * 0.9 : 900;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(vertical: 32),
                      padding: const EdgeInsets.all(8),
                      decoration: AppTheme.cardDecoration,
                      child: GreetingCard(isMobile: isMobile),
                    ),
                  ),
                ),
                ButtonsSection(
                  isMobile: isMobile,
                  onSave: _handleScreenshot,
                  onStartOver: () {
                    GreetingController.instance.setGreetingText('');
                    GreetingController.instance.setGreetingImage(null);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({
    super.key,
    required this.onSave,
    required this.onStartOver,
    required this.isMobile,
  });

  final VoidCallback onSave;
  final VoidCallback onStartOver;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: isMobile ? 3 : 1,
          child: Column(
            children: [
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onSave,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_downward),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onStartOver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.secondaryButton,
                  textStyle: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    color: Palette.primaryButton,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Start Over'),
                    SizedBox(width: 8),
                    Icon(Icons.refresh),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}

class GreetingCard extends StatelessWidget {
  const GreetingCard({
    super.key,
    required this.isMobile,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: GreetingController.instance,
        builder: (context, _) {
          if (GreetingController.instance.isLoading) {
            return const Center(
              child: SizedBox(
                  height: 80, width: 80, child: CircularProgressIndicator()),
            );
          }

          else if (GreetingController.instance.error != null) {
            return Center(
              child: Text(
                GreetingController.instance.error!,
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          if (isMobile) {
            return Container(
              height: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      Image.memory(GreetingController.instance.greetingImage!)
                          .image,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Spacer(),
                  GreetingText(darkMode: true),
                  Spacer(),
                ],
              ),
            );
          }

          return Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      GreetingController.instance.greetingImage!,
                      height: double.infinity,
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              const Expanded(child: GreetingText()),
            ],
          );
        });
  }
}

class GreetingText extends StatelessWidget {
  const GreetingText({super.key, this.darkMode = false});

  /// Used when text is displayed above the card image.
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GreetingController.instance,
      builder: (context, _) {
        return ColoredBox(
          color: darkMode ? Palette.cardOverlay : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
            child: Text(
              GreetingController.instance.greetingText!,
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headlineMedium,
                fontWeight: FontWeight.w600,
                color: darkMode ? Colors.white : Palette.labelText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
