import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var settings: Settings
    
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Hello There! Welcome to Aurebesh Translator, your quick and easy tool for translating between English and Aurebesh.\n\nFor a more immersive experience, check out Datapad | Aurebesh Translator. It has all the features of this app plus a galactic-themed UI, widgets, complications, and support for three types of Aurebesh.\n\nDatapad also offers custom fonts, is powered by unique crystals, and now includes an Aurebesh keyboard that can be used inside and outside the app!\n\nBoth apps are ad-free and keep your data private.")
                        .font(.title)
                        .minimumScaleFactor(0.25)
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
                        .frame(maxWidth: 300, maxHeight: 300)
                        .minimumScaleFactor(0.5)
                        .cornerRadius(10)
                        .padding()
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
                            .background(settings.colorAccent.color.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.colorAccent.color, lineWidth: 5)
                                    .shadow(color: settings.colorAccent.color, radius: 10, x: 0.0, y: 0.0)
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
                            .background(settings.colorAccent.color.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.colorAccent.color, lineWidth: 5)
                                    .shadow(color: settings.colorAccent.color, radius: 10, x: 0.0, y: 0.0)
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
