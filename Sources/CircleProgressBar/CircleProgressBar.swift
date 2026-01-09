import SwiftUI
import UIKit

public enum ProgressStyle {
    case color(Color)
    case gradient([Color])
}

public struct CircleProgressView: View {
    
    let progress: Double
    //let gradientColors: [Color]
    let progressStyle: ProgressStyle
    let enableGlow: Bool
    let enableLighterTailColor: Bool
    
    private var barStyle: AnyShapeStyle {
        switch progressStyle {
            case .color(let color):
                return AnyShapeStyle(color)
                
            case .gradient(let colors):
                return AnyShapeStyle(
                    AngularGradient(
                        colors: colors,
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(progress * 360)
                    )
                )
        }
    }
    
    public init(
        progress: Double,
        //gradientColors: [Color] = [.red, .yellow, .green],
        progressStyle: ProgressStyle,
        enableGlow: Bool = false,
        enableLighterTailColor: Bool = false
    ) {
        self.progress = progress
        //self.gradientColors = gradientColors
        self.progressStyle = progressStyle
        self.enableGlow = enableGlow
        self.enableLighterTailColor = enableLighterTailColor
    }

    private var normalizedProgress: Double {
        guard progress > 0 else { return 0 }
        if progress == 1.0 { return 1 }
        return progress.truncatingRemainder(dividingBy: 1)
        //return progress
    }
    private var isFirstLap: Bool {
        return progress <= 1.0
    }
    
    private var isHalfLap: Bool {
        return progress <= 0.5
    }
    
//    private var barColor: Color {
//        let t = max(0, min(progress, 1))
//
//        guard !gradientColors.isEmpty else {
//            return .green
//        }
//        
//        if gradientColors.count == 1 {
//            return gradientColors[0]
//        }
//
//        let segmentCount = gradientColors.count - 1
//
//        let scaled = t * Double(segmentCount)
//
//        let rawLowerIndex = Int(floor(scaled))
//        let lowerIndex = max(0, min(rawLowerIndex, segmentCount - 1))
//
//        let upperIndex = lowerIndex + 1
//
//        let localT = CGFloat(scaled - Double(lowerIndex))
//
//        let fromColor = gradientColors[lowerIndex]
//        let toColor = gradientColors[upperIndex]
//
//        return .interpolate(from: fromColor, to: toColor, fraction: localT)
//    }
    
    public var body: some View {
        ZStack {
//            if enableGlow {
//                Circle()
//                    .trim(from: 0.0, to: 1.0)
//                    .stroke(style: StrokeStyle(lineWidth: 32, lineCap: .round)) // толще
//                    .foregroundStyle(barStyle)
//                    .blur(radius: 10)
//                    .opacity(0.7)
//                    .blendMode(.screen)
//            }
            
            Circle()
                .stroke(lineWidth: 30)
                .opacity(0.3)
                .foregroundColor(Color(UIColor.systemGray3))

            if !isFirstLap {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 30))
                        .foregroundStyle(barStyle)
            }
            
//            if !isHalfLap {
//                Circle()
//                    .trim(from: 0.0, to: normalizedProgress)
//                    .stroke(style: StrokeStyle(
//                        lineWidth: 30,
//                        lineCap: .round,
//                        lineJoin: .round))
//                    .foregroundStyle(barStyle)
//                    .rotationEffect(.degrees(-90.0))
//            }

            Circle()
                .trim(from: CGFloat(abs((min(normalizedProgress, 1.0))-0.001)), to: CGFloat(abs((min(normalizedProgress, 1.0))-0.0005)))
                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
//                .foregroundColor(enableLighterTailColor ? barColor.lighter(by: 0.2) : barColor)
                .foregroundStyle(barStyle)
                .shadow(color: .black, radius: 10, x: 0, y: 0)
                .rotationEffect(.degrees(-90.0))
                .clipShape(
                    Circle().stroke(lineWidth: 30)
                )
            
//            Circle()
//                .trim(from: 0.0, to: isHalfLap ? normalizedProgress : 0.5)
//                .stroke(style: StrokeStyle(
//                    lineWidth: 30,
//                    lineCap: .round,
//                    lineJoin: .round))
////                .foregroundStyle(enableLighterTailColor ? AnyShapeStyle(.angularGradient(
////                    colors: [barColor, barColor.lighter(by: 0.2)],
////                    center: .center,
////                    startAngle: .degrees(0),
////                    endAngle: .degrees(180)
////                )) :  AnyShapeStyle(barColor))
//                .foregroundStyle(barStyle)
//                .rotationEffect(.degrees(isHalfLap ? -90.0 : -270.0+normalizedProgress*360))
            
            Circle()
                .trim(from: 0.0, to: normalizedProgress)
                .stroke(style: StrokeStyle(
                    lineWidth: 30,
                    lineCap: .round,
                    lineJoin: .round))
            
                .foregroundStyle(barStyle)
                .rotationEffect(.degrees(-90.0))
                //.rotationEffect(.degrees(isHalfLap ? -90.0 : -270.0+normalizedProgress*360))
        }
        .padding()
    }
}

struct CircleProgressViewPreviewContainer: View {
    @State private var progress: Double = 0.7
    @State private var padding: Double = 80.0
    @State private var showGlow: Bool = false
    @State private var lighterTailColor: Bool = true

    var body: some View {
        VStack(spacing: 24) {
            CircleProgressView(progress: progress, progressStyle: .gradient(Color.surfProgressGradient), enableGlow: showGlow, enableLighterTailColor: lighterTailColor)
                .padding(padding)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )

            Slider(value: $progress, in: 0...3)
                .padding(.horizontal)
            
            Divider().frame(height: 5).overlay(.gray).clipShape(.capsule)
            
            Slider(value: $padding, in: 0...80)
                .padding(.horizontal)
            
            Divider().frame(height: 5).overlay(.gray).clipShape(.capsule)
            
            Toggle("Show glow", isOn: $showGlow).foregroundStyle(.green)
            
            Divider().frame(height: 5).overlay(.gray).clipShape(.capsule)
            
            Toggle("Lighter tail color", isOn: $lighterTailColor).foregroundStyle(.green)
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    CircleProgressViewPreviewContainer()
}
