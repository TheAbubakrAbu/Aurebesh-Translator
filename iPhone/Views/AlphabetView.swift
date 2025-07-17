import SwiftUI

struct AlphabetView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        #if !os(watchOS)
        NavigationView {
            AlphabetList()
                .environmentObject(settings)
                .navigationTitle("Aurebesh Translator")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        #else
        NavigationView {
            List {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.accentColor.color, lineWidth: 1)
                        .cornerRadius(10)
                    VStack {
                        AlphabetImage()
                            .environmentObject(settings)
                    }
                    .padding()
                }
                .padding(.vertical, 11)
            }
            .environmentObject(settings)
            .navigationTitle("Alphabet")
        }
        
        NavigationView {
            AlphabetList()
                .environmentObject(settings)
                .navigationTitle("Letters")
        }
        #endif
    }
}

struct AlphabetList: View {
    @EnvironmentObject var settings: Settings
    
    @State private var searchText: String = ""
    
    private func columnWidth(for textStyle: UIFont.TextStyle, extra: CGFloat = 4, sample: String? = nil, fontName: String? = nil) -> CGFloat {
        let sampleString = (sample ?? "M") as NSString
        let font: UIFont

        if let fontName = fontName, let customFont = UIFont(name: fontName, size: UIFont.preferredFont(forTextStyle: textStyle).pointSize) {
            font = customFont
        } else {
            font = UIFont.preferredFont(forTextStyle: textStyle)
        }

        return ceil(sampleString.size(withAttributes: [.font: font]).width) + extra
    }

    private var glyphWidth: CGFloat {
        columnWidth(for: .title3, extra: 0, sample: "WI", fontName: settings.aurebeshFont)
    }
    
    private var dashWidth: CGFloat {
        columnWidth(for: .headline, extra: 0, sample: "-")
    }
    
    private var digraphPrefixWidth: CGFloat {
        columnWidth(for: .title3, extra: 4, sample: "(WW )", fontName: settings.aurebeshFont)
    }
    
    private var digraphLatinWidth: CGFloat {
        columnWidth(for: .title3, extra: 4, sample: "WW")
    }
    
