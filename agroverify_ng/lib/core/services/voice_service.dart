import 'package:flutter/semantics.dart';

/// Accessibility / voice-support hook.
///
/// Many target users are low-literacy farmers, so key screens should be
/// speakable, not just readable. This wraps [SemanticsService.announce],
/// which drives the screen reader already built into Android (TalkBack)
/// and iOS (VoiceOver) with no extra native permissions or plugins.
///
/// It is intentionally a thin, swappable seam: a full "read this screen
/// aloud in Hausa/Yoruba/English" experience can later plug a
/// text-to-speech engine (e.g. `flutter_tts`) in behind this same
/// `VoiceService.speak` call without touching any UI code.
class VoiceService {
  const VoiceService();

  /// Speaks [text] aloud via the platform's accessibility announcement
  /// channel. Safe to call even when no screen reader is active.
  void speak(String text, {TextDirection textDirection = TextDirection.ltr}) {
    if (text.trim().isEmpty) return;
    SemanticsService.announce(text, textDirection);
  }
}
