import SwiftUI

struct StartupSplash: View {
    @EnvironmentObject var settings: AppSettings
    @State private var scale = 0.78
    @State private var glow = false
    @State private var sweep = false
    @State private var fadeText = false
    @State private var tireSpin = false
    @State private var smoke = false

    var body: some View {
        ZStack {
            AppBackground()

            if settings.tireStartupAnimation {
                tireBurnoutIntro
            } else {
                ringIntro
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.05, dampingFraction: 0.74)) { scale = 1.0 }
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) { glow = true }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { fadeText = true }
            withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) { sweep = true }
            withAnimation(.linear(duration: 0.55).repeatForever(autoreverses: false)) { tireSpin = true }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { smoke = true }
        }
    }

    private var ringIntro: some View {
        ZStack {
            Circle()
                .fill(.cyan.opacity(glow ? 0.30 : 0.09))
                .blur(radius: 105)
                .frame(width: glow ? 500 : 260)

            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .trim(from: 0.05, to: 0.32)
                        .stroke(.cyan.opacity(0.16), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        .frame(width: CGFloat(240 + index * 70), height: CGFloat(240 + index * 70))
                        .rotationEffect(.degrees(sweep ? 360 + Double(index * 55) : Double(index * 55)))
                }

                Circle()
                    .stroke(.white.opacity(glow ? 0.10 : 0.04), lineWidth: 1)
                    .frame(width: glow ? 420 : 280)
            }

            VStack(spacing: 20) {
                AptumLogoImage()
                    .frame(width: 340, height: 122)
                    .scaleEffect(scale)
                    .shadow(color: .cyan.opacity(glow ? 0.58 : 0.18), radius: glow ? 36 : 12)

                Text("Connecting electric drive")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.cyan.opacity(fadeText ? 0.95 : 0.45))
            }
        }
    }

    private var tireBurnoutIntro: some View {
        ZStack {
            Circle()
                .fill(.cyan.opacity(glow ? 0.24 : 0.08))
                .blur(radius: 110)
                .frame(width: glow ? 520 : 280)

            VStack(spacing: 22) {
                ZStack {
                    ForEach(0..<7, id: \.self) { i in
                        Capsule()
                            .fill(.white.opacity(smoke ? 0.18 : 0.06))
                            .frame(width: CGFloat(80 + i * 18), height: CGFloat(18 + i * 3))
                            .blur(radius: CGFloat(8 + i))
                            .offset(x: CGFloat(-90 - i * 18), y: CGFloat(34 - i * 8))
                            .scaleEffect(smoke ? 1.2 : 0.85)
                    }

                    Circle()
                        .stroke(.white.opacity(0.16), lineWidth: 20)
                        .frame(width: 140, height: 140)
                        .shadow(color: .cyan.opacity(0.45), radius: 22)

                    Circle()
                        .stroke(.cyan.opacity(0.85), style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [18, 12]))
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(tireSpin ? 360 : 0))

                    ForEach(0..<8, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.white.opacity(0.42))
                            .frame(width: 8, height: 50)
                            .offset(y: -34)
                            .rotationEffect(.degrees(Double(i) * 45 + (tireSpin ? 360 : 0)))
                    }

                    Circle()
                        .fill(.black.opacity(0.55))
                        .frame(width: 72, height: 72)
                        .overlay(Circle().stroke(.cyan.opacity(0.35), lineWidth: 2))
                }

                AptumLogoImage()
                    .frame(width: 330, height: 112)
                    .scaleEffect(scale)
                    .shadow(color: .cyan.opacity(glow ? 0.55 : 0.15), radius: glow ? 36 : 12)

                Text("Traction systems online")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.cyan.opacity(fadeText ? 0.95 : 0.45))
            }
        }
    }
}
