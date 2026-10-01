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

## iOS voice/background limitation

iOS does **not** allow third-party apps to run an always-on hidden microphone wake word like Siri while the phone is locked/off. The compliant path is Siri/App Intents + Background App Refresh + notifications:

- Use Siri phrase: `Hei Siri, H0RII` or `Hey Siri, Ask H0RII`.
- The app registers a background refresh task: `dev.horii.H0RIIApp.refresh`.
- The app can send notification hints/status when permission is granted.
- Full custom `Hei H0RII` hotword while locked would require Apple/system-level Siri privileges, not normal App Store APIs.

## Next upgrades

- Connect Status tab to `status.horii.dev` uptime/incidents API
- Add push notifications for incidents/launches
- Add richer AfterHoursMC details from safe public endpoint
- Add authenticated admin mode later if needed
- Add custom app icon images before App Store submission

## Publish notes

This repository contains source only. Final signing, App Store Connect setup, provisioning profiles and archive upload must be done on macOS/Xcode.
