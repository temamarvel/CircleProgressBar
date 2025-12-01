import SwiftUI
import UIKit

public struct CircleProgressView: View {
    
    
    let progress: Double
    let gradientColors: [Color]
    
    public init(
        progress: Double,
        gradientColors: [Color] = [.red, .yellow, .green]
    ) {
        self.progress = progress
        self.gradientColors = gradientColors
    }

    private var normalizedProgress: Double {
        guard progress > 0 else { return 0 }
        if progress == 1.0 { return 1 }
        return progress.truncatingRemainder(dividingBy: 1)
    }
    private var isFirstLap: Bool {
        return progress <= 1.0
    }
    
    private var isHalfLap: Bool {
        return progress <= 0.5
    }
    
    private var barColor: Color {
        let t = max(0, min(progress, 1))

        guard !gradientColors.isEmpty else {
            return .green
        }
        
        if gradientColors.count == 1 {
            return gradientColors[0]
        }

        let segmentCount = gradientColors.count - 1

        let scaled = t * Double(segmentCount)

        let rawLowerIndex = Int(floor(scaled))
        let lowerIndex = max(0, min(rawLowerIndex, segmentCount - 1))

        let upperIndex = lowerIndex + 1

        let localT = CGFloat(scaled - Double(lowerIndex))

        let fromColor = gradientColors[lowerIndex]
        let toColor = gradientColors[upperIndex]

        return .interpolate(from: fromColor, to: toColor, fraction: localT)
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 30)
                .opacity(0.3)
                .foregroundColor(Color(UIColor.systemGray3))

            if !isFirstLap {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 30))
                        .foregroundColor(barColor)
            }
            
            if !isHalfLap {
                Circle()
                    .trim(from: 0.0, to: normalizedProgress)
                    .stroke(style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round,
                        lineJoin: .round))
                    .foregroundStyle(barColor)
                    .rotationEffect(.degrees(-90.0))
            }

            Circle()
                .trim(from: CGFloat(abs((min(normalizedProgress, 1.0))-0.001)), to: CGFloat(abs((min(normalizedProgress, 1.0))-0.0005)))
                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                .foregroundColor(barColor)
                .shadow(color: .black, radius: 10, x: 0, y: 0)
                .rotationEffect(.degrees(-90.0))
                .clipShape(
                    Circle().stroke(lineWidth: 30)
                )
            
            Circle()
                .trim(from: 0.0, to: isHalfLap ? normalizedProgress : 0.5)
                .stroke(style: StrokeStyle(
                    lineWidth: 30,
                    lineCap: .round,
                    lineJoin: .round))
                .foregroundStyle(.angularGradient(
                    colors: [barColor, barColor.lighter(by: 0.2)],
                    center: .center,
                    startAngle: .degrees(-5),
                    endAngle: .degrees(355)
                ))
                .rotationEffect(.degrees(isHalfLap ? -90.0 : -270.0+normalizedProgress*360))
        }
        .padding()
    }
}

struct CircleProgressViewPreviewContainer: View {
    @State private var progress: Double = 0.1

    var body: some View {
        VStack(spacing: 24) {
            CircleProgressView(progress: progress)

            Slider(value: $progress, in: 0...3)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.black)
    }
}

extension Color {
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


#Preview {
    CircleProgressViewPreviewContainer()
}