    @ViewBuilder
    private func alphabetRows(_ data: [LetterData]) -> some View {
        ForEach(data) { letter in
            HStack(alignment: .center) {
                #if !os(watchOS)
                Text(letter.symbol)
                    .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundColor(settings.accentColor.color)
                    .frame(width: glyphWidth, alignment: .center)
                    .padding(.top, 2)
                
                Text("-")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: dashWidth)
                
                Text(letter.symbol)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .frame(width: glyphWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                #else
                Text(letter.symbol)
                    .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundColor(settings.accentColor.color)
                    .frame(width: glyphWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.symbol)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .frame(width: glyphWidth, alignment: .center)
                #endif
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(settings.accentColor.color.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
            )
            #if !os(watchOS)
            .padding(.vertical, -8)
            .listRowSeparator(.hidden, edges: .all)
            .contextMenu {
                Button {
                    if settings.hapticOn {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    UIPasteboard.general.string = letter.name
                } label: {
                    Label("Copy Aurebesh Name", systemImage: "doc.on.doc")
                }
            }
            #endif
        }
    }

    @ViewBuilder
    private func alphabetRows(_ data: [LetterData], digraph: Bool) -> some View {
        ForEach(data) { letter in
            HStack(alignment: .center) {
                #if !os(watchOS)
                Text(letter.symbol)
                    .font(.custom(
                        settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "") + "Digraph",
                        size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
                    )
                    .foregroundColor(settings.accentColor.color)
                    .frame(width: glyphWidth, alignment: .center)
                    .padding(.top, 2)
                
                HStack(spacing: 0) {
                    Text("( ")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    let characters = Array(letter.symbol)

                    if characters.count >= 2 {
                        Text(String(characters[0]))
                            .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                            .foregroundColor(settings.accentColor.color)
                        
                        Text(String(characters[1]))
                            .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                            .foregroundColor(settings.accentColor.color)
                    }

                    Text(" )")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(width: digraphPrefixWidth, alignment: .center)
                
                Text("-")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: dashWidth)
                
                Text(letter.symbol)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .frame(width: digraphLatinWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                #else
                Text(letter.symbol)
                    .font(.custom(
                        settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "") + "Digraph",
                        size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
                    )
                    .foregroundColor(settings.accentColor.color)
                    .frame(width: glyphWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.symbol)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(.top, 1)
                    .frame(width: digraphLatinWidth, alignment: .center)
                #endif
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(settings.accentColor.color.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.accentColor.color.opacity(0.4), lineWidth: 1)
            )
            #if !os(watchOS)
            .padding(.vertical, -8)
            .listRowSeparator(.hidden, edges: .all)
            .contextMenu {
                Button {
                    if settings.hapticOn {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    UIPasteboard.general.string = letter.name
                } label: {
                    Label("Copy Aurebesh Name", systemImage: "doc.on.doc")
                }
            }
            #endif
        }
    }
    
    var body: some View {
        VStack {
            List {
                Group {
                    #if !os(watchOS)
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(settings.accentColor.color, lineWidth: 1)
                                .cornerRadius(10)
                            
                            VStack {
                                Text("Aurebesh Alphabet")
                                    .font(.title3)
                                    .foregroundColor(settings.accentColor.color)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                Text("Aurebesh Alphabet")
                                    .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                                    .foregroundColor(settings.accentColor.color)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom)
                                
                                AlphabetImage()
                                    .environmentObject(settings)
                            }
                            .padding()
                        }
                    }
                    .listRowSeparator(.hidden)
                    #endif
                    
                    let filteredAurebeshLetters = aurebeshLetters.filter {
                        searchText.isEmpty ? true :
                        $0.name.lowercased().contains(searchText.lowercased()) ||
                        $0.symbol.lowercased().contains(searchText.lowercased()) ||
                        $0.symbol.lowercased().first == searchText.lowercased().first
                    }
                    
                    if !filteredAurebeshLetters.isEmpty {
                        Section(header: Text("STANDARD LETTERS")) {
                            alphabetRows(filteredAurebeshLetters)
                        }
                    }
                    
                    let filteredDigraphLetters = digraphLetters.filter {
                        searchText.isEmpty ? true :
                        $0.name.lowercased().contains(searchText.lowercased()) ||
                        $0.symbol.lowercased().contains(searchText.lowercased()) ||
                        $0.symbol.lowercased().first == searchText.lowercased().first ||
                        $0.symbol.lowercased().first == searchText.lowercased().first ||
                        $0.name.lowercased().first == searchText.lowercased().first
                    }
                    
                    if settings.aurebeshFont.contains("Aurebesh") && !filteredDigraphLetters.isEmpty {
                        Section(header: Text("DIGRAPH LETTERS")) {
                            alphabetRows(filteredDigraphLetters, digraph: true)
                        }
                    }
                    
                    let filteredNumberLetters = numberLetters.filter {
                        searchText.isEmpty ? true :
                        $0.name.lowercased().contains(searchText.lowercased())
                    }
                    
                    if !filteredNumberLetters.isEmpty {
                        Section(header: Text("NUMBERS")) {
                            alphabetRows(filteredNumberLetters)
                        }
                    }
                    
                    let filteredSpecialLetters = specialAlphabetLetters.filter {
                        searchText.isEmpty ? true :
                        $0.name.lowercased().contains(searchText.lowercased())
                    }
                    
                    if !filteredSpecialLetters.isEmpty {
                        Section(header: Text("SPECIAL CHARACTERS")) {
                            alphabetRows(filteredSpecialLetters)
                        }
                    }
                    
                    if searchText.isEmpty {
                        Section(header: Text("AUREBESH EXPLANATION")) {
                            Group {
                                Text("Aurebesh is the standard script for Galactic Basic (English), the most common language in the galaxy. Named after its first two letters, \"Aurek\" and \"Besh,\" it's usually written left to right but can also appear top to bottom.")

                                Text("Each symbol matches a letter in English, making it easy to transcribe. Aurebesh also supports digraphs like \"ch,\" \"ae,\" and \"th,\" though these are rare. Digraph support can be customized in the System Module.")
                                
                                Text("From control panels to signage, Aurebesh is everywhere, uniting communication across countless interstellar worlds.")
                                
                                Link("Learn More about Aurebesh on Wookieepedia", destination: URL(string: "https://starwars.fandom.com/wiki/Aurebesh")!)
                                    .foregroundColor(settings.accentColor.color)
                            }
                            .font(.body)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            #if !os(watchOS)
            .listStyle(.plain)
            .dismissKeyboardOnScroll()
            #else
            .searchable(text: $searchText)
            #endif
            .preferredColorScheme(settings.colorScheme)
            #if !os(watchOS)
            SearchBar(text: $searchText.animation(.easeInOut))
                .environmentObject(settings)
                .listRowSeparator(.hidden)
                .background(settings.accentColor.color.opacity(0.1))
                .padding(.horizontal, 8)
            #endif
        }
    }
}

struct AlphabetImage: View {
    @EnvironmentObject var settings: Settings
        
    var body: some View {
        #if !os(watchOS)
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ], spacing: 12) {
            ForEach(aurebeshLetters) { letter in
                VStack {
                    Text(letter.symbol)
                        .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                        .foregroundColor(settings.accentColor.color)
                    
                    Text(letter.symbol)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 1)
                }
            }
            if settings.aurebeshFont.contains("Aurebesh") {
                ForEach(digraphLetters) { letter in
                    VStack {
                        Text(letter.symbol)
                            .font(.custom(
                                settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "") + "Digraph",
                                size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
                            )
                            .foregroundColor(settings.accentColor.color)
                        
                        Text(letter.symbol)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 1)
                    }
                }
            }
        }
        #else
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ], spacing: 12) {
            ForEach(aurebeshLetters) { letter in
                VStack {
                    Text(letter.symbol)
                        .font(.custom(settings.aurebeshFont, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                        .foregroundColor(settings.accentColor.color)
                    
                    Text(letter.symbol)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 1)
                }
            }
            if settings.aurebeshFont.contains("Aurebesh") {
                ForEach(digraphLetters) { letter in
                    VStack {
                        Text(letter.symbol)
                            .font(.custom(
                                settings.aurebeshFont.replacingOccurrences(of: "Digraph", with: "") + "Digraph",
                                size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
                            )
                            .foregroundColor(settings.accentColor.color)
                        
                        Text(letter.symbol)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 1)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        #endif
    }
}
