import SwiftUI

let keyboardLetters: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "Delete", "AC"]

let keyboardDigraphLetters: [String] = ["ch", "ae", "eo", "kh", "ng", "oo", "sh", "th", "", " ", "{", "}", "Delete", "AC"]

let specialLetters: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "/", ":", ";", "(", ")", "$", "&", "@", "\"", ".", ",", "?", "!", "'", "*", "Delete", "AC"]

struct TranslateView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        NavigationView {
            #if !os(watchOS)
            TranslateList()
                .environmentObject(settings)
                .navigationTitle("Aurebesh Translator")
                .navigationBarTitleDisplayMode(.inline)
            #else
            ScrollView {
                TranslateList()
                    .environmentObject(settings)
                    .navigationTitle("Translate")
            }
            #endif
        }
        .navigationViewStyle(.stack)
    }
}

struct TranslateList: View {
    @EnvironmentObject var settings: Settings
    #if !os(watchOS)
    @StateObject var keyboardObserver = KeyboardObserver()
    #endif
    
    @State var showEnglish: Bool = false

    @State private var buttonState: ButtonState = .normal
    
    enum ButtonState {
        case normal, digraph, special
    }

    var buttonText: String {
        switch buttonState {
        case .normal:
            return "NORMAL"
        case .digraph:
            return "DIGRAPH"
        case .special:
            return "SPECIAL"
        }
    }
        
