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
                        .stroke(settings.colorAccent.color, lineWidth: 1)
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
    
    private func columnWidth(for textStyle: UIFont.TextStyle, extra: CGFloat = 4, sample: String? = nil) -> CGFloat {
        var sampleString = "M" as NSString
        if let sample = sample { sampleString = sample as NSString }
        let font = UIFont.preferredFont(forTextStyle: textStyle)
        return ceil(sampleString.size(withAttributes: [.font: font]).width) + extra
    }

    private var glyphWidth: CGFloat {
        columnWidth(for: .title3)
    }
    
    private var dashWidth: CGFloat {
        columnWidth(for: .headline, extra: 0)
    }
    
    private var digraphPrefixWidth: CGFloat {
        columnWidth(for: .title3, extra: 4, sample: "( OOO )")
    }
    
    private var digraphLatinWidth: CGFloat {
        columnWidth(for: .title3, extra: 4, sample: "MM")
    }
    
    @ViewBuilder
    private func alphabetRows(_ data: [LetterData]) -> some View {
        ForEach(data) { letter in
            HStack(alignment: .firstTextBaseline) {
                #if !os(watchOS)
                Text(letter.symbol.lowercased())
                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundColor(settings.colorAccent.color)
                    .frame(width: glyphWidth, alignment: .center)
                
                Text("-")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: dashWidth)
                
                Text(letter.symbol)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(.top, 1)
                    .frame(width: glyphWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                #else
                Text(letter.symbol.lowercased())
                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundColor(settings.colorAccent.color)
                    .frame(width: glyphWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.symbol)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(.top, 1)
                    .frame(width: glyphWidth, alignment: .center)
                #endif
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(settings.colorAccent.color.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
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
    private func alphabetRows(_ data: [DigraphData]) -> some View {
        ForEach(data) { letter in
            HStack(alignment: .firstTextBaseline) {
                #if !os(watchOS)
                Text(letter.symbolFont)
                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundColor(settings.colorAccent.color)
                    .frame(width: glyphWidth, alignment: .center)
                
                HStack(spacing: 0) {
                    Text("( ")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(letter.symbolOutput.lowercased())
                        .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                        .foregroundColor(settings.colorAccent.color)

                    Text(" )")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(width: digraphPrefixWidth, alignment: .center)
                
                Text("-")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: dashWidth)
                
                Text(letter.symbolOutput)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(.top, 1)
                    .frame(width: digraphLatinWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                #else
                Text(letter.symbolFont)
                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundColor(settings.colorAccent.color)
                    .frame(width: glyphWidth, alignment: .center)
                
                Spacer()
                
                Text(letter.symbolOutput)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(.top, 1)
                    .frame(width: digraphLatinWidth, alignment: .center)
                #endif
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(settings.colorAccent.color.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
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
                #if !os(watchOS)
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(settings.colorAccent.color, lineWidth: 1)
                            .cornerRadius(10)
                        
                        VStack {
                            Text("Aurebesh Alphabet")
                                .font(.title3)
                                .foregroundColor(settings.colorAccent.color)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text("aurebesh alphabet")
                                .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                                .foregroundColor(settings.colorAccent.color)
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
                    $0.symbolOutput.lowercased().contains(searchText.lowercased()) ||
                    $0.symbolOutput.lowercased().first == searchText.lowercased().first ||
                    $0.symbolFont.lowercased().first == searchText.lowercased().first ||
                    $0.name.lowercased().first == searchText.lowercased().first
                }
                
                if settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina" && !filteredDigraphLetters.isEmpty {
                    Section(header: Text("DIGRAPH LETTERS")) {
                        alphabetRows(filteredDigraphLetters)
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
                    Section(header: Text("SPECIAL LETTERS")) {
                        alphabetRows(filteredSpecialLetters)
                    }
                }
                
                if searchText.isEmpty {
                    Section(header: Text("AUREBESH EXPLANATION")) {
                        Group {
                            Text("Aurebesh is the standard script for writing Galactic Basic (English), the most common language in the galaxy. Its name comes from the first two letters: \"Aurek\" and \"Besh,\" much like the origins of other galactic scripts. Aurebesh is typically written from left to right, but can also be written from top to bottom too.")
                            
                            Text("Each symbol in Aurebesh corresponds directly to a letter in English, making it easy to transcribe. It also includes digraph—characters representing two-letter combinations like \"ch,\" \"ae,\" or \"th.\" However, these digraphs are rare and appear only in specific versions, like Standard Aurebesh.")
                            
                            Text("Aurebesh is found everywhere—on control panels, digital interfaces, signage, and official records. It unifies communication across countless interstellar worlds, cementing its place as an essential galactic script.")
                            
                            Link("Learn More about Aurebesh on Wookieepedia", destination: URL(string: "https://starwars.fandom.com/wiki/Aurebesh")!)
                                .foregroundColor(settings.colorAccent.color)
                        }
                        .font(.body)
                    }
                }
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
                .background(settings.colorAccent.color.opacity(0.1))
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
                    Text(letter.symbol.lowercased())
                        .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                        .foregroundColor(settings.colorAccent.color)
                    Text(letter.symbol)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 1)
                }
            }
            if settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina" {
                ForEach(digraphLetters) { letter in
                    VStack {
                        Text(letter.symbolFont)
                            .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                            .foregroundColor(settings.colorAccent.color)
                        Text(letter.symbolOutput)
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
                    Text(letter.symbol.lowercased())
                        .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                        .foregroundColor(settings.colorAccent.color)
                    Text(letter.symbol)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 1)
                }
            }
            if settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina" {
                ForEach(digraphLetters) { letter in
                    VStack {
                        Text(letter.symbolFont)
                            .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                            .foregroundColor(settings.colorAccent.color)
                        Text(letter.symbolOutput)
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
