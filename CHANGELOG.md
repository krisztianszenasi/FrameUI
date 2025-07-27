# Changelog

> ⚠️ **Note:** This project is currently in beta. Breaking changes may occur between minor versions until version 1.0.0.

All significant changes to this project are documented in this file.

This changelog follows the principles of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.6.2] - 2025-07-27

### Added

- Introduced `FUIBoxView`: a native `UIView` subclass designed for overlaying `UIView` elements. It supports similar sizing behavior and alignment options as `FUIStackView`.

### Fixed

- Resolved an issue in `FUIStackView` where the weighted cross-axis size was being calculated incorrectly.

---

## [0.6.1] - 2025-07-25

### Fixed

- Resolved a redefinition issue where the `StackLayout` struct reappeared due to an unintended merge.

---

## [0.6.0] - 2025-07-25

### Added

- Introduced `FUIStackView`, a native `UIView` subclass that replaces the previous `StackLayout` system. It integrates more naturally with UIKit, and since it retains existing subviews, changes can now be smoothly animated.

### Removed

- Deprecated the old `StackLayout` struct and its static layout function, in favor of the new `FUIStackView`.