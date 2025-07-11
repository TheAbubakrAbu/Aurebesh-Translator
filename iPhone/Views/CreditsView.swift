import SwiftUI

struct CreditsView: View {
    @EnvironmentObject var settings: Settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Aurebesh Translator was created by Abubakr Elmallah, who was an 18-year old college student when this app was published on October 22, 2024.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 4)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        Link("abubakrelmallah.com", destination: URL(string: "https://abubakrelmallah.com/")!)
                            .foregroundColor(settings.colorAccent.color)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 4)
                            .padding(.bottom, 12)
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = "https://abubakrelmallah.com/"
                                }) {
                                    HStack {
                                        Image(systemName: "doc.on.doc")
                                        Text("Copy Website")
                                    }
                                }
                            }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(settings.colorAccent.color)
                        .padding(.trailing, -100)
                }
                .listRowSeparator(.hidden)
                
                Section {
                    Link("Check out Datapad | Aurebesh Translator, featuring a galactic-themed UI, widgets, and support for three types of Aurebesh", destination: URL(string: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone")!)
                        .font(.body)
                        .foregroundColor(settings.colorAccent.color)
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone"
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Website")
                                }
                            }
                        }
                    
                    Link("View the first rendition of Datapad/Aurebesh Translator that I made when I was fifteen in AP Computer Science Principles as a sophomore (2021) via code.org", destination: URL(string: "https://studio.code.org/projects/applab/3GTPl_9o0qf9zWutRclvLYYoJRopnjTmVTdm3cXHELc")!)
                        .font(.body)
                        .foregroundColor(settings.colorAccent.color)
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = "https://studio.code.org/projects/applab/3GTPl_9o0qf9zWutRclvLYYoJRopnjTmVTdm3cXHELc"
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Website")
                                }
                            }
                        }
                    
                    Link("View the source code: github.com/TheAbubakrAbu/Aurebesh-Translator", destination: URL(string: "https://github.com/TheAbubakrAbu/Aurebesh-Translator")!)
                        .font(.body)
                        .foregroundColor(settings.colorAccent.color)
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = "https://github.com/TheAbubakrAbu/Aurebesh-Translator"
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Website")
                                }
                            }
                        }
                }
                
                Section {
                    Text("Version 1.4.3")
                        .font(.caption)
                }
                
                Section(header: Text("CREDITS")) {
                    Link("Credit for the Aurebesh font goes to Pixel Sagas", destination: URL(string: "https://www.fonts4free.net/aurebesh-font.html")!)
                        .foregroundColor(settings.colorAccent.color)
                        .font(.body)
                }
                
                Section(header: Text("APPS BY ABUBAKR ELMALLAH")) {
                    ForEach(appsByAbubakr) { app in
                        AppLinkRow(imageName: app.imageName, title: app.title, url: app.url)
                    }
                }

                Section(header: Text("DISCORD BOTS BY ABUBAKR ELMALLAH")) {
                    ForEach(botsByAbubakr) { bot in
                        AppLinkRow(imageName: bot.imageName, title: bot.title, url: bot.url)
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(settings.colorAccent.color)
            .tint(settings.colorAccent.color)
            .navigationTitle("Credits")
        }
    }
}

let appsByAbubakr: [AppItem] = [
    AppItem(imageName: "Al-Adhan", title: "Al-Adhan | Prayer Times", url: "https://apps.apple.com/us/app/al-adhan-prayer-times/id6475015493?platform=iphone"),
    AppItem(imageName: "Al-Islam", title: "Al-Islam | Islamic Pillars", url: "https://apps.apple.com/us/app/al-islam-islamic-pillars/id6449729655?platform=iphone"),
    AppItem(imageName: "Al-Quran", title: "Al-Quran | Beginner Quran", url: "https://apps.apple.com/us/app/al-quran-beginner-quran/id6474894373?platform=iphone"),
    AppItem(imageName: "Aurebesh", title: "Aurebesh Translator", url: "https://apps.apple.com/us/app/aurebesh-translator/id6670201513?platform=iphone"),
    AppItem(imageName: "Datapad", title: "Datapad | Aurebesh Translator", url: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone"),
    AppItem(imageName: "ICOI", title: "Islamic Center of Irvine (ICOI)", url: "https://apps.apple.com/us/app/islamic-center-of-irvine/id6463835936?platform=iphone")
]

let botsByAbubakr: [AppItem] = [
    AppItem(imageName: "SabaccDroid", title: "Sabacc Droid", url: "https://discordbotlist.com/bots/sabaac-droid"),
    AppItem(imageName: "AurebeshDroid", title: "Aurebesh Droid", url: "https://discordbotlist.com/bots/aurebesh-droid")
]

struct AppItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let url: String
}

struct AppLinkRow: View {
    @EnvironmentObject var settings: Settings
    
    var imageName: String
    var title: String
    var url: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .frame(width: 50, height: 50)
                .padding(.trailing, 8)

            Link(title, destination: URL(string: url)!)
                .font(.subheadline)
        }
        .contextMenu {
            Button {
                if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                UIPasteboard.general.string = url
            } label: {
                Label("Copy Website", systemImage: "doc.on.doc")
            }
        }
    }
}
