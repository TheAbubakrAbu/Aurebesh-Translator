import SwiftUI

class Settings: ObservableObject {
    private var appGroupUserDefaults: UserDefaults?
    static let shared = Settings()
    
    @Published var colorAccent: AccentColor {
        didSet { appGroupUserDefaults?.setValue(colorAccent.rawValue, forKey: "theColorAccent") }
    }
    
    @Published var digraph: Bool {
        didSet { appGroupUserDefaults?.setValue(digraph, forKey: "digraph") }
    }
    
    @AppStorage("hapticOn") var hapticOn: Bool = true
    @AppStorage("translatingToAurebesh") var translatingToAurebesh: Bool = false
    @AppStorage("fontAurebeshSize") var fontAurebeshSize: Double = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.6
    @AppStorage("useSystemFontSize") var useSystemFontSize: Bool = true
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @AppStorage("fontAurebesh") var fontAurebesh: String = "Aurebesh"
    @AppStorage("colorSchemeString") var colorSchemeString: String = "system"
    
    var colorScheme: ColorScheme? {
        get {
            switch colorSchemeString {
            case "light": return .light
            case "dark": return .dark
            default: return nil
            }
        }
        set {
            switch newValue {
            case .light: colorSchemeString = "light"
            case .dark: colorSchemeString = "dark"
            default: colorSchemeString = "system"
            }
        }
    }
    
    @Published var inputText: String = ""
        
    init() {
        self.appGroupUserDefaults = UserDefaults(suiteName: "group.com.Datapad.AppGroup")

        let defaults: [String: Any] = [
            "colorAccent": "gold",
            "digraph": true,
        ]
        appGroupUserDefaults?.register(defaults: defaults)

        self.colorAccent = AccentColor(rawValue: appGroupUserDefaults?.string(forKey: "theColorAccent") ?? "gold") ?? .gold
        self.digraph = appGroupUserDefaults?.bool(forKey: "digraph") ?? true
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "colorAccent": self.colorAccent.rawValue,
            "digraph": self.digraph,
        ]
    }

    func update(from dict: [String: Any]) {
        if let colorAccent = dict["colorAccent"] as? String,
           let colorAccentValue = AccentColor(rawValue: colorAccent) {
            self.colorAccent = colorAccentValue
        }
        if let digraph = dict["digraph"] as? Bool {
            self.digraph = digraph
        }
    }
    
    func hapticFeedback() {
        #if os(iOS)
        if hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
        #else
        if hapticOn { WKInterfaceDevice.current().play(.click) }
        #endif
    }
}

struct CustomColorSchemeKey: EnvironmentKey {
    static let defaultValue: ColorScheme? = nil
}

extension EnvironmentValues {
    var customColorScheme: ColorScheme? {
        get { self[CustomColorSchemeKey.self] }
        set { self[CustomColorSchemeKey.self] = newValue }
    }
}

enum AccentColor: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case red, orange, yellow, green, blue, indigo, cyan, teal, mint, purple, pink, brown, gold

    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .indigo: return .indigo
        case .cyan: return .cyan
        case .teal: return .teal
        case .mint: return .mint
        case .purple: return .purple
        case .pink: return .pink
        case .brown: return .brown
        case .gold: return Color(red: 188/255, green: 157/255, blue: 57/255)
        }
    }
}

let colorAccents: [AccentColor] = AccentColor.allCases
