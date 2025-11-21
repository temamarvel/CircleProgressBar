import SwiftUI

public struct CircleProgressView: View {
    
    let progress: Double
    private var normalizedProgress: Double {
        guard progress > 0 else { return 0 }
        if progress == 1.0 { return 1 }
        return progress.truncatingRemainder(dividingBy: 1)
    }
    private var isFirstLap: Bool {
        return progress <= 0.98
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 30)
                .opacity(0.3)
                .foregroundColor(Color(UIColor.systemGray3))

            if !isFirstLap {
                withAnimation(){
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 30))
                        .foregroundColor(Color(UIColor.systemGreen))

                }
            }

            Circle()
                .trim(from: CGFloat(abs((min(normalizedProgress, 1.0))-0.001)), to: CGFloat(abs((min(normalizedProgress, 1.0))-0.0005)))
                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(UIColor.systemGreen))
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
                    lineWidth: 10,
                    lineCap: .round,
                    lineJoin: .round))
                .foregroundStyle(.angularGradient(
                    colors: [.green, .red],
                    center: .center,
                    startAngle: .degrees(-10),
                    endAngle: .degrees(350)
                ))
                .rotationEffect(.degrees(isFirstLap ? -90.0 : -180.0+normalizedProgress*360))


            
        }
        .padding()
    }
}
