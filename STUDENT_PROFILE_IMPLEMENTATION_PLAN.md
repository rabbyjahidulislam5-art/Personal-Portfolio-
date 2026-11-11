# Student Profile — Flutter Frontend Implementation Plan

পরিকল্পনার তারিখ: 11 November 2026  
মূল specification: `FINAL_STUDENT_PROFILE_PROMPT.md`  
Project location: `C:\Users\Victus\Desktop\New folder (2)`  
বর্তমান অবস্থা: Flutter Android project এবং profile widgets তৈরি হয়েছে। নিচের original plan-এর পরে অনুমোদিত refinement ও verification progress দেওয়া আছে; command-এর ফল ছাড়া build/test সফল ধরা হবে না।

## 1. কী তৈরি হবে

Jahidul Islam-এর জন্য Flutter, Dart ও Material 3 দিয়ে একটি সম্পূর্ণ runnable Android Student Profile app তৈরি হবে। এটি একটি single-screen frontend; appearance menu, privacy control, photo picker এবং collapsible details একই profile route-এর অংশ।

- মূল prompt-এর প্রতিটি section, তথ্য ও প্রয়োজনীয় interaction থাকবে।
- UI composition, profile data, theme ও reusable widgets আলাদা থাকবে। একটি বড় ফাইলে পুরো app লেখা হবে না।
- Flutter SDK-এর widget এবং ছোট dependency set ব্যবহার হবে। অপ্রয়োজনীয় architecture বা package যোগ হবে না।
- কাজ, source, documentation ও project output এই workspace-এর মধ্যে রাখা হবে। অন্য project/folder-এর ফাইল পড়া বা বদলানো হবে না।
- Flutter/Dart বা emulator নতুন করে install করা হবে না। প্রথমে বিদ্যমান tooling-এর অবস্থাই যাচাই করা হবে।
- এই প্রথম ধাপে শুধু plan তৈরি হবে। পরবর্তী implementation এই ধাপক্রম অনুসরণ করবে।

## 2. Scope ও সীমা

**থাকবে:** Android project scaffold, `pubspec.yaml`, dependency lockfile, local profile data, responsive UI, light/dark/system theme, gallery photo selection, privacy reveal/hide, GitHub browser launch, accessibility, tests এবং run documentation।

**থাকবে না:** backend, API, database, Firebase, login, account sync, analytics, upload, payment processing, deployment বা publishing। Payment System কেবল academic project-এর বিবরণ।

Sidebar, drawer, bottom navigation, navigation rail ও dashboard header থাকবে না। Root screen-এ অকার্যকর back button থাকবে না। নতুন award, certification, repository link, proficiency percentage বা অনুপস্থিত তথ্য বানানো হবে না।

Profile photo, theme, privacy ও expansion state শুধু চলতি session-এ থাকবে। App বন্ধ করে পুনরায় চালালে defaults ফিরে আসবে; persistence এই scope-এর অংশ নয়।

## 3. Screen blueprint ও পড়ার ক্রম

| ক্রম | Section | Content ও আচরণ |
| --- | --- | --- |
| 1 | AppBar | `Student Profile` title; tooltip-সহ Appearance ও Privacy action। |
| 2 | Profile hero | Circular avatar; প্রথমে `JI`; Change photo control; নাম, university, department, full degree এবং privacy অনুযায়ী student ID। |
| 3 | Academic Overview | `11th Semester` ও `Final Year` একসঙ্গে; CGPA `3.52`, completed credits `104`, expected graduation `2027` responsive stat tiles-এ। |
| 4 | About Me | Prompt-এর সম্পূর্ণ introduction, readable paragraph। |
| 5 | Education Details | Batch/intake `Summer 2023` এবং admission date `28 May 2023`; অপ্রয়োজনীয় academic duplication নয়। |
| 6 | Technical Skills | চারটি labeled technology group; আলাদা Development Areas; wrapping, non-interactive chips। |
| 7 | Projects | দুটি academic project card; title, type, category, relevant icon এবং সম্পূর্ণ supplied description। |
| 8 | Soft Skills ও Career Goal | পাঁচটি soft-skill tag এবং সম্পূর্ণ career paragraph; skills local data থেকে সহজে edit করা যাবে। |
| 9 | Interests ও Hobbies | পৃথক Technical Interests ও Hobbies group। |
| 10 | Personal ও Contact Information | দুটি স্পষ্ট labeled collapsible section; sensitive values privacy অনুযায়ী। |
| 11 | GitHub | Compact link card; action label `Open GitHub profile`; শুধু supplied HTTPS URL। |

