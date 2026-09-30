# H0RII iOS App

Native SwiftUI iOS starter app for H0RII, built as an Xcode project from Linux so it can be opened and published from a Mac.

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
- Quick links to H0RII, AfterHoursMC, HXSecurity and H0RII Excel
- Projects tab with project cards
- Status tab for web, Discord, Minecraft and security systems
- Profile tab for Jhonatan Wik / H0RII
- App roadmap section
- Clean dark SwiftUI interface
- Local-only static data for now, no secrets and no backend credentials

## Next upgrades

- Connect Status tab to a public `status.horii.dev` API
- Add AfterHoursMC public stats endpoint
- Add push notifications for incidents/launches
- Add authenticated admin mode later if needed

## Publish notes

This repository contains source only. Final signing, App Store Connect setup, provisioning profiles and archive upload must be done on macOS/Xcode.
