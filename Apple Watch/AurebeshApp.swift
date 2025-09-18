import SwiftUI

@main
struct AurebeshWatchApp: App {
    @StateObject private var settings = Settings.shared
    
    @State private var isLaunching = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLaunching {
                    LaunchScreen(isLaunching: $isLaunching)
                } else {
                    TabView {
                        TranslateView()
                        
                        AlphabetView()
                        
                        SettingsView()
                    }
                }
            }
            .environmentObject(settings)
            .accentColor(settings.accentColor.color)
            .tint(settings.accentColor.color)
            .background(.black)
            .preferredColorScheme(.dark)
        }
        .onChange(of: settings.digraph) { on in
            withAnimation(.smooth) {
                let base = settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "")
                settings.aurebeshFont = base + (on ? "Digraph" : "")
            }
        }
    }
}
