# Swift and Apple Platforms (iOS, macOS, SwiftPM, Xcode)

Use only for the affected Swift package or Xcode target.

## Discover narrowly

Read `Package.swift`, relevant `.xcodeproj`/`.xcworkspace` scheme files, `Podfile`, `Info.plist`, and `.entitlements`. Detect the Swift language mode (Swift 5 versus Swift 6 strict concurrency), minimum deployment target (iOS, macOS, watchOS, tvOS, visionOS), UI framework (SwiftUI, UIKit, AppKit), and dependency manager (SwiftPM, CocoaPods, Tuist). Ignore `.build/`, `DerivedData/`, `Pods/`, `xcuserdata/`, and generated asset/localization symbols.

Do not alter code signing, bundle identifiers, team IDs, provisioning profiles, privacy entitlements, or `Podfile.lock` without explicit authority.

## Preserve architecture and platform boundaries

- Respect target separation (app target, extension, framework, SwiftPM module, or Flutter/React Native host plugin) and `@objc`/bridging header contracts.
- Follow the project's state and navigation pattern (`@Observable`, `@State`, `@StateObject`/`ObservableObject`, MVVM, Composable Architecture, or Coordinator/Delegate).
- Keep platform-specific APIs guarded by `#if os(...)` or `#available(...)` when code is shared across Apple platforms or Server Swift.
- Preserve Keychain, App Group, Sandbox, background mode, and Info.plist permission declarations.

## Concurrency, memory, and lifecycle safety

- Respect actor isolation: keep UI mutations on `@MainActor`, ensure `Sendable` safety across concurrency domains, and avoid unstructured `Task.detached` unless required.
- Propagate cancellation (`try Task.checkCancellation()`, `Task.isCancelled`) and cancel running tasks or Combine `AnyCancellable` subscriptions when views or controllers deallocate.
- Prevent reference cycles in closures, timers, `NotificationCenter` observers, and delegates using `[weak self]` and `weak` protocol references.
- Avoid force unwrapping (`!`), `try!`, and `as!` in production code paths; handle optionals and typed errors explicitly.

## Verification ladder

Select the smallest applicable check for the active scheme or package:

1. `swift-format` or `swiftlint` on changed `.swift` files when configured.
2. Focused test (`swift test --filter <Target.Test>` or `xcodebuild test -scheme <Scheme> -destination <Destination> -only-testing:<Target/TestClass/testMethod>`).
3. Target or package build (`swift build` or `xcodebuild build -scheme <Scheme> -destination <Destination>`) with compiler concurrency/deprecation diagnostics respected.
4. Headless or background interactive iOS Simulator or macOS app verification (without bringing Simulator/app windows to the foreground) when UI, layout, lifecycle, navigation, permissions, or native plugin channels change: drive the real user flow and verify layout and runtime logs.
5. Verify bridging headers, entitlements, and resource bundle membership when target configuration changes.
