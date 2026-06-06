# UnFilter Design System (DESIGN.md)

This document outlines the visual and interaction philosophy of the **UnFilter** project. Adherence to these standards is mandatory for all UI/UX contributions.

---

## 1. Core Philosophy

**Minimalist, Monochromatic, and Technical.**
UnFilter is a tool for "app intelligence." Its design should feel like a professional diagnostic instrument—clean, precise, and high-performance.

- **Monochrome Base**: We use Black and White as primary colors. Depth is created through **opacity** and **layering**, not vibrant colors.
- **Information Density**: Content is dense but breathable. We prioritize clarity of technical data (package names, SDK versions, tech stacks).
- **Subtle Modernism**: Rounded corners (`16px`, `24px`), subtle borders (`0.1` to `0.5` opacity), and "ink-well" interactions.

---

## 2. Typography

We use **UncutSans** as our signature font family. It is a modern, clean sans-serif with a strong character.

### 2.1 Dynamic Locale Scaling
Tamil (and other non-Latin scripts) often have larger glyphs. We implement a **Dynamic Typography System** that automatically scales text based on the locale:

| Style Group | Tamil Scaling | Intent |
| :--- | :--- | :--- |
| **Display** | 0.60 (40% reduction) | Hero headers, large banners. |
| **Headline** | 0.70 (30% reduction) | Page titles, major sections. |
| **Label** | 0.75 (25% reduction) | Buttons, tags, chips. |
| **Body** | 0.80 (20% reduction) | Standard readable text. |

### 2.2 Formatting Rules
- **Headers**: Bold or W900, tight letter spacing (`-0.5` to `-1.5`) for English.
- **Technical Data**: Use `monospace` font family for package names, versions, and logs.
- **Labels**: Uppercase labels (e.g., `DIAGNOSTIC TRACE`) should have increased letter spacing (`1.2`) and heavy weights.

---

## 3. Color Palette

Managed via `AppColors` and `AppTheme`.

- **Primary**: Light Mode: `Black` | Dark Mode: `White`.
- **Backgrounds**: Pure `White` or `Black`.
- **Surfaces**: Subtle greys (`0xF5F5F5`, `0xFF1E1E1E`).
- **Accents**: Use **Opacities**. Instead of adding new colors, use `primary.withValues(alpha: 0.1)` for backgrounds of tags/chips.

---

## 4. Components & Layout

### 4.1 Surfaces
- **SectionContainer**: Use for grouping related information. It provides consistent padding and rounded corners.
- **Cards**: Elevation `0`, Border width `1` with low opacity (`0.1` - `0.3`).

### 4.2 Feedback & Motion
- **Transitions**: Use `ProPageTransitionsBuilder` for high-quality, non-standard route animations.
- **Haptics**: Apply `HapticFeedback.lightImpact()` on primary actions (e.g., scan start, premium navigation).
- **Loading**: Use `Skeletonizer` for data-heavy views. Never show a blank screen.

---

## 5. Engineering Standards

- **Riverpod**: Every stateful component must be a `ConsumerWidget` or `ConsumerStatefulWidget`.
- **Native Efficiency**: Data transfers from Android to Dart must be **chunked** (see `MainActivity.kt`) to avoid the 1MB Binder limit.
- **Error Boundaries**: Every screen must handle the `.when(error: ...)` state from providers. Global crashes are handled by the `CrashRecoveryScreen`.
