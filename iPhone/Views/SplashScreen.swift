import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var settings: Settings
    
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("**Hello there!** Welcome to Aurebesh Translator — your quick and easy tool for translating between Galactic Basic and Aurebesh.\n\nFor the full experience, try **Datapad**: a galactic-themed app with **6 Aurebesh fonts**, **7 additional Galactic scripts**, **Aurebesh Tests**, **sharing tools**, and much more — all within a sleek, immersive **galactic interface**.\n\nIt’s ad-free, private, and now includes a system-wide **Aurebesh keyboard** powered by unique crystals.")
                        .font(.title)
                        .minimumScaleFactor(0.35)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(20)
                
                Spacer()
                
                Button(action: {
                    settings.hapticFeedback()
                    
                    withAnimation(.smooth()) {
                        presentationMode.wrappedValue.dismiss()
                        settings.firstLaunch = false
                    }
                    
                    if let url = URL(string: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image("Datapad")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(maxWidth: 250, maxHeight: 250)
                        .minimumScaleFactor(0.25)
                        .padding()
                }
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
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        settings.hapticFeedback()
                        
                        withAnimation(.smooth()) {
                            presentationMode.wrappedValue.dismiss()
                            settings.firstLaunch = false
                        }
                        
                        if let url = URL(string: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Download App")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .background(settings.accentColor.color.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.accentColor.color, lineWidth: 5)
                                    .shadow(color: settings.accentColor.color, radius: 10, x: 0.0, y: 0.0)
                                    .blur(radius: 5)
                                    .opacity(0.5)
                            )
                    }
                    
                    Button(action: {
                        settings.hapticFeedback()
                        
                        withAnimation(.smooth) {
                            presentationMode.wrappedValue.dismiss()
                            settings.firstLaunch = false
                        }
                    }) {
                        Text("Skip Download")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .background(settings.accentColor.color.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.accentColor.color, lineWidth: 5)
                                    .shadow(color: settings.accentColor.color, radius: 10, x: 0.0, y: 0.0)
                                    .blur(radius: 5)
                                    .opacity(0.5)
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 6)
            }
            .navigationTitle("Aurebesh Translator")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}
