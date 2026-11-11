# Final Master Prompt — Jahidul Islam’s Flutter Student Profile

## 1. Task and scope

Build a complete, runnable, single-screen **Student Profile** app for **Jahidul Islam** using Flutter, Dart, and Material 3. Make it feel like a polished Android/iOS app with restrained glassmorphism, clear information hierarchy, and responsive behavior. Deliver the implementation after a brief screen and component plan. Treat the supplied profile data in this prompt as authoritative.

Implement the frontend with in-memory state and bundled local data. The project scope excludes backend services, APIs, databases, Firebase, authentication, cloud storage, account sync, analytics, uploads, and payment processing. The payment system below is a profile project description. Do not publish or deploy the app as part of this task. Keep personal data local and out of diagnostic logs, public screenshots, and demo exports.

Build a single profile route. On every screen size, omit sidebars, drawers, navigation rails, permanent navigation panels, bottom navigation, and dashboard-style headers. Use a back affordance only when the route actually has a previous screen. If working in an existing Flutter project, preserve its conventions and unrelated behavior.

## 2. Screen layout and reading order

Use the following top-to-bottom order on phones. At wider sizes, pair only naturally related sections and keep visual, keyboard, and screen-reader reading order consistent.

1. **AppBar** — “Student Profile”, with accessible **Appearance** and **Privacy** actions. Use tooltips and short, clear labels in the controls they open.
2. **Profile hero** — Circular photo with a **Change photo** control, full name, university, department, degree, and student ID. Show the ID subject to the privacy setting. Center the hero on narrow screens. Use a side-by-side photo and text layout only if the available width comfortably fits the full degree and department names.
3. **Academic Overview** — Make **11th Semester**, **Final Year**, **CGPA 3.52**, **104 completed credits**, and **Expected graduation 2027** easy to scan. Present semester and academic year together, with the other values in a responsive group of small statistic tiles. Keep the credit count as a plain number because the total required credits were not supplied.
4. **About Me** — Show the supplied introduction as a readable paragraph.
5. **Education Details** — Show batch/intake and admission date. The hero and Academic Overview already show the rest of the academic information, so keep those values there.
6. **Technical Skills** — Label the four technology groups and show the tools as wrapping chips. Put broader development areas in a separate **Development Areas** group. Use ordinary display chips with no button affordance.
7. **Projects** — Present the two academic projects as readable cards with a title, project type, category, short supplied description, and a relevant icon. Allow expansion only where it improves scanning and provides meaningful additional content. Both descriptions must remain fully accessible.
8. **Soft Skills and Career Goal** — Give each a clear heading. Show the five proposed soft skills as concise tags and the supplied Career Goal as a paragraph. Keep the proposed skills editable in the local profile data.
9. **Interests and Hobbies** — Use separate **Technical Interests** and **Hobbies** groups so the labels are unambiguous.
10. **Personal Information and Contact Information** — Use two clearly labeled, collapsible sections. Keep the privacy action visible from the AppBar. Display the full name once in the hero, and use Personal Information for date of birth, gender, nationality, and blood group. Contact Information contains both emails, phone, city, country, and address, subject to privacy rules.
11. **GitHub** — Place one compact, accessible link card near the end. Make “Open GitHub profile” the action label and open only the supplied URL.

Keep section headings informative. Omit unsupported awards, achievements, certifications, work experience, extra projects, unverified status badges, fabricated repository links, invented social profiles, charts based on unavailable data, and empty placeholders for those sections.

## 3. Exact local profile content

Use the following values and keep them in one maintainable local data source. Preserve the spelling and meaning of the supplied information.

### Identity and personal information

- Full name: Jahidul Islam
- Date of birth: 14 December 2000
- Gender: Male
- Nationality: Bangladeshi
- Blood group: A+

### Education

- University: East West University
- Student ID: 2023-2-60-053
- Department: Computer Science and Engineering (CSE)
- Degree: Bachelor of Science in Computer Science and Engineering (B.Sc. in CSE)
- Current semester: 11th Semester
- Batch / Intake: Summer 2023
- Academic year: Final Year
- Admission date: 28 May 2023
- Expected graduation year: 2027
- Current CGPA: 3.52
- Completed credits: 104

Use the supplied academic values directly. Do not infer a grading scale, total or remaining credits, rankings, enrollment verification, or graduation status.

### Contact

