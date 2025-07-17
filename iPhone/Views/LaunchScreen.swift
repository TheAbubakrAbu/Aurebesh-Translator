import SwiftUI

struct LaunchScreen: View {
    @EnvironmentObject var settings: Settings

    @Binding var isLaunching: Bool

    @State private var size = 0.6
    @State private var opacity = 0.5
    @State private var gradientSize: CGFloat = 0.0

    @Environment(\.colorScheme) var systemColorScheme
    @Environment(\.customColorScheme) var customColorScheme

    var currentColorScheme: ColorScheme {
        if let colorScheme = settings.colorScheme {
            return colorScheme
        } else {
            return systemColorScheme
        }
    }

    var backgroundColor: Color {
        switch currentColorScheme {
        case .light:
            return Color.white
        case .dark:
            return Color.black
        @unknown default:
            return Color.white
        }
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack {
                VStack {
                    Image("Aurebesh Launch")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 150, height: 150)
                        .padding()
                }
                .foregroundColor(settings.accentColor.color)
                .scaleEffect(size)
                .opacity(opacity)
            }
        }
        .onAppear {
            triggerHapticFeedback()
            
            withAnimation(.easeInOut(duration: 0.75)) {
                size = 1.25
                opacity = 1.0
                gradientSize = 3.0
                
                triggerHapticFeedback()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                triggerHapticFeedback()
                
                withAnimation(.easeOut(duration: 0.75)) {
                    size = 1.0
                    gradientSize = 0.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    triggerHapticFeedback()

                    withAnimation {
                        self.isLaunching = false
                    }
                }
            }
        }
    }
    
    private func triggerHapticFeedback() {
        if settings.hapticOn {
            #if !os(watchOS)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            #else
            if settings.hapticOn { WKInterfaceDevice.current().play(.click) }
            #endif
        }
    }
}
