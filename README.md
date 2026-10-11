# FormCheck 📋🇮🇳

**Independent Document Preparation Assistant for Indian Passport Applicants**

FormCheck is an open-source, privacy-first mobile application built with Flutter to help first-time Indian passport applicants organize their documents, understand official requirements, and detect potential inconsistencies before visiting the **Passport Seva Kendra (PSK / POPSK)**.

---

> [!IMPORTANT]
> **Independent Service Notice & Disclaimer**  
> FormCheck is an independent digital preparation tool. It is **NOT affiliated with, authorized by, or endorsed by** the Government of India, the Ministry of External Affairs (MEA), or the official Passport Seva portal. FormCheck does not issue passports, schedule official appointments, or guarantee application acceptance. Always verify the latest official rules at the [Passport Seva Portal](https://www.passportindia.gov.in).

---

## 🎯 Target Scope (MVP)

- **Application Type:** Fresh Passport (First-time applicant)
- **Scheme:** Normal Scheme
- **Applicant Category:** Adult (18 years of age or older)
- **Booklet Type:** 36 Pages / 60 Pages

*(Unsupported applicant categories such as minors, senior citizens requiring special annexures, or Tatkaal scheme applications are directed to the official Document Advisor).*

---

## 🏛️ Verified Official Sources

Every document requirement and rule within FormCheck is mapped strictly against official Ministry of External Affairs publications (verified **October 2026**):

| Official Source | Purpose | Link |
| :--- | :--- | :--- |
| **Passport Seva Document Advisor** | Proof of Date of Birth, Address & Non-ECR requirements | [Document Advisor](https://www.passportindia.gov.in/psp/docAdvisor/attachmentAdvFreshInp) |
| **Passport Seva Application Guide** | Step-by-step submission workflow & biometric instructions | [Application Guide](https://www.passportindia.gov.in/psp/Apply) |
| **Passport Seva Fee Calculator** | Official fee schedule for Normal & Tatkaal booklets | [Fee Calculator](https://www.passportindia.gov.in/psp/FeeCalculator) |

---

## 🔒 Privacy & Data Architecture

Identity documents contain sensitive personal identifiable information (PII). FormCheck is architected with strict on-device data isolation:

- **100% On-Device Processing:** Optical Character Recognition (OCR) and text verification execute locally on the smartphone.
- **Zero Cloud Uploads:** Document images, names, and extracted texts are **never** transmitted to remote servers.
- **Zero Document Retention:** Original camera captures or gallery selections are not persisted without explicit user action.
- **No Sensitive Identifiers Collected:** FormCheck never asks for or stores full Aadhaar numbers, PAN numbers, or banking credentials.

---

## 📱 Tech Stack

- **Framework:** Flutter 3.47+ / Dart 3.13+ (Stable Channel)
- **Design System:** Material 3 with accessible typography and high-contrast color scheme
- **State Management:** Riverpod (`flutter_riverpod`)
- **Navigation:** Declarative routing via `go_router`
- **External Links:** `url_launcher` with secure external application launch modes
- **Architecture:** Feature-first modular structure (Domain, Data, Presentation)

---

## 📂 Project Architecture

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_strings.dart          # Centralized UI copy & disclaimers
│   │   └── official_sources.dart     # MEA source citations & verification dates
│   ├── router/
│   │   └── app_router.dart           # Declarative go_router routes
│   ├── theme/
│   │   ├── app_colors.dart           # FormCheck navy/slate palette
│   │   └── app_theme.dart            # Material 3 Light & Dark themes
│   └── widgets/
│       ├── disclaimer_banner.dart    # Standardized legal notice widget
│       └── official_source_badge.dart# Verified MEA citation badge
├── features/
│   ├── welcome/presentation/         # Screen A: Branded welcome & privacy notice
│   ├── profile/presentation/         # Screen B: Applicant profile questionnaire
│   ├── checklist/presentation/       # Screen C: Tailored document requirements
│   ├── scanner/presentation/         # Screen D: Local OCR & discrepancy check
│   └── readiness/presentation/       # Screen E: Final readiness review
└── main.dart                         # Entry point with ProviderScope
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.40+)
- [Android Studio](https://developer.android.com/studio) with Android SDK 34+
- A connected physical Android device (with USB Debugging enabled) or Android Emulator

### Run the App

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd form_check
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code quality checks:**
   ```bash
   dart format --set-exit-if-changed .
   flutter analyze
   flutter test
   ```

4. **Launch on your device or emulator:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run all unit and widget tests:
```bash
flutter test
```

---

## 📄 License

This project is licensed under the MIT License — see the LICENSE file for details.