- Personal email: rabbyjahidulislam5@gmail.com
- University email: 2023-2-60-053@std.ewubd.edu
- Phone number: 01787037483
- City: Dhaka
- Country: Bangladesh
- Address: Khan property, house no 391, ghulbagh

### About Me

I am a final-year Computer Science and Engineering student at East West University with a strong interest in software development, web technologies, and mobile application development. I enjoy learning new technologies and building practical software projects.

### Technical skills

- Programming Languages — Java, C++, JavaScript, TypeScript
- Web Technologies — HTML, CSS
- Frameworks and Runtime Technologies — Flutter, Node.js, Express.js
- Development Tools and Platforms — GitHub
- Development Areas — Web Development, Frontend Development, Flutter Mobile UI Development, JavaScript and TypeScript Development, Node.js and Express.js Development

Present these as skills and development areas. Omit proficiency percentages, ratings, certifications, and years of experience.

### Projects

**Caregiver & Care Provider Web Application**

- Type — Web Application
- Category — Academic Project
- Description — A web application project developed around caregiver and care-provider services, bringing caregiver and service-provider related information and interactions into a unified web-based platform.

**East West University Centralized Payment System**

- Type — University Payment Management Web Application
- Category — Academic Project
- Description — A centralized university payment management system designed to bring multiple student and university-related payments into one unified platform. The project focuses on organizing payments such as tuition fees, library fines, and other university fees and charges in one convenient system, reducing the need to manage different payment categories separately.

Describe each project as academic work. Omit unprovided technologies, features, metrics, demos, screenshots, repository URLs, launch status, and institutional adoption claims.

### Soft skills

Problem Solving, Teamwork and Collaboration, Communication, Adaptability, Time Management.

### Career Goal

My goal is to build a successful career in the software industry as a Software Developer, continuously improve my technical skills, and contribute to developing useful, reliable, and innovative software solutions.

### Technical interests and hobbies

- Technical Interests — Artificial Intelligence, App Development
- Hobbies — Traveling, Exploring Social Media Apps

### GitHub

https://github.com/rabbyjahidulislam5-art

## 4. Required Flutter widgets and component behavior

The main screen must genuinely use every assignment widget:

| Required widget | Role on the screen |
| --- | --- |
| `StatefulWidget` | Own the main profile screen and its local photo, privacy, and expansion interactions. Keep theme state at the level needed to update `MaterialApp`. |
| `AppBar` | Provide the title and functional Appearance and Privacy controls. |
| `CircleAvatar` | Render the selected photo or the initials “JI” with a clear accessible label. |
| `Column` | Arrange the hero text and vertically grouped profile information. |
| `Padding` | Apply consistent, responsive spacing to content and reusable cards. |
| `Text` | Render the name, ID when visible, department, university, and other profile values. |

Add the following widgets where they directly support the screen:

- `Scaffold` and `SafeArea` for app structure and system insets. Use one primary vertical scroll with `CustomScrollView` and slivers, or `SingleChildScrollView` with a simple column. Avoid nested vertical scrolls for the profile itself.
- `LayoutBuilder`, `ConstrainedBox`, and `MediaQuery` for available width, readable maximum width, text scaling, and display features. Use `Wrap` for skill chips and responsive statistic groups, plus `Flexible` for long values beside icons.
- `ExpansionTile` or an equivalent accessible disclosure for optional details. Maintain expansion state through theme changes and window resizing.
- `IconButton`, `Tooltip`, and `Semantics` for labeled actions. Use `SnackBar` or equivalent feedback for a recoverable failure. Keep icon-only controls accessible.
- Reuse compact components such as `ProfileHero`, `AcademicOverview`, `GlassCard`, `InfoRow`, `SkillGroup`, and `ProjectCard`. Add widgets only where they improve readability, interaction, or responsive behavior.

## 5. Local interactions

**Profile photo.** Use a compatible Flutter image-picker package or an existing project equivalent to choose a local gallery photo. Update the `CircleAvatar` immediately after successful selection. Preserve proportions with a centered circular crop or cover fit. Show initials before selection. On cancellation, retain the current photo. On permission or decoding failure, retain the current image and show concise feedback with a way to retry. Keep selected image data in memory and use a reasonable decode size for an avatar. Configure the platform permissions required by the chosen picker and check that the screen is still mounted after asynchronous actions.

