import SwiftUI
import WatchConnectivity

@main
struct AurebeshTranslatorApp: App {
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
            .accentColor(settings.colorAccent.color)
            .preferredColorScheme(settings.colorScheme)
            .transition(.opacity)
            .animation(.easeInOut, value: settings.firstLaunch)
        }
        .onChange(of: settings.colorAccent) { _ in
            sendMessageToWatch()
        }
        .onChange(of: settings.digraph) { _ in
            sendMessageToWatch()
        }
    }
    
    private func sendMessageToWatch() {
        guard WCSession.default.isPaired else {
            print("No Apple Watch is paired")
            return
        }
        
        let settingsData = settings.dictionaryRepresentation()
        let message = ["settings": settingsData]

        if WCSession.default.isReachable {
            print("Watch is reachable. Sending message to watch: \(message)")

            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message to watch: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable. Transferring user info to watch: \(message)")
            WCSession.default.transferUserInfo(message)
        }
    }
}

struct DismissKeyboardOnScrollModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 16.0, *) {
                content
                    .scrollDismissesKeyboard(.immediately)
            } else {
                content
                    .gesture(
                        DragGesture().onChanged { _ in
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    )
            }
        }
    }
}

extension View {
    func dismissKeyboardOnScroll() -> some View {
        self.modifier(DismissKeyboardOnScrollModifier())
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    var onSearchButtonClicked: (() -> Void)?

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()

            text = ""
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        searchBar.autocorrectionType = .no
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.text = searchBar.text ?? ""
        }
    }
}
