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
                
                /*VStack(alignment: .center) {
                    #if !os(watchOS)
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                    ], spacing: 12) {
                        ForEach(colorAccents.dropLast()) { colorAccent in
                            Circle()
                                .fill(colorAccent.color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(settings.colorAccent == colorAccent ? Color.primary : Color.clear, lineWidth: 1)
                                )
                                .onTapGesture {
                                    settings.hapticFeedback()
                                    
                                    withAnimation {
                                        settings.colorAccent = colorAccent
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.top, 2)
                    #else
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                    ], spacing: 12) {
                        ForEach(colorAccents.dropLast()) { colorAccent in
                            Circle()
                                .fill(colorAccent.color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(settings.colorAccent == colorAccent ? Color.primary : Color.clear, lineWidth: 1)
                                )
                                .onTapGesture {
                                    settings.hapticFeedback()
                                    
                                    withAnimation {
                                        settings.colorAccent = colorAccent
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                    #endif

                    if let goldcolorAccent = colorAccents.last {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(settings.colorAccent == goldcolorAccent ? Color.primary : Color.clear, lineWidth: 1)
                                .background(goldcolorAccent.color.opacity(0.75))
                            
                            Text("Electrum Gold Color")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation {
                                settings.hapticFeedback()
                                
                                settings.colorAccent = goldcolorAccent
                            }
                        }
                        .padding(.bottom)
                    }
                }
                #if !os(watchOS)
                .listRowSeparator(.hidden, edges: .bottom)
                #endif*/
                Button(action: {
                    settings.hapticFeedback()
                    
                    showingDatapad = true
                }) {
                    Text("Accent colors are now exclusive to Datapad. Tap here to learn more.")
                        .font(.subheadline)
                        .foregroundColor(settings.colorAccent.color)
                }
            }
            
            Section(header: Text("CREDITS")) {
                Text("Made by Abubakr Elmallah, who was an 18-year-old college student when this app was made.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 2)
                
                #if !os(watchOS)
                Button(action: {
                    if settings.hapticOn { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                    
                    withAnimation(.smooth()) {
                        showingCredits = true
                    }
                }) {
                    Text("View Credits")
                        .font(.subheadline)
                        .foregroundColor(settings.colorAccent.color)
                }
                .sheet(isPresented: $showingDatapad) {
                    SplashScreen()
                }
                .sheet(isPresented: $showingCredits) {
                    NavigationView {
                        VStack {
                            Text("Credits")
                                .foregroundColor(settings.colorAccent.color)
                                .font(.title)
                                .padding(.top, 20)
                                .padding(.bottom, 4)
                                .padding(.horizontal)
                            
                            CreditsView()
                            
                            Button(action: {
                                settings.hapticFeedback()
                                
                                showingCredits = false
                            }) {
                                Text("Done")
                                    .padding()
                                    .frame(maxWidth: .infinity)
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
                            .padding(.horizontal, 16)
                        }
                    }
                    .navigationViewStyle(.stack)
                }
                #endif
            }
        }
        .animation(.smooth(duration: 1.0), value: settings.colorAccent.color)
    }
}
