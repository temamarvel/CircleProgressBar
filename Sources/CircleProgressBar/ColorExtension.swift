//
//  Color.swift
//  CircleProgressBar
//
//  Created by Артем Денисов on 02.01.2026.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    // отдельные цвета (удобно переиспользовать)
    static let surfCoral   = Color(hex: "#E86A5B")
    static let surfOrange  = Color(hex: "#FF7E3E")
    static let surfSand    = Color(hex: "#F4D27A")
    static let surfPalm    = Color(hex: "#6DAA6E")
    static let surfPacific = Color(hex: "#1C9CA6")
    
    // сам градиент (массив цветов)
    static let surfProgressGradient: [Color] = [
        .surfCoral,
        .surfOrange,
        .surfSand,
        .surfPalm,
        .surfPacific
    ]
    
    func lighter(by amount: CGFloat = 0.2) -> Color {
        let uiColor = UIColor(self)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return self
        }
        
        return Color(
            hue: h,
            saturation: s,
            brightness: min(b + amount, 1.0),
            opacity: a
        )
    }
    
    static func interpolate(from: Color, to: Color, fraction: CGFloat) -> Color {
        let f = max(0, min(fraction, 1))
        
        let fromUIColor = UIColor(from)
        let toUIColor = UIColor(to)
        
        var fr: CGFloat = 0, fg: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
        var tr: CGFloat = 0, tg: CGFloat = 0, tb: CGFloat = 0, ta: CGFloat = 0
        
        guard fromUIColor.getRed(&fr, green: &fg, blue: &fb, alpha: &fa),
              toUIColor.getRed(&tr, green: &tg, blue: &tb, alpha: &ta) else {
            return from
        }
        
        let r = fr + (tr - fr) * f
        let g = fg + (tg - fg) * f
        let b = fb + (tb - fb) * f
        let a = fa + (ta - fa) * f
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}
