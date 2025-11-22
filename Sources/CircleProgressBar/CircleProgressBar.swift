import SwiftUI
import UIKit

public struct CircleProgressView: View {
    
    let progress: Double
    
    public init(progress: Double) {
        self.progress = progress
    }

    
    private var normalizedProgress: Double {
        guard progress > 0 else { return 0 }
        if progress == 1.0 { return 1 }
        return progress.truncatingRemainder(dividingBy: 1)
    }
    private var isFirstLap: Bool {
        return progress <= 0.98
    }
    private var barColor: Color {
        // Цвет можно нормализовать в 0...1, даже если progress > 1
        let t = max(0, min(progress, 1)) // только для цвета, длину дуги можно считать по-другому
        
        if t < 0.5 {
            // 0...0.5 → 0...1 для перехода red → yellow
            let localT = t / 0.5
            return .interpolate(from: .red, to: .yellow, fraction: localT)
        } else {
            // 0.5...1 → 0...1 для перехода yellow → green
            let localT = (t - 0.5) / 0.5
            return .interpolate(from: .yellow, to: .green, fraction: localT)
        }
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
                        .foregroundColor(barColor.lighter(by: 0.2))
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
            VStack{
                Text("\(progress)").foregroundColor(Color.green)
                Text("\(normalizedProgress)").foregroundColor(Color.red)
            }
            
            Circle()
                .trim(from: 0.0, to: isFirstLap ? normalizedProgress : 0.25)
                .stroke(style: StrokeStyle(
                    lineWidth: 30,
                    lineCap: .round,
                    lineJoin: .round))
                .foregroundStyle(.angularGradient(
                    colors: [barColor, barColor.lighter(by: 0.2)],
                    center: .center,
                    startAngle: .degrees(-10),
                    endAngle: .degrees(350)
                ))
                .rotationEffect(.degrees(isFirstLap ? -90.0 : -180.0+normalizedProgress*360))


            
        }
        .padding()
    }
}

/// Обёртка только для превью
struct CircleProgressView3PreviewContainer: View {
    @State private var progress: Double = 0.1   // 0...1 — цель, >1 — перевыполнение

    var body: some View {
        VStack(spacing: 24) {
            CircleProgressView(progress: progress)

            // Чтобы в превью можно было «крутить» значение
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
        
        // переводим в HSB
        guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return self // если не получилось — возвращаем исходный
        }
        
        return Color(
            hue: h,
            saturation: s,
            brightness: min(b + amount, 1.0),
            opacity: a
        )
    }
    
    static func interpolate(from: Color, to: Color, fraction: CGFloat) -> Color {
        let f = max(0, min(fraction, 1)) // clamp 0...1
        
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


#Preview("Calorie ring3 interactive") {
    CircleProgressView3PreviewContainer()
}