    var outputText: String {
        var translatedText = settings.inputText.lowercased()

        if settings.digraph && (settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina") {
            for digraphLetter in digraphLetters {
                let regex = try! NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: digraphLetter.symbolOutput.lowercased()), options: [])
                translatedText = regex.stringByReplacingMatches(in: translatedText, options: [], range: NSRange(location: 0, length: translatedText.utf16.count), withTemplate: digraphLetter.symbolFont)
            }
        }

        return translatedText
    }
    
    var outputTextBinding: Binding<String> {
        Binding(
            get: {
                var translated = settings.inputText.lowercased()

                if settings.digraph {
                    for digraph in digraphLetters {
                        let rx = try! NSRegularExpression(
                            pattern: NSRegularExpression.escapedPattern(for: digraph.symbolOutput),
                            options: [.caseInsensitive])
                        translated = rx.stringByReplacingMatches(
                            in: translated,
                            options: [],
                            range: NSRange(location: 0, length: translated.utf16.count),
                            withTemplate: digraph.symbolFont)
                    }
                }
                
                return translated
            },
            set: { newValue in
                var english = newValue

                if settings.digraph {
                    for digraph in digraphLetters {
                        let rx = try! NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: digraph.symbolFont))
                        
                        english = rx.stringByReplacingMatches(
                            in: english,
                            options: [],
                            range: NSRange(location: 0, length: english.utf16.count),
                            withTemplate: digraph.symbolOutput)
                    }
                }

                withAnimation(.smooth) {
                    settings.inputText = english.uppercased()
                }
            }
        )
    }
    
    func digraphLetter(_ letter: String) -> String {
        if settings.digraph && (settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina") {
            for digraphLetter in digraphLetters {
                if letter == digraphLetter.symbolOutput.lowercased() {
                    return digraphLetter.symbolFont
                }
            }
        }
        if letter == " " { return "" }
        return letter
    }
    
    var body: some View {
        VStack {
            #if os(watchOS)
            ScrollView {
                HStack {
                    Text(settings.inputText.isEmpty ? "aurebesh" : outputText)
                        .font(.custom(settings.fontAurebesh, size: settings.fontAurebeshSize))
                        .foregroundColor(settings.inputText.isEmpty ? .secondary : settings.colorAccent.color)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
            )
            
            Spacer()
            
            TextField("Type here", text: $settings.inputText)
                .multilineTextAlignment(.leading)
                .font(.body)
                .cornerRadius(10)
                .background(settings.colorAccent.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                )
            #else
            CustomTextEditor(text: outputTextBinding, placeholder: "type here", aurebeshMode: true)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                )
                .animation(.smooth, value: settings.translatingToAurebesh)
                .animation(.smooth, value: settings.inputText)
            
            CustomTextEditor(text: $settings.inputText, placeholder: "TYPE HERE", aurebeshMode: false)
                .textCase(.uppercase)
                .background(settings.colorAccent.color.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                )
                .animation(.smooth, value: settings.translatingToAurebesh)
                .animation(.smooth, value: settings.inputText)
            
            if !settings.translatingToAurebesh && !keyboardObserver.isKeyboardVisible {
                VStack {
                    let spacing: CGFloat = 8
                    let buttonSize = (min(UIScreen.main.bounds.width, 800) - (spacing * 8)) / 7
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                    ], spacing: spacing) {
                        ForEach(buttonState == .special ? specialLetters : buttonState == .digraph ? keyboardDigraphLetters : keyboardLetters, id: \.self) { letter in
                            Button(action: {
                                if !letter.isEmpty {
                                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                                }
                                
                                withAnimation(.smooth) {
                                    if letter == "Delete" {
                                        if !settings.inputText.isEmpty {
                                            settings.inputText.removeLast()
                                        }
                                    } else if letter == "AC" {
                                        settings.inputText = ""
                                    } else {
                                        if letter != " " { settings.inputText += letter.uppercased() }
                                    }
                                }
                            }) {
                                ZStack {
                                    Color.clear
                                    
                                    Group {
                                        if letter == "Delete" {
                                            Image(systemName: "delete.backward.fill")
                                                .font(.title)
                                                .foregroundColor(settings.colorAccent.color)
                                        } else if letter == "AC" {
                                            Image(systemName: "xmark.app.fill")
                                                .font(.title)
                                                .foregroundColor(settings.colorAccent.color)
                                        } else {
                                            Text(showEnglish ? letter.uppercased() : buttonState == .digraph ? digraphLetter(letter) : letter)
                                                .contentShape(Rectangle())
                                                .padding(.leading, settings.fontAurebesh == "Aurebesh" && !showEnglish ? 2 : 0)
                                                .padding(.top, settings.fontAurebesh == "Aurebesh" && !showEnglish ? 2 : 0)
                                                .foregroundColor(.primary)
                                                .font(showEnglish
                                                      ? .largeTitle
                                                      : .custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
                                                )
                                        }
                                    }
                                    .padding(10)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.25)
                                }
                            }
                            .frame(width: buttonSize, height: buttonSize)
                            .background(settings.colorAccent.color.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                            )
                            .hoverEffect(.highlight)
                        }
                    }
                    .padding(.horizontal, 1)
                    
                    HStack {
                        Button(action: {
                            if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                            
                            withAnimation(.smooth) {
                                switch buttonState {
                                case .normal:
                                    if settings.digraph && (settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina") {
                                        buttonState = .digraph
                                    } else {
                                        buttonState = .special
                                    }
                                case .special:
                                    buttonState = .normal
                                case .digraph:
                                    buttonState = .special
                                }
                            }
                        }) {
                            Text(buttonText)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .padding(15)
                                .lineLimit(1)
                                .minimumScaleFactor(0.25)
                                .frame(width: buttonSize * 2 + spacing, height: buttonSize)
                                .background(settings.colorAccent.color.opacity(0.2))
                                .foregroundColor(settings.colorAccent.color)
                                .cornerRadius(10)
                                .shadow(color: settings.colorAccent.color.opacity(0.25), radius: 10, x: 0.0, y: 0.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.colorAccent.color, lineWidth: 5)
                                        .shadow(color: settings.colorAccent.color, radius: 10, x: 0.0, y: 0.0)
                                        .blur(radius: 5)
                                        .opacity(0.25)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .contextMenu {
                            if buttonState != .normal {
                                Button(action: {
                                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                                    
                                    buttonState = .normal
                                }) {
                                    Text("Normal")
                                }
                            }
                            
                            if buttonState != .digraph && settings.digraph && (settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina") {
                                Button(action: {
                                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                                    
                                    buttonState = .digraph
                                }) {
                                    Text("Digraph")
                                }
                            }
                            
                            if buttonState != .special {
                                Button(action: {
                                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                                    
                                    buttonState = .special
                                }) {
                                    Text("Special")
                                }
                            }
                        }
                        
                        Button(action: {
                            if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                            
                            withAnimation(.smooth) {
                                settings.inputText += " "
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(settings.colorAccent.color.opacity(0.1))
                                .background(settings.colorAccent.color.opacity(0.1))
                                .frame(width: buttonSize * 3, height: buttonSize)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                            
                            showEnglish.toggle()
                        }) {
                            Text(showEnglish ? "ENGLISH" : "AUREBESH")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .padding(15)
                                .lineLimit(1)
                                .minimumScaleFactor(0.25)
                                .frame(width: buttonSize * 2 + spacing, height: buttonSize)
                                .background(settings.colorAccent.color.opacity(0.2))
                                .foregroundColor(settings.colorAccent.color)
                                .cornerRadius(10)
                                .shadow(color: settings.colorAccent.color.opacity(0.25), radius: 10, x: 0.0, y: 0.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.colorAccent.color, lineWidth: 5)
                                        .shadow(color: settings.colorAccent.color, radius: 10, x: 0.0, y: 0.0)
                                        .blur(radius: 5)
                                        .opacity(0.25)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                }
                .animation(.smooth, value: settings.translatingToAurebesh)
                .animation(.smooth, value: buttonState)
                .animation(.smooth, value: showEnglish)
            }
            
            Picker("Keyboard Type", selection: $settings.translatingToAurebesh.animation(.smooth)) {
                Text("Standard").tag(true)
                Text("Galactic").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(settings.colorAccent.color.opacity(0.2))
            .foregroundColor(settings.colorAccent.color)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.colorAccent.color, lineWidth: 5)
                    .blur(radius: 5)
                    .opacity(0.35)
            )
            .padding(.top, 6)
            #endif
        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: 800)
        .onChange(of: settings.digraph) { newValue in
            if !newValue || !(settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina") {
                if buttonState == .digraph {
                    buttonState = .normal
                }
            }
        }
        .onChange(of: settings.fontAurebesh) { newValue in
            if !settings.digraph || !(newValue == "Aurebesh" || newValue == "AurebeshCantina") {
                if buttonState == .digraph {
                    buttonState = .normal
                }
            }
        }
        #if !os(watchOS)
        .dismissKeyboardOnScroll()
        #endif
    }
}
