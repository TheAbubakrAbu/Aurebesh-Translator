import SwiftUI
import WatchConnectivity

@main
struct AurebeshWatchApp: App {
    @StateObject private var settings = Settings.shared
    
    @State private var isLaunching = true
    
    init() {
        _ = WatchConnectivityManager.shared
    }

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
        .onChange(of: settings.accentColor) { _ in
            sendMessageToPhone()
        }
        .onChange(of: settings.digraph) { on in
            sendMessageToPhone()
            
            withAnimation(.smooth) {
                let base = settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "")
                settings.aurebeshFont = base + (on ? "Digraph" : "")
            }
        }
    }
    
    func sendMessageToPhone() {
        let settingsData = settings.dictionaryRepresentation()
        let message = ["settings": settingsData]

        if WCSession.default.isReachable {
            logger.debug("Phone is reachable. Sending message to phone: \(message)")
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                logger.debug("Error sending message to phone: \(error.localizedDescription)")
            }
        } else {
            logger.debug("Phone is not reachable. Transferring user info to phone: \(message)")
            WCSession.default.transferUserInfo(message)
        }
    }
}
