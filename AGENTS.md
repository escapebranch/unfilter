# Agent Contribution Guide (AGENTS.md)

This document defines how an AI Agent should write code for the **UnFilter** project. We prioritize **technical integrity**, **architectural purity**, and **UI/UX excellence**.

---

## 1. Coding Standards (The "Principal" Way)

### 1.1 Declarative & Immutable
- Prefer `final` and `const` everywhere.
- Use **Riverpod** for all state management. Avoid `setState` unless the state is purely local to a single widget (e.g., a toggle).
- Data models must extend `Equatable` for efficient rebuilds.

### 1.2 Surgical Precision
- When using the `replace` tool, provide enough context to ensure the edit is unambiguous.
- Do not perform "cleanup" or refactoring of unrelated code unless explicitly requested.
- Always check for existing patterns in `lib/common/widgets` or `lib/core/services` before implementing a new utility.

### 1.3 Professional Logging
- **NEVER** use emojis or icons in `debugPrint` or production logs.
- Follow the format: `[FeatureName] LEVEL: Message`.
- Use the `LoggingService` methods: `info()`, `debug()`, `error()`.

---

## 2. UI/UX Compliance

### 2.1 The "UnFilter Look"
- Check `DESIGN.md` before creating any UI.
- Use **UncutSans** for everything. Ensure the font is explicitly applied in component themes.
- Respect the **Tamil Typography Scaling** logic in `AppTheme.getTheme()`.

### 2.2 Pro-Grade Interactions
- **Selection Mode**: If implementing a list, support multi-select with a long-press (see `ViewLogsPage`).
- **Empty States**: Every list must have a `_buildEmptyState` widget with a relevant icon and descriptive text.
- **Platform Native**: Use `SystemNavigator.pop()` or `BackButton()` where appropriate to feel native to Android.

---

## 3. Reliability & Validation

### 3.1 Crash Protection
- Any operation involving file I/O, network, or Native Channels **must** be wrapped in `try-catch` with a fallback state.
- Use `AsyncValue.guard` in Riverpod Notifiers to catch errors automatically.

### 3.2 Global Stability
- Do not modify `main.dart`'s `runZonedGuarded` logic unless you are specifically improving the crash recovery system.
- Ensure the `CrashRecoveryScreen` remains "provider-independent" so it can render even if the app's state providers are broken.

---

## 4. Finality & Definition of Done

A task is only complete when:
1. The logic is verified (tests or successful repository runs).
2. The UI is pixel-perfect and follows `DESIGN.md`.
3. The code is documented and committed in logical groups.
4. Emojis/icons are removed from all technical outputs.
