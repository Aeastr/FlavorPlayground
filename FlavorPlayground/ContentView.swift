//
//  ContentView.swift
//  FlavorPlayground
//
//  Created by Aether on 17/12/2024.
//

import SwiftUI
import Garnish
import CoreData
#Preview {
    ContentView()
}

struct ContentView: View {
    @State private var inputColor: Color = Color(red: 0.8, green: 0.3, blue: 0.2)
    @Environment(\.colorScheme) var colorScheme
    
    @State var blendAmount: CGFloat = 0.8
    @State var detent: PresentationDetent = .height(230)
//    @State var detent: PresentationDetent = .fraction(0.6)
    
    
    @State var colors: [Color] = [
        Color.clear, Color.clear, Color.clear, Color.clear, Color.clear
    ]
    @State var array = [0,1,2,3,4]
    
    @State var colorsDark: [Color] = [
        Color.clear, Color.clear, Color.clear, Color.clear, Color.clear
    ]
    
    @State var selectedColor: Color = Color.red
    
    func retrieveClipboardContent() -> String  {
        let pasteboard = UIPasteboard.general
        return pasteboard.string ?? "No content in clipboard"
    }
    
    var body: some View {
        NavigationSplitView{
            ScrollView{
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 15){
                        VStack(alignment: .leading, spacing: 5){
                            Text("Base Color")
                                .font(.headline)
                            Text("The main color used for this flavor")
                                .font(.caption)
                                .opacity(0.7)
                        }
                            
                            RoundedRectangle(cornerRadius: 25)
                                .fill(selectedColor)
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 25)
                                        .strokeBorder(
                                            Color(.systemBackground),
                                            lineWidth: 10
                                        )
                                })
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 25)
                                        .strokeBorder(
                                            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center, startAngle: .zero, endAngle: .degrees(360)),
                                            lineWidth: 5
                                        )
                                })
                                .frame(height: 120)
                        
                        ColorPicker("Select", selection: $selectedColor)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    .onChange(of: selectedColor, initial: true) { oldValue, newValue in
                        initializefromColor(baseColor: newValue)
                    }
//                    VStack(alignment: .leading, spacing: 10){
//                        VStack(alignment: .leading, spacing: 5){
//                            Text("Utility Tests")
//                            .font(.headline)
//                            
//                            Text("Some tests of other utility functions")
//                                .font(.caption)
//                                .opacity(0.7)
//                        }
//                        
//                        
//                        // Utility Tests
//                        VStack(alignment: .leading, spacing: 10) {
//                            
//                            let luminance = Garnish.relativeLuminance(of: inputColor)
//                            let brightness = Garnish.brightness(of: inputColor)
//                            
//                            Text("Relative Luminance: \(luminance, specifier: "%.2f")")
//                            Text("Brightness: \(brightness, specifier: "%.2f")")
//                            Text("Is Light Color: \(Garnish.isLightColor(inputColor) ? "Yes" : "No")")
//                            Text("Colorscheme: \(Garnish.determineColorScheme(inputColor))")
//                            Text("Is Dark Color: \(Garnish.isDarkColor(inputColor) ? "Yes" : "No")")
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal, 20)
                }
                .safeAreaPadding(.top)
            }
            .navigationTitle("Controls")
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            VStack(spacing: 30){
                VStack(alignment: .leading, spacing: 20){
                    VStack(alignment: .leading, spacing: 5){
                        Text("Light Colors")
                            .font(.headline)
                        Text("The main set of light colors for the selected color")
                            .font(.caption)
                            .opacity(0.7)
                    }
                    
                    HStack{
                        ForEach(colors.indices, id: \.self) { index in
                            let color = colors[index]
                            Button(action: {
                                copyToClipboard(text: color.description)
                            }, label: {
                                VStack{
                                    ColorRectangle(color: color)
                                        .overlay{
                                            Text(colors[index].description)
                                                .foregroundStyle(Garnish.contrastingForeground(for: color))
                                                .font(.body.weight(.semibold))
                                                .fontDesign(.monospaced)
                                        }
                                }
                            })
                            .frame(height: 120)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20){
                    VStack(alignment: .leading, spacing: 5){
                        Text("Dark Colors")
                            .font(.headline)
                        Text("The secondary set of dark colors for the selected color, (by default mostly the same except for background colors).")
                            .font(.caption)
                            .opacity(0.7)
                    }
                    
                    HStack{
                        ForEach(colorsDark.indices, id: \.self) { index in
                            let color = colorsDark[index]
                            Button(action: {
                                copyToClipboard(text: color.description)
                            }, label: {
                                VStack{
                                    ColorRectangle(color: color)
                                        .overlay{
                                            Text(colors[index].description)
                                                .foregroundStyle(Garnish.contrastingForeground(for: color))
                                                .font(.body.weight(.semibold))
                                                .fontDesign(.monospaced)
                                        }
                                }
                            })
                            .frame(height: 120)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .colorScheme(colorScheme)
        .preferredColorScheme(colorScheme)
    }
    
    func initializefromColor(baseColor: Color) {
        func randomAdjustment() -> Double {
            return Double(Int.random(in: -3...3)) / 10.0
        }
        
        // Extract hue, saturation, and brightness from the baseColor
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let couldBeConverted = UIColor(baseColor).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if couldBeConverted {
            let base1Brightness = max(0.0, min(0.9, brightness + randomAdjustment()))
            let base2Brightness = brightness
            let base3Brightness = max(0.0, min(0.94, brightness + randomAdjustment()))
            
            let base1Saturation = max(0.0, min(0.93, saturation + randomAdjustment()))
            let base2Saturation = saturation
            let base3Saturation = max(0.0, min(0.92, saturation + randomAdjustment()))
            
            colors = [
                .shadeOf(baseHue: hue, brightness: base1Brightness, saturation: base1Saturation),
                .shadeOf(baseHue: hue, brightness: base2Brightness, saturation: base2Saturation),
                .shadeOf(baseHue: hue, brightness: base3Brightness, saturation: base3Saturation),
                .shadeOf(baseHue: hue, brightness: 0.98, saturation: 0.02),
                .shadeOf(baseHue: hue, brightness: 0.96, saturation: 0.04)
            ]
            
            colorsDark = [
                .shadeOf(baseHue: hue, brightness: base1Brightness, saturation: base1Saturation),
                .shadeOf(baseHue: hue, brightness: base2Brightness, saturation: base2Saturation),
                .shadeOf(baseHue: hue, brightness: base3Brightness, saturation: base3Saturation),
                .shadeOf(baseHue: hue, brightness: 0.10, saturation: 0.35),
                .shadeOf(baseHue: hue, brightness: 0.15, saturation: 0.25)
            ]
        }
    }
    
    
    func copyToClipboard(text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }
}


struct ColorRectangle: View {
    let color: Color
    let outLineColor: Color
    let height: CGFloat
    
    init(color: Color, outLineColor: Color? = nil, height: CGFloat = 110) {
        self.color = color
        self.outLineColor = outLineColor ?? color.adjustedBrightness(by: 0.1)
        self.height = height
    }
    
    var body: some View {
        color
            .clipShape(.rect(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(outLineColor, lineWidth: 3)
            )
            .frame(minHeight: height)
    }
}
