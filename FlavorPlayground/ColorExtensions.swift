//
//  ColorExtensions.swift
//  FlavorPlayground
//
//  Created by Aether on 17/12/2024.
//


import SwiftUI

extension Color {
    static func shadeOf(baseHue: Double = Double.random(in: 0...1), brightness: Double, saturation: Double) -> Color {
        Color(hue: baseHue, saturation: saturation, brightness: brightness)
    }
}