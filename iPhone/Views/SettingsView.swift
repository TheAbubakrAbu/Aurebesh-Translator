import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
        
    var body: some View {
        NavigationView {
            #if !os(watchOS)
            SettingsList()
                .environmentObject(settings)
                .navigationTitle("Aurebesh Translator")
                .navigationBarTitleDisplayMode(.inline)
            #else
            SettingsList()
                .environmentObject(settings)
                .navigationTitle("Settings")
            #endif
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsList: View {
    @EnvironmentObject var settings: Settings
    
    @State private var showingCredits = false
    @State private var showingDatapad = false
        
    var body: some View {
        List {
            Section(header: Text("TRANSLATE SETTINGS")) {
                #if os(watchOS)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Aurebesh Text Size: ")
                            .font(.subheadline)
                        
                        Text("\(Int(settings.aurebeshFontSize))")
                            .font(.subheadline)
                            .foregroundColor(settings.accentColor.color)
                            .padding(.leading, -6)
                    }
                    
                    Stepper(value: $settings.aurebeshFontSize.animation(.smooth), in: 15...50, step: 5) {}
                        .background(settings.accentColor.color.opacity(0.2))
                        .foregroundColor(settings.accentColor.color)
                        .cornerRadius(10)
                        .fixedSize()
                }
                #else
                VStack(alignment: .leading) {
                    HStack {
                        Text("Aurebesh Text Size: ")
                            .font(.subheadline)
                        
                        Text("\(Int(settings.aurebeshFontSize))")
                            .font(.subheadline)
                            .foregroundColor(settings.accentColor.color)
                            .padding(.leading, -6)
                        
                        Spacer()
                        
                        Stepper(value: $settings.aurebeshFontSize.animation(.smooth), in: 15...50, step: 5) {}
                            .background(settings.accentColor.color.opacity(0.2))
                            .foregroundColor(settings.accentColor.color)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.accentColor.color, lineWidth: 5)
                                    .blur(radius: 5)
                                    .opacity(0.5)
                            )
                            .fixedSize()
                    }
                    
                    Slider(value: $settings.aurebeshFontSize.animation(.smooth), in: 15.0...50.0)
                        .padding(.horizontal, 10)
                        .background(settings.accentColor.color.opacity(0.2))
                        .foregroundColor(settings.accentColor.color)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(settings.accentColor.color, lineWidth: 5)
                                .blur(radius: 5)
                                .opacity(0.5)
                        )
                }
                #endif
                
                Toggle("Use System Font Size", isOn: $settings.useSystemFontSize.animation(.smooth))
                    .font(.subheadline)
                    .tint(settings.accentColor.color.opacity(0.5))
                    .onChange(of: settings.useSystemFontSize) { useSystemFontSize in
                        if useSystemFontSize {
                            settings.aurebeshFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5
                        }
                    }
                    .onChange(of: settings.aurebeshFontSize) { newSize in
                        if newSize == UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5 {
                            settings.useSystemFontSize = true
                        } else {
                            settings.useSystemFontSize = false
                        }
                    }
                
                VStack(alignment: .leading) {
                    Toggle("Use Aurebesh Digraphs", isOn: $settings.digraph.animation(.smooth))
                        .font(.subheadline)
                        .tint(settings.accentColor.color.opacity(0.5))
                        .onChange(of: settings.useSystemFontSize) { useSystemFontSize in
                            if useSystemFontSize {
                                settings.aurebeshFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5
                            }
                        }
                    
                    Text("Check out the Alphabet Screen to learn more about digraphs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
                
            Section(header: Text("APPEARANCE SETTINGS")) {
                Toggle("Haptic Feedback", isOn: $settings.hapticOn.animation(.smooth))
                    .font(.subheadline)
                    .tint(settings.accentColor.color.opacity(0.5))
                
                #if !os(watchOS)
                Picker("Color Theme", selection: $settings.colorSchemeString.animation(.smooth)) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
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
                
                Button(action: {
                    settings.hapticFeedback()
                    
                    showingDatapad = true
                }) {
                    Text("Accent colors are now exclusive to Datapad. Tap here to learn more.")
                        .font(.subheadline)
                        .foregroundColor(settings.accentColor.color)
                }
                #else
                Link("Accent colors are now exclusive to Datapad. Tap here to learn more.", destination: URL(string: "https://apps.apple.com/us/app/datapad-aurebesh-translator/id6450498054?platform=iphone")!)
                .font(.subheadline)
                .foregroundColor(settings.accentColor.color)
                #endif
            }
            
            Section(header: Text("CREDITS")) {
                Text("Made by Abubakr Elmallah, who was an 18-year-old college student when this app was made.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 2)
                
                #if !os(watchOS)
                Button(action: {
                    settings.hapticFeedback()
                    
                    showingCredits = true
                }) {
                    HStack {
                        Image(systemName: "scroll.fill")
                        
                        Text("View Credits")
                    }
                    .font(.subheadline)
                    .foregroundColor(settings.accentColor.color)
                }
                .sheet(isPresented: $showingCredits) {
                    CreditsView()
                }
                .sheet(isPresented: $showingDatapad) {
                    SplashScreen()
                }
                
                Button(action: {
                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                    
                    withAnimation(.smooth()) {
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6670201513?action=write-review") {
                            UIApplication.shared.open(url)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "star.bubble.fill")
                        
                        Text("Leave a Review")
                    }
                    .font(.subheadline)
                    .foregroundColor(settings.accentColor.color)
                    .contextMenu {
                        Button(action: {
                            settings.hapticFeedback()
                            
                            UIPasteboard.general.string = "itms-apps://itunes.apple.com/app/id6670201513?action=write-review"
                        }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy Website")
                            }
                        }
                    }
                }
                #endif
                
                HStack {
                    Text("Contact me at: ")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    
                    Text("ammelmallah@icloud.com")
                        .font(.subheadline)
                        .foregroundColor(settings.accentColor.color)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, -4)
                }
                #if !os(watchOS)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = "ammelmallah@icloud.com"
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy Email")
                        }
                    }
                }
                #endif
            }
        }
        .animation(.smooth(duration: 1.0), value: settings.accentColor.color)
    }
}
