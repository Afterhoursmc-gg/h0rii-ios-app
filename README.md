# H0RII iOS App

Native SwiftUI iOS starter app for H0RII, built as an Xcode project from Linux so it can be opened and published from a Mac.

## Open on Mac

1. Clone/download this repository.
2. Open `H0RIIApp.xcodeproj` in Xcode 16+.
3. Select the `H0RIIApp` scheme.
4. Set your Apple Team under **Signing & Capabilities**.
5. Change the bundle identifier if needed (`dev.horii.H0RIIApp`).
6. Run on iPhone Simulator or a real device.

## What is included

- SwiftUI app target for iOS 17+
- Clean H0RII-style dashboard
- Project cards for H0RII Labs, AfterHoursMC, HXSecurity and H0RII Excel
- Status overview and quick actions
- Local-only source, no secrets, no backend credentials

## Publish notes

This repository contains source only. Final signing, App Store Connect setup, provisioning profiles and archive upload must be done on macOS/Xcode.
