import SwiftUI
import StoreKit

@main
struct AurebeshTranslatorApp: App {
    @StateObject private var settings = Settings.shared
    
    @State private var isLaunching = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLaunching {
                    LaunchScreen(isLaunching: $isLaunching)
                } else if settings.firstLaunch {
                    SplashScreen()
                } else {
                    TabView {
                        TranslateView()
                            .tabItem {
                                Image(systemName: "switch.2")
                                Text("Translate")
                            }
                        
                        AlphabetView()
                            .tabItem {
                                Image(systemName: "textformat.alt")
                                Text("Alphabet")
                            }
                        
                        SettingsView()
                            .tabItem {
                                Image(systemName: "gearshape")
                                Text("Settings")
                            }
                    }
                }
            }
            .environmentObject(settings)
            .accentColor(settings.accentColor.color)
            .tint(settings.accentColor.color)
            .preferredColorScheme(settings.colorScheme)
            .transition(.opacity)
            .animation(.easeInOut, value: isLaunching)
            .animation(.easeInOut, value: settings.firstLaunch)
            .appReviewPrompt()
        }
        .onChange(of: settings.digraph) { on in
            withAnimation(.smooth) {
                let base = settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "")
                settings.aurebeshFont = base + (on ? "Digraph" : "")
            }
        }
    }
}