Projects-এর দুই description প্রথম implementation-এ সম্পূর্ণ দেখানো হবে। কৃত্রিমভাবে লেখা কেটে “Read more” যোগ করার প্রয়োজন নেই। Personal ও Contact section প্রথমে collapsed থাকবে। Privacy action scroll করার পরও AppBar-এ পাওয়া যাবে।

## 4. Visual design

Calm blue Material 3 palette, ছোট cyan/indigo accent, compact hero এবং পরিষ্কার reading hierarchy ব্যবহার হবে। Profile data-ই screen-এর প্রধান বিষয় থাকবে।

| Token | প্রাথমিক design decision |
| --- | --- |
| Primary seed | Blue `#245AC7`; চূড়ান্ত foreground/surface pairing contrast যাচাই করে ঠিক করা হবে। |
| Light background | Soft cool gradient: `#F5F8FF` থেকে `#EAF1FB`। |
| Dark background | Deep slate-blue gradient: `#0C1424` থেকে `#15243A`। |
| Surfaces | Text-heavy section-এ প্রায় opaque tonal card; hero ও সীমিত key surface-এ restrained glass treatment। |
| Spacing | 4, 8, 12, 16, 24, 32 logical px-এর ছোট scale। |
| Page gutters | Compact width-এ 16 px; বেশি জায়গায় 24–32 px। |
| Radius | Chips 12 px, সাধারণ card 20 px, hero 24 px; সব জায়গায় consistent। |
| Typography | System sans-serif; নাম ও heading prominent; body আরামদায়ক; system text scaling অক্ষুণ্ণ। |
| Avatar | আনুমানিক 88–104 px, circular cover fit; অস্বাভাবিক বড় hero নয়। |
| Motion | Useful state change-এ প্রায় 150–220 ms; reduced-motion setting-এ motion বন্ধ বা কমানো। |
| Touch target | সব interactive control অন্তত 48 × 48 logical px। |

Actual blur প্রয়োজন হলে শুধু clipped hero surface-এ রাখা হবে। Repeated rows-এ blur নয়। Thin border, modest shadow এবং opaque fallback দিয়ে dark/light দুই theme-এ readability বজায় থাকবে। কোনো external font download, fabricated university logo বা remote decorative image লাগবে না।

## 5. Responsive layout

- **600 px-এর নিচে:** এক column; centered hero; stats ও chips wrap করবে; দীর্ঘ contact value প্রয়োজনে label-এর নিচে যাবে।
- **600–1023 px:** centered content; hero horizontal হবে কেবল full department ও degree আরাম করে ধরলে। সম্পর্কিত ছোট section পাশাপাশি বসবে কেবল যথেষ্ট usable width থাকলে।
- **1024 px বা বেশি:** সর্বোচ্চ প্রায় 1040 px content width; সর্বোচ্চ দুই column; বড় sidebar বা নতুন navigation নয়।
- Education ও About, Soft Skills ও Career Goal, Personal ও Contact-এর মতো সম্পর্কিত section pairing বিবেচনা করা যাবে। চূড়ান্ত pairing source-এর section order এবং accessibility reading order বজায় রাখবে।
- Text scaling বেশি হলে বা usable pane ছোট হলে দুই column থেকে এক column-এ ফেরত যাবে।
- একটি primary vertical scroll থাকবে; fixed card height বা nested profile scroll থাকবে না।
- Safe insets এবং `MediaQuery.displayFeatures` দিয়ে obstructing hinge/usable pane বিবেচনা করা হবে। শুধু device নাম ধরে breakpoint নয়।
- Portrait, landscape, split-screen, short windows ও keyboard/system UI-এর কারণে height কমে গেলেও controls scroll করে পাওয়া যাবে।
- Direction-aware padding/alignment, wrapping text ও flexible rows থাকবে। Horizontal scrolling দিয়ে profile text পড়তে হবে না।

