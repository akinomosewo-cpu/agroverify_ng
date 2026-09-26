# AgroVerify NG

Agro-input verification and dealer rating. Scan seeds, fertiliser and pesticide codes before buying.

## Features
- **Scan & verify**: scan (or type) a seed/fertilizer/pesticide code and get a genuine / suspected-counterfeit / unknown result, with a voice announcement of the outcome.
- **Report a bad batch**: capture the batch code, a description, an optional photo (camera), and an optional GPS fix, then submit.
- **Dealer directory**: trusted-vs-untrustworthy dealer list driven by rating + report count (the same signal that would back a counterfeit heat map for brands/donor programs).
- **Languages**: English, Hausa and Yoruba, switchable from the home screen at any time.
- **Accessibility**: key results are announced via the platform screen reader (TalkBack/VoiceOver) as a voice-support hook.

## Setup
```bash
flutter pub get
flutter run
```

## Testing
```bash
flutter analyze
flutter test
```

## Architecture
Clean Architecture + BLoC state management. Dark theme, advanced UI, Android & iOS.

## App 9 of 11 — Abuja Infrastructure Series
