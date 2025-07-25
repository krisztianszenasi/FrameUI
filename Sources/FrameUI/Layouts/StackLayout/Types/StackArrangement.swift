//
//  StackArrangement.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation


/// Defines the arrangement strategy for elements in a stack layout.
///
/// This enum is used by `StackLayout` to determine how its child elements are positioned.
///
/// The available options are inspired by the flex box systems in web development and
/// arrangement patterns from Jetpack Compose on Android.
/// 
/// For a conceptual reference, see the Jetpack Compose documentation:
/// https://developer.android.com/reference/kotlin/androidx/compose/foundation/layout/Arrangement
public enum StackArrangement {
    case start
    case center
    case end
    case spaceBetween
    case spaceAround
    case spaceEvenly
}
