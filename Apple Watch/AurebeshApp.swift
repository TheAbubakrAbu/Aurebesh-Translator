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
            .accentColor(settings.colorAccent.color)
            .tint(settings.colorAccent.color)
            .background(.black)
            .preferredColorScheme(.dark)
        }
        .onChange(of: settings.colorAccent) { newValue in
            sendMessageToPhone()
        }
        .onChange(of: settings.digraph) { newValue in
            sendMessageToPhone()
        }
    }
    
    func sendMessageToPhone() {
        let settingsData = settings.dictionaryRepresentation()
        let message = ["settings": settingsData]

        if WCSession.default.isReachable {
            print("Phone is reachable. Sending message to phone: \(message)")
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message to phone: \(error.localizedDescription)")
            }
        } else {
            print("Phone is not reachable. Transferring user info to phone: \(message)")
            WCSession.default.transferUserInfo(message)
        }
    }
}