## 6. Reusable component map

প্রতিটি semantic section-এর দায়িত্ব ছোট ও স্পষ্ট থাকবে। প্রত্যেক `Padding` বা `Text`-এর জন্য আলাদা file নয়; পুনর্ব্যবহারযোগ্য বা বড় section-ই component হবে।

| Component | দায়িত্ব |
| --- | --- |
| `StudentProfileApp` | `MaterialApp`, full-app theme mode এবং theme selection callback। |
| `StudentProfileScreen` | `StatefulWidget`; page composition, photo, privacy, disclosure state ও async interaction। |
| `ProfileHero` | Avatar, Change photo, identity এবং privacy-safe student ID। |
| `AcademicOverview` | Semester/year এবং reusable statistic tiles। |
| `GlassCard` | সীমিত glass surface; clip, tint, border ও optional blur। |
| `SectionCard` | Text-heavy section-এর shared heading, spacing ও tonal surface। |
| `InfoRow` | Label/value layout; long text wrapping এবং hidden-value rendering। |
| `SkillGroup` | Heading এবং display-only wrapping chips; soft skills/interests-এও উপযোগী। |
| `ProjectCard` | Project title/type/category/icon ও সম্পূর্ণ description। |
| `ProfileDetails` | Personal/Contact-এর দুটি disclosure; state parent screen থেকে পাবে। |
| `GitHubLinkCard` | Exact supplied link-এর accessible action ও focus state। |

Mandatory assignment widgets running UI-তে বাস্তবে ব্যবহৃত হবে: `StatefulWidget`, `AppBar`, `CircleAvatar`, `Column`, `Padding`, `Text`। পাশাপাশি `Scaffold`, `SafeArea`, `LayoutBuilder`, `ConstrainedBox`, `MediaQuery`, `Wrap`, `Flexible`, `ExpansionTile`, `IconButton`, `Tooltip`, `Semantics` ও `SnackBar` প্রয়োজন অনুযায়ী থাকবে।

## 7. প্রস্তাবিত project structure

এই workspace-ই Flutter project root হবে; আরেকটি অপ্রয়োজনীয় nested project folder নয়। Generated scaffold অনুযায়ী Android file extension/নাম সামান্য বদলাতে পারে।

```text
New folder (2)/
  FINAL_STUDENT_PROFILE_PROMPT.md
  STUDENT_PROFILE_IMPLEMENTATION_PLAN.md
  README.md
  pubspec.yaml
  pubspec.lock
  analysis_options.yaml
  .gitignore
  .metadata
  android/
    app/
      src/main/AndroidManifest.xml
      src/main/.../MainActivity.kt
      build.gradle.kts
    gradle/wrapper/
    settings.gradle.kts
    build.gradle.kts
    gradle.properties
    gradlew
    gradlew.bat
  lib/
    main.dart
    app.dart
    data/
      student_profile.dart
    theme/
      app_theme.dart
    l10n/
      app_labels.dart
    screens/
      student_profile_screen.dart
    widgets/
      profile_hero.dart
      academic_overview.dart
      glass_card.dart
      section_card.dart
      info_row.dart
      skill_group.dart
      project_card.dart
      profile_details.dart
      github_link_card.dart
  test/
    student_profile_test.dart
    profile_interactions_test.dart
    responsive_layout_test.dart
```

`student_profile.dart`-এ exact supplied values এক জায়গায় থাকবে। ছোট typed data structure প্রয়োজন হলে একই file-এ থাকবে; repository/service/state-management layer যোগ হবে না। `app_labels.dart` UI labels centralize করবে; language switch বা পূর্ণ localization infrastructure এখন প্রয়োজন নেই।

