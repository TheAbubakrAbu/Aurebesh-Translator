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
            return "Normal"
        case .digraph:
            return "Digraph"
        case .special:
            return "Special"
        }
    }
    
    var body: some View {
        VStack {
            #if os(watchOS)
            ScrollView {
                HStack {
                    Text(settings.inputText.isEmpty ? "aurebesh" : settings.inputText)
                        .font(.custom(settings.aurebeshFont, size: settings.aurebeshFontSize))
                        .foregroundColor(settings.inputText.isEmpty ? .secondary : settings.accentColor.color)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
            )
            
            Spacer()
            
            TextField("Type here", text: $settings.inputText)
                .multilineTextAlignment(.leading)
                .font(.body)
                .cornerRadius(10)
                .background(settings.accentColor.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
                )
            #else
            CustomTextEditor(text: $settings.inputText, aurebeshMode: true)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
                )
                .animation(.smooth, value: settings.translatingToAurebesh)
                .animation(.smooth, value: settings.inputText)
            
            CustomTextEditor(text: $settings.inputText, aurebeshMode: false)
                .textCase(.uppercase)
                .background(settings.accentColor.color.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
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
                                                .foregroundColor(settings.accentColor.color)
                                        } else if letter == "AC" {
                                            Image(systemName: "xmark.app.fill")
                                                .font(.title)
                                                .foregroundColor(settings.accentColor.color)
                                        } else {
                                            Text(showEnglish ? letter.uppercased() : letter)
                                                .contentShape(Rectangle())
                                                .padding(.leading, settings.aurebeshFont.contains("AurebeshBasic") && !showEnglish ? 2 : 0)
                                                .padding(.top, settings.aurebeshFont.contains("AurebeshBasic") && !showEnglish ? 2 : 0)
                                                .foregroundColor(.primary)
                                                .font(showEnglish
                                                      ? .largeTitle
                                                      : .custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
                                                )
                                        }
                                    }
                                    .padding(10)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.25)
                                }
                            }
                            .frame(width: buttonSize, height: buttonSize)
                            .background(settings.accentColor.color.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
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
                                    if settings.digraph && (settings.aurebeshFont.contains("Aurebesh")) {
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
                                .background(settings.accentColor.color.opacity(0.2))
                                .foregroundColor(settings.accentColor.color)
                                .cornerRadius(10)
                                .shadow(color: settings.accentColor.color.opacity(0.25), radius: 10, x: 0.0, y: 0.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.accentColor.color, lineWidth: 5)
                                        .shadow(color: settings.accentColor.color, radius: 10, x: 0.0, y: 0.0)
                                        .blur(radius: 5)
                                        .opacity(0.25)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
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
                            
                            if buttonState != .digraph && settings.digraph && settings.aurebeshFont.contains("Aurebesh") {
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
                                .foregroundColor(settings.accentColor.color.opacity(0.1))
                                .background(settings.accentColor.color.opacity(0.1))
                                .frame(width: buttonSize * 3, height: buttonSize)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                            
                            showEnglish.toggle()
                        }) {
                            Text(showEnglish ? "English" : "Aurebesh")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .padding(15)
                                .lineLimit(1)
                                .minimumScaleFactor(0.25)
                                .frame(width: buttonSize * 2 + spacing, height: buttonSize)
                                .background(settings.accentColor.color.opacity(0.2))
                                .foregroundColor(settings.accentColor.color)
                                .cornerRadius(10)
                                .shadow(color: settings.accentColor.color.opacity(0.25), radius: 10, x: 0.0, y: 0.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.accentColor.color, lineWidth: 5)
                                        .shadow(color: settings.accentColor.color, radius: 10, x: 0.0, y: 0.0)
                                        .blur(radius: 5)
                                        .opacity(0.25)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                }
                .animation(.smooth, value: settings.translatingToAurebesh)
                .animation(.smooth, value: buttonState)
                .animation(.smooth, value: showEnglish)
            }
            
            if !keyboardObserver.isKeyboardVisible {
                Picker("Keyboard Type", selection: $settings.translatingToAurebesh.animation(.smooth)) {
                    Text("Encoder").tag(true)
                    Text("Decoder").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(settings.accentColor.color.opacity(0.2))
                .foregroundColor(settings.accentColor.color)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.accentColor.color, lineWidth: 5)
                        .blur(radius: 5)
                        .opacity(0.35)
                )
                .padding(.top, 6)
            }
            #endif
        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: 800)
        .onChange(of: settings.digraph) { newValue in
            if !newValue || !settings.aurebeshFont.contains("Aurebesh") {
                if buttonState == .digraph {
                    buttonState = .normal
                }
            }
        }
        .onChange(of: settings.aurebeshFont) { newValue in
            if !settings.digraph || !newValue.contains("Aurebesh") {
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