**Appearance.** Provide System, Light, and Dark in a native Material menu or sheet, with System as the initial choice. Update the full theme while retaining the current photo, privacy preference, and expansion state for the session.

**Privacy.** Start with sensitive fields hidden. A clearly labeled local control reveals or hides Student ID, date of birth, blood group, both email addresses, phone number, and street address together. Apply it everywhere these fields could appear, including the hero. While hidden, render a simple “Hidden” state or omit the value and its actions entirely. Keep the underlying value out of accessibility labels, tooltips, and clipboard actions while hidden. City and country may remain visible. The control manages on-screen display for screen sharing. The supplied values are still bundled in the app, so keep the source and builds containing them private.

**GitHub.** Open the exact supplied HTTPS URL in the platform browser with an appropriate launcher. Show concise feedback if the link cannot open.

## 6. Visual system

Use a calm blue-led Material 3 palette with restrained cyan or indigo accents. Use a soft cool gradient on light surfaces and a deep slate-blue gradient in dark mode. Reserve visible frosted-glass styling for the hero and a few key surfaces. Use more opaque tonal cards for text-heavy sections. Clip any actual blur to its surface and keep it off repeated scrolling rows. Use a consistent rounded shape, thin borders, modest shadows, clear typography, and comfortable whitespace. A system sans-serif is sufficient, especially when it provides reliable Bengali glyph fallback.

Centralize colors, spacing, type styles, radii, and animation durations in the theme or small local token definitions. Use subtle motion for useful state changes, honor reduced-motion settings, and keep every action understandable without motion. Use local assets and fallbacks. Avoid decorative text, generic promotional copy, fabricated institution logos, and oversized empty hero areas.

## 7. Responsive and accessible behavior

Use width-based layout decisions. Treat the following ranges as starting points and fall back to one column when content or text scaling needs more space.

| Available width | Layout |
| --- | --- |
| Under 600 logical px | One reading column, compact but comfortable gutters, wrapped chips and stats, vertical contact rows where needed. |
| 600–1023 logical px | Center the scroll content. Widen the hero and pair compatible cards only when both columns have enough usable width. |
| 1024 logical px and above | Center the content in a maximum-width container of roughly 1,040 logical px. Use at most two content columns and keep the hero prominent. Preserve the same app navigation. |

Support portrait, short landscape windows, split-screen, resizable windows, and foldable pane widths. Keep important content and controls clear of safe insets and obstructing hinges. Let the screen scroll vertically as needed. Keep controls reachable if a system UI or keyboard reduces usable height. Avoid fixed content-card heights. Preserve long names, emails, degree titles, Bengali strings, and other translations with wrapping and flexible rows. Never force users to scroll horizontally to read profile details.

Respect system text scaling and check at 200%. Use clear screen-reader names and states, labeled disclosure controls, visible keyboard focus, sensible traversal order, touch targets of at least 48 × 48 logical px, and sufficient contrast across both themes and all glass surfaces. Convey status with text as well as icons or color. Use direction-aware padding and alignment and centralize labels for future Bengali, English, and RTL localization. A language switch is outside this phase.

## 8. Build and verify

1. Inspect the project, if one exists. Briefly outline screen order, visual tokens, adaptive layout, and local interactions, then implement.
2. Separate profile data, screen composition, theme, and reusable widgets. Prefer straightforward Dart and a small dependency set. Use Flutter SDK widgets where they suffice.
3. Deliver complete runnable source, required dependency and platform setup, and concise run instructions. If a workspace is available, implement directly in it. Otherwise provide a file tree and complete file contents.
4. Format the Dart code, run `flutter analyze`, and run applicable tests and UI checks where the environment allows. Fix regressions before delivering. Record the checks actually performed and any platform-specific checks still pending.

Verify compact portrait (320 × 568 and 390 × 844), short landscape (568 × 320 and 844 × 390), tablet (768 × 1024 and 1024 × 768), and expanded window (1440 × 900 or 1920 × 1080). Also check split-screen width and 200% text scaling in light and dark modes. Confirm each mandatory widget is used in the running UI, long values wrap, no RenderFlex overflow appears, the profile remains usable on rotation, and the responsive layout never introduces a sidebar. Exercise photo selection, cancellation and failure, privacy reveal and re-hide, section disclosure, theme changes, and GitHub link handling. Verify that the two project cards and the visible academic values match the supplied information exactly.