Default avatar-এর জন্য initials যথেষ্ট। User photo না থাকায় placeholder photo asset বানানো হবে না। তাই প্রয়োজন ছাড়া খালি `assets/` directory বা YAML asset declaration যোগ হবে না।

## 8. Dependencies ও platform setup

| Dependency/config | ব্যবহার |
| --- | --- |
| Flutter SDK / Dart | App, Material 3, responsive layout, semantics এবং in-memory state। |
| `image_picker` | Local gallery থেকে image selection। |
| `url_launcher` | Supplied GitHub URL platform browser-এ খোলা। |
| `flutter_test` | Widget, state, accessibility semantics এবং responsive checks। |
| `flutter_lints` | Scaffold-compatible static analysis rules। |
| `pubspec.yaml` | SDK constraint, app metadata, dependencies, `uses-material-design: true`। |
| `pubspec.lock` | Application-এর resolved dependency versions lock করা। |
| Android scaffold | Manifest, Gradle wrapper/config, launcher resources এবং Kotlin entry point। |

Package version এখন অনুমান করে লেখা হবে না। Implementation-এর সময় installed Flutter/Dart-এর সঙ্গে compatible stable release, package-এর official setup instructions এবং Android requirements যাচাই করে constraint ও lockfile তৈরি হবে। `image_picker` বা `url_launcher`-এর transitive packages আলাদা direct dependency করা হবে না, যদি app সেগুলো import না করে।

Provider, Riverpod, Bloc, GoRouter, Firebase, HTTP client, cached-network-image, remote fonts বা persistence package প্রয়োজন নেই। Built-in `StatefulWidget`, callbacks ও Flutter theme যথেষ্ট।

Android gallery picker-এর chosen version যে configuration চায় শুধু সেটিই দেওয়া হবে। Broad storage permission বা camera permission প্রয়োজন ছাড়া যোগ হবে না। Android minimum/compile SDK ও launcher requirements resolved plugins অনুযায়ী যাচাই হবে। Package visibility configuration প্রয়োজন হলে narrowly scoped হবে।

Android হবে প্রথম runnable target। iOS-style responsiveness Flutter UI-তে বিবেচিত থাকবে, কিন্তু Windows environment থেকে iOS build/test হয়েছে বলা হবে না; আলাদা iOS scaffold এই Android task-এর প্রয়োজন নয়।

**Tooling boundary:** Project commands এই folder থেকেই চালানোর পরিকল্পনা। Installed SDK/JDK/Android SDK এবং package/build tooling স্বাভাবিকভাবে external cache ব্যবহার করতে পারে। “বাইরে কোনো folder-এ কাজ নয়” সীমা অক্ষুণ্ণ রাখতে command চালানোর আগে এর প্রয়োজন বোঝা হবে; workspace-এর বাইরে installation, SDK repair বা cache mutation অনুমান করে করা হবে না। প্রয়োজনীয় tool/dependency unavailable হলে তা নির্দিষ্ট limitation হিসেবে জানানো হবে।

## 9. Local interaction ও failure handling

### Photo

1. `Change photo` চাপলে gallery picker খুলবে; camera/upload flow নয়।
2. Successful selection-এর bytes memory-তে থাকবে; avatar-এর উপযোগী bounded decode size ব্যবহার হবে।
3. নতুন image decode করা যায় কি না যাচাই করে তারপর বর্তমান avatar replace হবে।
4. Cancel করলে বর্তমান photo অপরিবর্তিত থাকবে।
5. Permission, file read বা image decoding failure-এ বর্তমান photo থাকবে; concise `SnackBar` এবং Retry থাকবে।
6. Async operation-এর পরে `mounted` check হবে; overlapping picker launch ঠেকাতে pending state থাকবে।
7. Theme change বা screen resize-এ selected photo হারাবে না। Photo bytes persist বা log করা হবে না।

### Appearance

- Initial mode `System`; menu/sheet-এ `System`, `Light`, `Dark` স্পষ্টভাবে থাকবে।
- Theme state `MaterialApp`-এর উপযুক্ত parent-এ থাকবে।
- Theme change-এ screen identity/key পাল্টে photo, privacy বা disclosure reset করা হবে না।

