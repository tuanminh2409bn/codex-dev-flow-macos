# Flutter and Dart

Use only for the affected Flutter/Dart workspace.

## Discover narrowly

Read `pubspec.yaml`, `analysis_options.yaml`, the relevant entry point, and the affected feature directory. Check `.fvm/`, `.fvmrc`, `melos.yaml`, build scripts, and existing tests only when present or relevant. Ignore `.dart_tool/`, `build/`, generated platform artifacts, coverage, and generated Dart bodies.

Use `fvm flutter`/`fvm dart` when the repository is configured for FVM; otherwise use `flutter`/`dart`. In a Melos workspace, use its existing package scripts and filters.

## Preserve project decisions

- Detect and follow the current state management, routing, dependency injection, repository/service boundaries, localization, theme, and error-handling patterns.
- Do not introduce another architecture or state-management package for local convenience.
- Do not edit generated files such as `*.g.dart`, `*.freezed.dart`, or generated localization output. Run the repository's generator only when source annotations or schemas require it.
- Do not edit `pubspec.lock` manually or add dependencies without explicit authority.

## Correctness

- Preserve sound null safety and avoid new `dynamic` or unchecked casts without a documented boundary reason.
- After an async gap, verify widget lifecycle before using `BuildContext` or mutating widget state.
- Dispose controllers, focus nodes, subscriptions, streams, and platform resources according to ownership.
- Keep business logic out of widgets when the existing architecture provides a testable domain or state layer.
- Handle loading, empty, error, offline, retry, and cancellation states when they are relevant to the changed flow.
- Keep widgets focused and use `const` where it improves rebuild behavior without obscuring code.

## Platform and UI boundaries

- Touch `ios/`, `android/`, `macos/`, `windows/`, `linux/`, or `web/` only when the requested behavior crosses that boundary.
- For platform changes, check permissions, entitlements, deep links, lifecycle, minimum versions, and platform-specific configuration relevant to the target.
- For UI changes, preserve responsive behavior, text scaling, localization, semantics, keyboard navigation, focus order, contrast, and both mobile and web input models where applicable.

## Verification ladder

Use existing scripts when available. Otherwise select the smallest applicable progression:

1. `dart format` on changed Dart files.
2. `flutter analyze` for the affected package; do not hide analyzer findings.
3. A focused unit, widget, or golden test covering the changed behavior.
4. The affected package's test suite for shared logic or cross-feature changes.
5. An integration or runtime smoke test for navigation, plugins, platform channels, persistence, networking, or lifecycle behavior.
6. Build only affected targets: web, Android, iOS, macOS, Windows, or Linux. Do not build every platform by default.

For Flutter Web runtime or visual behavior, use browser testing only when static checks and widget tests cannot prove the outcome.
