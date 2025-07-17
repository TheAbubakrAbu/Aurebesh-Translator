import SwiftUI
import Combine

struct DefaultKeyboardView: View {
    let showGlobeButton: Bool
    let onGlobePress: () -> Void
    weak var parentController: UIInputViewController?
    
    var onKeyPress: (String) -> Void
    var onDeletePress: () -> Void
    var onSpacePress: () -> Void
    var onReturnPress: () -> Void
    @State var accentColor: Color
    @State var aurebeshFont: String

    @State private var isShiftActive: Bool = false
    @State private var isCapsLockActive: Bool = false
    @State private var isNumeric: Bool = false
    @State private var isSymbols: Bool = false

    @State private var lastShiftTap: Date? = nil
    private let shiftTapThreshold: TimeInterval = 0.5

    @State private var autoRepeatTimer: Timer?

    private let alphabetRows: [[String]] = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["Shift", "z", "x", "c", "v", "b", "n", "m", "Delete"],
        ["123", "Space", "Return"]
    ]

    private let numericRows: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
        ["#+=", ".", ",", "?", "!", "'", "Delete"],
        ["abc", "Space", "Return"]
    ]

    private let symbolRows: [[String]] = [
        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
        ["123", ".", ",", "?", "!", "'", "Delete"],
        ["abc", "Space", "Return"]
    ]

    private var currentRows: [[String]] {
        if isSymbols {
            return symbolRows
        } else if isNumeric {
            return numericRows
        } else {
            return alphabetRows
        }
    }

    private func isSpecialKey(_ key: String) -> Bool {
        return ["Shift", "Delete", "123", "abc", "Space", "Return", "#+=", ".", "Globe"].contains(key)
    }

    private func displayLabel(for key: String) -> String {
        switch key {
        case "Space":
            return "space"
        case "Delete", "Shift", "123", "abc", "Return", "#+=", "Globe":
            return key
        default:
            return key.lowercased()
        }
    }

    private func handleKeyPress(_ key: String) {
        withAnimation(.spring(duration: 0.35)) {
            switch key {
            case "Shift":
                handleShiftTap()
            case "Delete":
                onDeletePress()
            case "123":
                isNumeric = true
                isSymbols = false
                isShiftActive = false
                isCapsLockActive = false
            case "abc":
                isNumeric = false
                isSymbols = false
                isShiftActive = false
                isCapsLockActive = false
            case "#+=":
                isSymbols = true
                isNumeric = false
                isShiftActive = false
                isCapsLockActive = false
            case "Globe":
                onGlobePress()
            case "Space":
                onSpacePress()
                if isNumeric {
                    withAnimation(.spring(duration: 0.35)) {
                        isNumeric = false
                    }
                }
            case "Return":
                onReturnPress()
                if isNumeric {
                    withAnimation(.spring(duration: 0.35)) {
                        isNumeric = false
                    }
                }
            default:
                let output = (isShiftActive || isCapsLockActive) ? key.uppercased() : key.lowercased()
                if key == "'" && isNumeric {
                    withAnimation(.spring(duration: 0.35)) {
                        isNumeric = false
                    }
                }
                onKeyPress(output)
                if isShiftActive && !isCapsLockActive {
                    withAnimation(.spring(duration: 0.35)) {
                        isShiftActive = false
                    }
                }
            }
        }
    }

    private func handleShiftTap() {
        let now = Date()
        withAnimation(.spring(duration: 0.35)) {
            if isCapsLockActive {
                isCapsLockActive = false
                isShiftActive = false
            } else if let lastTap = lastShiftTap, now.timeIntervalSince(lastTap) < shiftTapThreshold {
                isCapsLockActive = true
                isShiftActive = false
                lastShiftTap = nil
            } else {
                isShiftActive.toggle()
                isCapsLockActive = false
                lastShiftTap = now
            }
        }
    }

    private func startAutoRepeat(for key: String) {
        guard key == "Delete" else { return }
        
        autoRepeatTimer?.invalidate()

        autoRepeatTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.autoRepeatTimer?.invalidate()
            self.autoRepeatTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.onDeletePress()
            }
        }
    }

    private func stopAutoRepeat() {
        autoRepeatTimer?.invalidate()
        autoRepeatTimer = nil
    }

    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 5
            let keyWidth = (geometry.size.width - (spacing * CGFloat(10 + 2))) / 10
            let keyHeight: CGFloat = 44

            VStack(alignment: .center, spacing: 0) {
                ForEach(Array(currentRows.enumerated()), id: \.offset) { rowIndex, row in
                    HStack(alignment: .center, spacing: 0) {
                        switch rowIndex {
                        case 0:
                            // 1st row
                            ForEach(row, id: \.self) { key in
                                KeyButtonView(
                                    width: keyWidth,
                                    height: keyHeight,
                                    keyLabel: displayLabel(for: key),
                                    isSpecialKey: isSpecialKey(key),
                                    isShiftActive: isShiftActive,
                                    isCapsLockActive: isCapsLockActive,
                                    accentColor: accentColor,
                                    aurebeshFont: aurebeshFont,
                                    action: {
                                        handleKeyPress(key)
                                    }
                                )
                            }

                        case 1:
                            // 2nd row
                            if !isNumeric && !isSymbols { Spacer() }
                            ForEach(row, id: \.self) { key in
                                KeyButtonView(
                                    width: keyWidth,
                                    height: keyHeight,
                                    keyLabel: displayLabel(for: key),
                                    isSpecialKey: isSpecialKey(key),
                                    isShiftActive: isShiftActive,
                                    isCapsLockActive: isCapsLockActive,
                                    accentColor: accentColor,
                                    aurebeshFont: aurebeshFont,
                                    action: {
                                        handleKeyPress(key)
                                    }
                                )
                            }
                            if !isNumeric && !isSymbols { Spacer() }

                        case 2:
                            // 3rd row
                            let firstKey = row.first!
                            let keyLabel = firstKey == "123" ? "1234" : displayLabel(for: firstKey)
                            KeyButtonView(
                                width: geometry.size.width < 500 ? keyHeight * 0.96 : keyHeight * 2,
                                height: keyHeight,
                                keyLabel: keyLabel,
                                isSpecialKey: true,
                                isShiftActive: isShiftActive,
                                isCapsLockActive: isCapsLockActive,
                                accentColor: accentColor,
                                aurebeshFont: aurebeshFont,
                                action: {
                                    handleKeyPress(firstKey)
                                    //print(geometry.size.width)
                                }
                            )

                            Spacer()

                            ForEach(row.dropFirst().dropLast(), id: \.self) { key in
                                KeyButtonView(
                                    width: (isNumeric || isSymbols) ? keyHeight : keyWidth,
                                    height: keyHeight,
                                    keyLabel: displayLabel(for: key),
                                    isSpecialKey: isSpecialKey(key),
                                    isShiftActive: isShiftActive,
                                    isCapsLockActive: isCapsLockActive,
                                    accentColor: accentColor,
                                    aurebeshFont: aurebeshFont,
                                    action: {
                                        handleKeyPress(key)
                                    }
                                )
                            }

                            Spacer()

                            let lastKey = row.last!
                            KeyButtonView(
                                width: geometry.size.width < 500 ? keyHeight * 0.96 : keyHeight * 2,
                                height: keyHeight,
                                keyLabel: displayLabel(for: lastKey),
                                isSpecialKey: true,
                                isShiftActive: isShiftActive,
                                isCapsLockActive: isCapsLockActive,
                                accentColor: accentColor,
                                aurebeshFont: aurebeshFont,
                                action: {
                                    handleKeyPress(lastKey)
                                }
                            )
                            .onPressHold {
                                startAutoRepeat(for: lastKey)
                            } onPressRelease: {
                                stopAutoRepeat()
                            }

                        default:
                            // 4th row = bottom row
                            // We'll detect if it's ["123", "Space", "Return"] or ["abc", "Space", "Return"].
                            // If showGlobeButton == true, we insert "Globe" in between [0] and [1].
                            let originalRow = row
                            let newKeyWidth = (geometry.size.width - spacing * 4) / 4

                            // Insert "Globe" if showGlobeButton is true and row is ["123"/"abc", "Space", "Return"].
                            let finalRow: [String] = {
                                guard showGlobeButton else { return originalRow }
                                if originalRow.count == 3,
                                   (originalRow[0] == "123" || originalRow[0] == "abc"),
                                   originalRow[1] == "Space",
                                   originalRow[2] == "Return" {
                                    return [originalRow[0], "Globe", originalRow[1], originalRow[2]]
                                } else {
                                    return originalRow
                                }
                            }()

                            ForEach(finalRow, id: \.self) { key in
                                if key == "Globe" {
                                    let width  = newKeyWidth * 0.47
                                    let height = keyHeight - 2
                                    
                                    GlobeButtonView1(
                                        parentVC: parentController,
                                        width: width,
                                        height: height
                                    )
                                } else if key == "Space" {
                                    // "Space" remains large
                                    KeyButtonView(
                                        width: newKeyWidth * 2.02,
                                        height: keyHeight - 2,
                                        keyLabel: displayLabel(for: key),
                                        isSpecialKey: isSpecialKey(key),
                                        isShiftActive: isShiftActive,
                                        isCapsLockActive: isCapsLockActive,
                                        accentColor: accentColor,
                                        aurebeshFont: aurebeshFont,
                                        action: {
                                            handleKeyPress(key)
                                        }
                                    )
                                }
                                else if finalRow.count == 4,
                                        (key == finalRow[0] || key == "Globe") {
                                    // If we have 4 items total, shrink "123"/"abc" and "Globe" to 3/4 width
                                    KeyButtonView(
                                        width: newKeyWidth * 0.47,
                                        height: keyHeight - 2,
                                        keyLabel: displayLabel(for: key),
                                        isSpecialKey: isSpecialKey(key),
                                        isShiftActive: isShiftActive,
                                        isCapsLockActive: isCapsLockActive,
                                        accentColor: accentColor,
                                        aurebeshFont: aurebeshFont,
                                        action: {
                                            handleKeyPress(key)
                                        }
                                    )
                                } else {
                                    // Return key (or the case with only 3 items in finalRow)
                                    KeyButtonView(
                                        width: newKeyWidth,
                                        height: keyHeight - 2,
                                        keyLabel: displayLabel(for: key),
                                        isSpecialKey: isSpecialKey(key),
                                        isShiftActive: isShiftActive,
                                        isCapsLockActive: isCapsLockActive,
                                        accentColor: accentColor,
                                        aurebeshFont: aurebeshFont,
                                        action: {
                                            handleKeyPress(key)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .frame(minHeight: 217)
        .padding(.top, 3)
        .padding(.bottom, showGlobeButton ? 4 : 0)
    }
}

struct KeyButtonView: View {
    let width: CGFloat
    let height: CGFloat
    let keyLabel: String
    let isSpecialKey: Bool
    let isShiftActive: Bool
    let isCapsLockActive: Bool
    @State var accentColor: Color
    @State var aurebeshFont: String
    var action: () -> Void
        
    @State private var isPressed: Bool = false

    private var fontForKey: Font {
        if keyLabel == "1234" || keyLabel == "#+=" {
            return .custom(aurebeshFont, size: 15)
        } else {
            return .custom(aurebeshFont, size: 20)
        }
    }

    private func systemImageName(for key: String) -> String? {
        switch key {
        case "Delete":
            return "delete.backward.fill"
        case "Shift":
            if isCapsLockActive {
                return "capslock.fill"
            } else if isShiftActive {
                return "shift.fill"
            } else {
                return "shift"
            }
        case "Return":
            return "arrow.turn.down.left"
        case "Globe":
            return "globe"
        default:
            return nil
        }
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Rectangle()
                    .fill(.white.opacity(0.001))
                    .frame(width: width + 6, height: height + 12)

                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(accentColor.opacity(isPressed ? 0.4 : 0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(accentColor.opacity(0.4), lineWidth: 1)
                        )

                    if isSpecialKey, let systemImage = systemImageName(for: keyLabel) {
                        Image(systemName: systemImage)
                            .font(fontForKey)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .padding(5)
                    } else {
                        let newKey = keyLabel == "1234" ? "123" : keyLabel
                        Text(newKey)
                            .font(fontForKey)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(5)
                            .padding(.leading, aurebeshFont.contains("Aurebesh") ? 2 : 0)
                            .padding(.top, aurebeshFont.contains("Aurebesh") ? 2 : 0)
                    }
                }
                .frame(maxWidth: width, maxHeight: height)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(duration: 0.05), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(duration: 0.05)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(duration: 0.05)) {
                        isPressed = false
                    }
                }
        )
    }
}

extension View {
    func onPressHold(onPress: @escaping () -> Void, onPressRelease: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onPress()
                }
                .onEnded { _ in
                    onPressRelease()
                }
        )
    }
}

struct GlobeButtonRepresentable: UIViewRepresentable {
    unowned var parentVC: UIInputViewController
    let width: CGFloat
    let height: CGFloat

    func makeUIView(context: Context) -> UIButton {
        let globeButton = UIButton(type: .system)

        globeButton.setImage(UIImage(systemName: "globe"), for: .normal)
        
        globeButton.backgroundColor = .clear
        globeButton.tintColor = UIColor(Color.primary)
        
        globeButton.addTarget(
            parentVC,
            action: #selector(parentVC.handleInputModeList(from:with:)),
            for: .allTouchEvents
        )
        
        return globeButton
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}

struct GlobeButtonView1: View {
    weak var parentVC: UIInputViewController?
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.001))
                .frame(width: width + 6, height: height + 12)

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primary.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primary.opacity(0.4), lineWidth: 1)
                    )

                GlobeButtonRepresentable(
                    parentVC: parentVC ?? UIInputViewController(),
                    width: width,
                    height: height
                )
            }
            .frame(maxWidth: width, maxHeight: height)
        }
    }
}

let keyAccentColors: [Color] = [.primary, .red, .blue, .green, .yellow, .purple]
