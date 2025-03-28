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
                        
                        Text("\(Int(settings.fontAurebeshSize))")
                            .font(.subheadline)
                            .foregroundColor(settings.colorAccent.color)
                            .padding(.leading, -6)
                    }
                    
                    Stepper(value: $settings.fontAurebeshSize.animation(.smooth), in: 15...50, step: 5) {}
                        .background(settings.colorAccent.color.opacity(0.2))
                        .foregroundColor(settings.colorAccent.color)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(settings.colorAccent.color, lineWidth: 5)
                                .blur(radius: 5)
                                .opacity(0.35)
                        )
                        .fixedSize()
                }
                #else
                HStack {
                    Text("Aurebesh Text Size: ")
                        .font(.subheadline)
                    
                    Text("\(Int(settings.fontAurebeshSize))")
                        .font(.subheadline)
                        .foregroundColor(settings.colorAccent.color)
                        .padding(.leading, -6)
                    
                    Spacer()
                    
                    Stepper(value: $settings.fontAurebeshSize.animation(.smooth), in: 15...50, step: 5) {}
                        .background(settings.colorAccent.color.opacity(0.2))
                        .foregroundColor(settings.colorAccent.color)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(settings.colorAccent.color, lineWidth: 5)
                                .blur(radius: 5)
                                .opacity(0.5)
                        )
                        .fixedSize()
                }
                #endif
                
                Toggle("Use System Font Size", isOn: $settings.useSystemFontSize.animation(.smooth))
                    .font(.subheadline)
                    .tint(settings.colorAccent.color.opacity(0.5))
                    .onChange(of: settings.useSystemFontSize) { useSystemFontSize in
                        if useSystemFontSize {
                            settings.fontAurebeshSize = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5
                        }
                    }
                    .onChange(of: settings.fontAurebeshSize) { newSize in
                        if newSize == UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5 {
                            settings.useSystemFontSize = true
                        } else {
                            settings.useSystemFontSize = false
                        }
                    }
                
                VStack(alignment: .leading) {
                    Toggle("Use Aurebesh Digraphs", isOn: $settings.digraph.animation(.smooth))
                        .font(.subheadline)
                        .tint(settings.colorAccent.color.opacity(0.5))
                        .onChange(of: settings.useSystemFontSize) { useSystemFontSize in
                            if useSystemFontSize {
                                settings.fontAurebeshSize = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.5
                            }
                        }
                    
                    Text("Check out the Alphabet View to learn more about digraphs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
                
            Section(header: Text("APPEARANCE SETTINGS")) {
                Toggle("Haptic Feedback", isOn: $settings.hapticOn.animation(.smooth))
                    .font(.subheadline)
                    .tint(settings.colorAccent.color.opacity(0.5))
                
                #if !os(watchOS)
                Picker("Color Theme", selection: $settings.colorSchemeString.animation(.smooth)) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
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
                #endif
                
                Button(action: {
                    settings.hapticFeedback()
                    
                    showingDatapad = true
                }) {
                    #if !os(watchOS)
                    Text("Accent colors are now exclusive to Datapad. Tap here to learn more.")
                        .font(.subheadline)
                        .foregroundColor(settings.colorAccent.color)
                    #else
                    Text("Accent colors are now exclusive to Datapad.")
                        .font(.subheadline)
                        .foregroundColor(settings.colorAccent.color)
                    #endif
                }
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
                    .foregroundColor(settings.colorAccent.color)
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
                    .foregroundColor(settings.colorAccent.color)
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
                        .foregroundColor(settings.colorAccent.color)
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
        .animation(.smooth(duration: 1.0), value: settings.colorAccent.color)
    }
}
