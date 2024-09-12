import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SiriWaveformWidget extends StatelessWidget {
  const SiriWaveformWidget({
    required this.controller,
    this.showSupportBar = true,
    required this.style,
    super.key,
  });

  final SiriWaveformController controller;
  final bool showSupportBar;
  final SiriWaveformStyle style;

  @override
  Widget build(BuildContext context) {
    return style == SiriWaveformStyle.ios_7
        ? SiriWaveform.ios7(
            controller: controller as IOS7SiriWaveformController,
            options: const IOS7SiriWaveformOptions(
              height: kIsWeb ? 300 : 180,
              width: kIsWeb ? 600 : 360,
            ),
          )
        : SiriWaveform.ios9(
            controller: controller as IOS9SiriWaveformController,
            options: IOS9SiriWaveformOptions(
              height: kIsWeb ? 300 : 180,
              showSupportBar: showSupportBar,
              width: kIsWeb ? 600 : 360,
            ),
          );
  }
}