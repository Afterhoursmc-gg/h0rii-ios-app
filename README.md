# H0RII iOS App

Native SwiftUI iOS companion / command-center app for H0RII, built as an Xcode project from Linux so it can be opened and published from a Mac.

Repository: https://github.com/Afterhoursmc-gg/h0rii-ios-app

## Open on Mac

```bash
git clone https://github.com/Afterhoursmc-gg/h0rii-ios-app.git
open h0rii-ios-app/H0RIIApp.xcodeproj
```

Then:

1. Select the `H0RIIApp` scheme.
2. Set your Apple Team under **Signing & Capabilities**.
3. Change the bundle identifier if needed (`dev.horii.H0RIIApp`).
4. Run on iPhone Simulator or a real iPhone.

## Current app

This is a native H0RII companion / command-center app:

- Home dashboard with H0RII branding
- AfterHoursMC public stats card connected to `https://horii.dev/api/public/stats`
- Pull-to-refresh stats
- Quick links to H0RII, AfterHoursMC, HXSecurity and H0RII Excel
- Projects tab with search, favorites and project cards
- Status tab for web, Discord, Minecraft and security systems
- Voice/Reise tab with push-to-talk speech-to-text and spoken replies
- Siri Shortcut/App Intents handoff: say `Hei Siri, H0RII` / `Hey Siri, Ask H0RII` for locked-screen compatible entry
- Background App Refresh scaffold for safe live background updates
- Local notification permission/test hook for H0RII wake/status hints
- In-app answer panel so H0RII does not kick you out to Safari/Maps/Translate
- Bus route intent parser for “fra … til …” with Entur API as next backend step
- In-app weather via Open-Meteo public API
- Contact/number lookup with Contacts permission, shown in-app before any call action
- Calculator commands for simple math
- Local mini-translation for common phrases
- General in-app fallback answer mode for “ask anything” QoL flow
- Profile tab for Jhonatan Wik / H0RII
- App roadmap section
- Clean dark SwiftUI interface
- No secrets and no backend credentials

## Horii always-listening prototype

The `Horii` tab implements the requested assistant architecture with real Swift code and public Apple APIs:

```text
Microphone → WakeWordDetector → Speech-to-Text → HoriiAIService → AVSpeechSynthesizer → Wake Word Mode
```

Project structure:

```text
H0RIIApp/
├── UI/HoriiAssistantPrototypeView.swift
├── Audio/AudioSessionManager.swift
├── Audio/WakeWordDetector.swift
├── Audio/SpeechRecognizer.swift
├── AI/HoriiAIService.swift
├── Speech/HoriiTTS.swift
├── Models/HoriiAssistantState.swift
└── Services/HoriiAssistantController.swift
```

State machine:

```text
idle → waitingForWakeWord → wakeWordDetected → listening → processing → speaking → waitingForWakeWord
```

Implemented:

- `WakeWordDetector` protocol exactly so a true local wake-word engine can replace the adapter later.
- **Picovoice Porcupine Swift Package connected** for a real local wake-word engine.
- `PorcupineWakeWordDetector` uses a local `Hei Horii` `.ppn` keyword model when configured.
- Prototype `SpeechWakeWordDetector` remains as fallback when Porcupine AccessKey/model are missing.
- `AVAudioSession` configured with `.playAndRecord`, `.voiceChat`, Bluetooth and speaker options.
- `SFSpeechRecognizer` command transcription after the wake word.
- `HoriiAIService.send(message:)` with mock provider first, and HTTP provider scaffold for your backend.
- `AVSpeechSynthesizer` TTS.
- UI for state, transcript, answer, microphone permission and background-listening indicator.

## Xcode capabilities / Info.plist

Enable these on the target in Xcode:

- **Signing & Capabilities → Background Modes**
  - `Audio, AirPlay, and Picture in Picture`
  - `Background fetch` if you want refresh/status tasks too
  - `Remote notifications` only if you later add push
- **Info.plist / generated build settings**
  - `NSMicrophoneUsageDescription`
  - `NSSpeechRecognitionUsageDescription`
  - `UIBackgroundModes`: `audio`, `fetch`, `remote-notification`
  - `BGTaskSchedulerPermittedIdentifiers`: `dev.horii.H0RIIApp.refresh`

## Real `Hei Horii` setup with Porcupine

This repo now includes the Picovoice Porcupine Swift Package dependency:

```text
https://github.com/Picovoice/porcupine.git
```

To test the real local wake-word path on iPhone:

1. Open Picovoice Console and create an iOS custom keyword for `Hei Horii`.
2. Download the iOS `.ppn` file.
3. Add it to the Xcode app target bundle as `hei_horii_ios.ppn`.
4. Run the app, open the **Horii** tab, paste the Picovoice AccessKey into the local field, then restart the app.
5. Tap **Enable Assistant**. The status should say `Porcupine lytter lokalt etter Hei Horii`.

No AccessKey is committed to git. No continuous microphone stream is sent to the Horii backend before Porcupine detects the wake word.

## iOS limitation / App Store reality

iOS does **not** grant third-party apps Siri-level always-on custom hotword entitlement. This prototype uses public APIs only:

- Foreground: the full state machine can run.
- Locked screen while app has an active permitted audio session: testable on a physical iPhone, but iOS may still suspend/limit continuous speech recognition depending on device, battery, route and system policy.
- App Store review: background audio must be justified by real audio functionality; a hidden always-on microphone assistant can be rejected.
- Production path: keep this adapter layer, then plug in a real on-device wake-word SDK/model into `WakeWordDetector` without streaming continuous mic audio to a server.

Siri remains separate:

- `Hei Siri` → Siri
- `Hei Horii` → Horii prototype when the app/audio session is allowed to keep running
- fallback supported path: `Hei Siri, H0RII` through App Intents

## Next upgrades

- Connect Status tab to `status.horii.dev` uptime/incidents API
- Add push notifications for incidents/launches
- Add richer AfterHoursMC details from safe public endpoint
- Add authenticated admin mode later if needed
- Add custom app icon images before App Store submission

## Publish notes

This repository contains source only. Final signing, App Store Connect setup, provisioning profiles and archive upload must be done on macOS/Xcode.
