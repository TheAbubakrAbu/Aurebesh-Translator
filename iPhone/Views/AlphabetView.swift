import SwiftUI

struct AlphabetView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            #if !os(watchOS)
            AlphabetList()
                .environmentObject(settings)
                .navigationTitle("Aurebesh Translator")
                .navigationBarTitleDisplayMode(.inline)
            #else
            AlphabetList()
                .environmentObject(settings)
                .navigationTitle("Alphabet")
            #endif
        }
        .navigationViewStyle(.stack)
    }
}

struct AlphabetList: View {
    @EnvironmentObject var settings: Settings
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            List {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(settings.colorAccent.color, lineWidth: 1)
                            .cornerRadius(10)
                        
                        VStack {
                            #if !os(watchOS)
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
                            #endif
                            
                            AlphabetImage()
                                .environmentObject(settings)
                        }
                        .padding()
                    }
                    #if os(watchOS)
                    .padding(.vertical, 11)
                    #endif
                }
                #if !os(watchOS)
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
                        ForEach(filteredAurebeshLetters) { letter in
                            HStack {
                                Text(letter.symbol.lowercased())
                                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                                    .foregroundColor(settings.colorAccent.color)
                                
                                #if !os(watchOS)
                                Text(" - ")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                #else
                                Spacer()
                                #endif
                                
                                Text(letter.symbol)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(.top, 1)
                                
                                #if !os(watchOS)
                                Spacer()
                                #endif
                                
                                #if !os(watchOS)
                                Text(letter.name)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
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
                                Button(action: {
                                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                                    
                                    UIPasteboard.general.string = letter.name
                                }) {
                                    Text("Copy Aurebesh Name")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                            #endif
                        }
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
                
                if (settings.fontAurebesh == "Aurebesh" || settings.fontAurebesh == "AurebeshCantina") && !filteredDigraphLetters.isEmpty {
                    Section(header: Text("DIGRAPH LETTERS")) {
                        ForEach(filteredDigraphLetters) { letter in
                            HStack {
                                Text(letter.symbolFont)
                                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                                    .foregroundColor(settings.colorAccent.color)
                                
                                #if !os(watchOS)
                                Text(" (")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(letter.symbolOutput.lowercased())
                                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                                    .foregroundColor(settings.colorAccent.color)
                                
                                Text(")")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(" - ")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                #else
                                Spacer()
                                #endif
                                
                                Text(letter.symbolOutput)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(.top, 1)
                                
                                #if !os(watchOS)
                                Spacer()
                                
                                Text(letter.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
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
                                Button(action: {
                                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                                    
                                    UIPasteboard.general.string = letter.name
                                }) {
                                    Text("Copy Aurebesh Name")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                            #endif
                        }
                    }
                }
                
                let filteredNumberLetters = numberLetters.filter {
                    searchText.isEmpty ? true :
                    $0.name.lowercased().contains(searchText.lowercased())
                }
                
                if !filteredNumberLetters.isEmpty {
                    Section(header: Text("NUMBERS")) {
                        ForEach(filteredNumberLetters) { letter in
                            HStack {
                                Text(letter.symbol.lowercased())
                                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                                    .foregroundColor(settings.colorAccent.color)
                                
                                #if !os(watchOS)
                                Text(" - ")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                #else
                                Spacer()
                                #endif
                                
                                Text(letter.symbol)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(.top, 1)
                                
                                #if !os(watchOS)
                                Spacer()
                                #endif
                                
                                #if !os(watchOS)
                                Text(letter.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
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
                            #endif
                        }
                    }
                }
                
                let filteredSpecialLetters = specialAlphabetLetters.filter {
                    searchText.isEmpty ? true :
                    $0.name.lowercased().contains(searchText.lowercased())
                }
                
                if !filteredSpecialLetters.isEmpty {
                    Section(header: Text("SPECIAL LETTERS")) {
                        ForEach(filteredSpecialLetters) { letter in
                            HStack {
                                Text(letter.symbol.lowercased())
                                    .font(.custom(settings.fontAurebesh, size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                                    .foregroundColor(settings.colorAccent.color)
                                
                                #if !os(watchOS)
                                Text(" - ")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                #else
                                Spacer()
                                #endif
                                
                                Text(letter.symbol)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(.top, 1)
                                
                                #if !os(watchOS)
                                Spacer()
                                #endif
                                
                                #if !os(watchOS)
                                Text(letter.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                #endif
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(settings.colorAccent.color.opacity(0.2))
                            .foregroundColor(settings.colorAccent.color)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.colorAccent.color.opacity(0.4), lineWidth: 1)
                            )
                            #if !os(watchOS)
                            .padding(.vertical, -8)
                            .listRowSeparator(.hidden, edges: .all)
                            #endif
                        }
                    }
                }
                
                if searchText.isEmpty {
                    Section(header: Text("AUREBESH EXPLANATION")) {
                        Group {
                            Text("Aurebesh is the standard script for writing English, the most common language in the galaxy. Its name comes from the first two letters: \"Aurek\" and \"Besh.\" Aurebesh is typically written from left to right, but can also be written from top to bottom too.")
                            
                            Text("Each symbol in Aurebesh corresponds directly to a letter in English, making it easy to transcribe. It also includes digraph—characters representing two-letter combinations like \"ch,\" \"ae,\" or \"th.\" However, these digraphs are rare and appear only in specific versions, such as Standard and Cantina Aurebesh, supported on this app.")
                                                        
                            Text("Aurebesh is found everywhere—on control panels, digital interfaces, signage, and official records. It unifies communication across countless interstellar worlds, cementing its place as an essential galactic script.")
                            
                            Link("Learn More about Aurebesh on Wookieepedia", destination: URL(string: "https://starwars.fandom.com/wiki/Aurebesh")!)
                                .foregroundColor(settings.colorAccent.color == .white ? .blue : settings.colorAccent.color)
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
