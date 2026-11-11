# Student Profile

A single-screen Flutter app that presents one student's academic profile with a
glass-style Material 3 interface. Everything runs on the device: there is no
backend, account or network service.

The profile values live in `lib/data/student_profile.dart` and include personal
contact details, so keep this source and any builds private.

## What it does

- Profile hero with a fixed portrait from `assets/profile.png`; replace that
  file to update the photo.
- Academic overview, SSC/HSC and university education, about, skills, projects
  and interests.
- Personal and contact details, including phone, present and permanent
  addresses, and existing email addresses. Phone and email links are actionable.
- Light, Dark and System appearance. The choice is remembered between launches.
- A bottom bar on phones that jumps between sections of the same screen.
- Link to the GitHub profile.

## Requirements

- Flutter 3.47 or later (Dart 3.13)
- Android SDK for device builds

## Run

```sh
flutter pub get
flutter run
```

## Check

```sh
dart format .
flutter analyze
flutter test
```

## Build

```sh
flutter build apk --release
```

## Layout of the code

| Path | Contents |
| --- | --- |
| `lib/data/` | The profile values |
| `lib/l10n/` | Every on-screen label |
| `lib/theme/` | Spacing, breakpoints, glass levels, motion and the theme |
| `lib/screens/` | The profile screen and its state |
| `lib/widgets/` | Reusable pieces: glass surfaces, cards, hero, section bar |
| `test/` | Widget, layout, contrast and interaction tests |

To change how the glass looks, edit `AppStyle.glassLayers` in
`lib/theme/app_theme.dart`. `test/theme_contrast_test.dart` fails if a change
makes text hard to read.
