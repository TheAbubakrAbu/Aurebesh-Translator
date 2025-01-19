import SwiftUI

struct CreditsView: View {
    @EnvironmentObject var settings: Settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                        .foregroundColor(settings.colorAccent.color == .white ? .blue : settings.colorAccent.color)
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
            
            Link("Check out Datapad | Aurebesh Translator, featuring a galactic-themed UI, widgets, and support for three types of Aurebesh", destination: URL(string: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone")!)
                .font(.body)
                .foregroundColor(settings.colorAccent.color)

            Link("Click on this link to view the first rendition of Datapad/Aurebesh Translator that I made when I was fifteen in AP Computer Science Principles as a sophomore (2021 - 2022) via code.org", destination: URL(string: "https://studio.code.org/projects/applab/3GTPl_9o0qf9zWutRclvLYYoJRopnjTmVTdm3cXHELc")!)
                .font(.body)
                .foregroundColor(settings.colorAccent.color)
            
            Section {
                Text("Version 1.2.2")
                    .font(.caption)
            }
            
            Section(header: Text("CREDITS")) {
                Link("Credit for the Aurebesh font goes to Pixel Sagas", destination: URL(string: "https://www.fonts4free.net/aurebesh-font.html")!)
                    .foregroundColor(settings.colorAccent.color)
            }
            .font(.body)
            
            Section(header: Text("APPS BY ABUBAKR ELMALLAH")) {
                HStack {
                    Image("Al-Adhan")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Al-Adhan | Prayer Times", destination: URL(string: "https://apps.apple.com/us/app/al-adhan-prayer-times/id6475015493?platform=iphone")!)
                        .font(.subheadline)
                }
                
                HStack {
                    Image("Al-Islam")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Al-Islam | Islamic Pillars", destination: URL(string: "https://apps.apple.com/us/app/al-islam-islamic-pillars/id6449729655?platform=iphone")!)
                        .font(.subheadline)
                }
                
                HStack {
                    Image("Al-Quran")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Al-Quran | Beginner Quran", destination: URL(string: "https://apps.apple.com/us/app/al-quran-beginner-quran/id6474894373?platform=iphone")!)
                        .font(.subheadline)
                }
                
                HStack {
                    Image("Aurebesh")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Aurebesh Translator", destination: URL(string: "https://apps.apple.com/us/app/aurebesh-translator/id6670201513?platform=iphone")!)
                        .font(.subheadline)
                }
                
                HStack {
                    Image("Datapad")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Datapad | Aurebesh Translator", destination: URL(string: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone")!)
                        .font(.subheadline)
                }
                
                HStack {
                    Image("ICOI")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Islamic Center of Irvine (ICOI)", destination: URL(string: "https://apps.apple.com/us/app/islamic-center-of-irvine/id6463835936?platform=iphone")!)
                        .font(.subheadline)
                }
            }
            
            Section(header: Text("DISCORD BOT BY ABUBAKR ELMALLAH")) {
                HStack {
                    Image("Sabacc")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                    
                    Link("Sabacc Droid", destination: URL(string: "https://discordbotlist.com/bots/sabaac-droid")!)
                        .font(.subheadline)
                }
            }
        }
        .listStyle(.plain)
        .accentColor(settings.colorAccent.color)
    }
}
