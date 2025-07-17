import SwiftUI

final class Settings: ObservableObject {
    static let shared = Settings()
    
    @AppStorage("accentColor") private var storedAccentRaw: String = AccentColor.gold.rawValue
        
    @Published var accentColor: AccentColor = .gold {
        didSet { storedAccentRaw = accentColor.rawValue }
    }
    
    private init() {
        accentColor = AccentColor(rawValue: storedAccentRaw) ?? .gold
    }
    
    @AppStorage("digraph") var digraph: Bool = true
    @AppStorage("hapticOn") var hapticOn: Bool = true
    @AppStorage("translatingToAurebesh") var translatingToAurebesh: Bool = false
    @AppStorage("aurebeshFontSize") var aurebeshFontSize: Double = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.6
    @AppStorage("useSystemFontSize") var useSystemFontSize: Bool = true
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @AppStorage("aurebeshFont") var aurebeshFont: String = "AurebeshBasicDigraph"
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
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "accentColor": self.accentColor.rawValue,
            "digraph": self.digraph,
        ]
    }

    func update(from dict: [String: Any]) {
        if let accentColor = dict["accentColor"] as? String,
           let accentColorValue = AccentColor(rawValue: accentColor) {
            self.accentColor = accentColorValue
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

let accentColors: [AccentColor] = AccentColor.allCases
