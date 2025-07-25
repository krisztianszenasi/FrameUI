
# FrameUI

![version](https://img.shields.io/badge/version-0.6.0-blue.svg)

FrameUI is a lightweight UI framework built on UIKit that uses manual frame-based layout instead of Auto Layout or SwiftUI. 

## About the Project

This project originated as a take-home assignment for an iOS developer role where manual layout and frame setting were specifically requested. After some frustration with managing frames directly, I developed FrameUI to make manual layout more manageable and expressive.

At this point, FrameUI should be considered **beta** software. The API and features may change significantly, including breaking changes, as development continues (if it continues).


## Features

At present, the primary supported element is `FUIStackView`, inspired by web-based flexbox layouts and Android Jetpack Compose.

## Installation

FrameUI is distributed as a Swift Package and can be easily integrated into your Xcode project:
1.	Select your project in Xcode and navigate to the Package Dependencies tab.
2.	Click the + button to add a new package.
3.	Enter the repository URL: https://github.com/krisztianszenasi/FrameUI
4.	Choose the version or branch you want to use and add the package to your project.

Once added, you can import FrameUI and start using it right away:

```swift
import FrameUI
```