### Privacy

- Initial state sensitive data hidden।
- এক control দিয়ে student ID, birth date, blood group, দুই email, phone ও street address একসঙ্গে show/hide হবে।
- Hidden অবস্থায় actual sensitive value widget text, tooltip, semantics বা clipboard action-এ পাঠানো হবে না; `Hidden` বা omitted value থাকবে।
- Personal section-এ gender/nationality এবং Contact section-এ city/country দৃশ্যমান থাকতে পারে। Full name hero-তে একবার থাকবে।
- এটি display privacy; bundled source/build থেকে data সরায় না। Source/build private রাখতে হবে।
- Screenshot বা visual export দরকার হলে safe redacted test fixture ব্যবহার হবে; বাস্তব personal data demo export বা diagnostic log-এ নয়।

### Details ও GitHub

- Disclosure open/closed state theme/resize জুড়ে অক্ষুণ্ণ থাকবে; label ও expanded state screen reader-এ বোঝা যাবে।
- শুধু `https://github.com/rabbyjahidulislam5-art` খোলা হবে; arbitrary URL input থাকবে না।
- Browser launch false return বা exception হলে feedback দেখাবে; crash নয়।

## 10. Source data integrity

Prompt-ই authoritative source। Implementation-এ সব তথ্য অক্ষরে অক্ষরে মিলিয়ে নিতে হবে, বিশেষ করে:

- Identity-এর পাঁচটি value; hero-এর full name একবার।
- University, student ID, full department, full degree, semester, intake, year, admission date, graduation year, CGPA ও credits।
- দুই email, phone, city, country ও address।
- About Me ও Career Goal-এর সম্পূর্ণ paragraph।
- চার technology group-এর সব tools এবং Development Areas-এর পাঁচটি item।
- `Caregiver & Care Provider Web Application` এবং `East West University Centralized Payment System`-এর exact title/type/category/description।
- পাঁচটি soft skill, দুই technical interest, দুই hobby ও exact GitHub URL।

CGPA-এর পাশে `/4.00`, credit progress bar, remaining credits, rank বা verified/graduated badge যোগ হবে না; এসব তথ্য দেওয়া হয়নি। Date বা academic year বর্তমান তারিখ ধরে নতুন করে হিসাব করা হবে না।

## 11. কাজের ধাপ ও প্রতিটি ধাপের ফল

| ধাপ | কাজ | Completion condition |
| --- | --- | --- |
| 1 — Plan | Specification review, screen/component/dependency/test plan | এই document; এই পর্যায়ে app code নয়। |
| 2 — Scaffold | বিদ্যমান tool availability যাচাই; root-এ Android Flutter project তৈরি; original documents সংরক্ষণ | Runnable project skeleton, manifest/Gradle/YAML; emulator install নয়। |
| 3 — Data ও theme | Exact local profile data, centralized labels ও visual tokens | Content এক জায়গায়; Material 3 light/dark themes। |
| 4 — UI | Reusable cards/widgets এবং ordered profile screen | সব required section/widget; compact layout সম্পূর্ণ। |
| 5 — Interaction | Photo, appearance, privacy, disclosure ও GitHub | Success/cancel/failure path; async guards; session state preserved। |
| 6 — Adaptation | Wide layout, text scaling, safe insets, focus/semantics, motion | Narrow/wide/landscape/200% scaling-এ usable UI। |
| 7 — Verification | Format, analyze, tests, available Android build/UI checks | পাওয়া failure ঠিক করা; actual result ও untested limits লিখে রাখা। |
| 8 — Handoff | README, run commands, dependency/config summary | Complete source এবং কী verified/কী pending তার পরিষ্কার তথ্য। |

পরিবর্তনের reach: নতুন entry point, app theme owner, screen, data, widgets, labels, Android setup, dependency files, tests এবং README। Existing app/caller/fixture নেই; implementation-এর সময় কোনো file আগে থেকে তৈরি হয়ে থাকলে overwrite করার আগে তা আবার পরীক্ষা করতে হবে।

## 12. Verification plan

### Automated checks

- `dart format lib test`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug` — installed Android toolchain/dependencies দিয়ে সম্ভব হলে, emulator ছাড়াই।

এগুলো পরিকল্পিত command, এখনো চালানো হয়নি। `flutter create --platforms=android --project-name student_profile .` দিয়ে scaffold করা যেতে পারে, tool/cache boundary যাচাই এবং current documents অক্ষুণ্ণ রাখার শর্তে।

### Meaningful tests

1. **Content:** দুই project-এর সম্পূর্ণ supplied content, academic values এবং section order মেলে।
2. **Privacy:** default hidden; reveal/re-hide সব sensitive field-এ কাজ করে; hidden values semantics-এ নেই।
3. **State:** theme change ও resize-এর পর photo, privacy এবং disclosure state থাকে।
4. **Photo:** successful selection, cancel, read/decode failure ও picker exception; failure-এ existing image থাকে। Platform boundary-তে mock/fake প্রয়োজন হলে শুধু ছোট test seam ব্যবহার হবে।
5. **Link:** exact supplied URL launcher-এ যায়; failure feedback দৃশ্যমান।
6. **Layout:** full screen scroll করে sections build/inspect করা হবে; overflow ও framework exceptions পরীক্ষা হবে।
7. **Accessibility:** actions/disclosures-এর labels/states, 48 px targets, focus order ও supported Flutter accessibility guidelines পরীক্ষা হবে।

### Size matrix

প্রতিটি size light/dark এবং normal/200% text scaling-এ test করা হবে; system theme mapping-ও আলাদাভাবে যাচাই হবে।

| Scenario | Logical size |
| --- | --- |
| Compact portrait | 320 × 568 |
| Phone portrait | 390 × 844 |
| Short landscape | 568 × 320 |
| Phone landscape | 844 × 390 |
| Tablet portrait | 768 × 1024 |
| Tablet landscape | 1024 × 768 |
| Expanded window | 1440 × 900 |
| Split-screen | 360 × 720 usable pane |

Long degree, email, Bengali/RTL test label, wrapped chips এবং safe inset/display-feature cases অন্তর্ভুক্ত হবে। Visual ও screen-reader order একই থাকবে। Full content পড়তে horizontal scroll লাগবে না।

Native gallery permissions, system photo picker, actual browser launch, TalkBack এবং বাস্তব rotation/foldable behavior-এর পুরো নিশ্চয়তা widget test দেয় না। আগে থেকে available physical device থাকলে সেখানে পরীক্ষা হবে; না থাকলে এগুলো pending হিসেবে লেখা হবে। কোনো emulator install হবে না।

## 13. Final acceptance checklist

- [ ] Android Flutter source এই workspace-এ আছে এবং original prompt অক্ষত।
- [ ] YAML, lockfile, Gradle/manifest এবং required dependencies সম্পূর্ণ।
- [ ] এক profile route; সব 11 section সঠিক reading order-এ আছে।
- [ ] Exact profile content, দুই project ও সব skill/interests উপস্থিত।
- [ ] ছয় mandatory assignment widget running UI-তে ব্যবহৃত।
- [ ] Reusable components আছে; data/theme/UI আলাদা ও সরল।
- [ ] Photo success/cancel/failure এবং retry সঠিক।
- [ ] System/light/dark appearance কাজ করে; state অক্ষুণ্ণ।
- [ ] Sensitive fields default hidden; semantics-এও hidden।
- [ ] Personal/Contact disclosure এবং GitHub action functional।
- [ ] Responsive matrix, 200% text ও accessibility checks সম্পন্ন বা সীমা নথিভুক্ত।
- [ ] Actual format/analyze/test/build results README-তে আছে।
- [ ] কোনো backend, invented content, deployment বা emulator installation নেই।

এই পরিকল্পনায় dependency versions, SDK availability, build success ও device behavior এখনো যাচাই করা হয়নি। Implementation-এর সময় যাচাইয়ের ফল ছাড়া এগুলো সম্পন্ন বলা হবে না।
