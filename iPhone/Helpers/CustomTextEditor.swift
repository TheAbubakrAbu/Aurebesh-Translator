import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @EnvironmentObject var settings: Settings

    @Binding var text: String
    let placeholder: String
    let aurebeshMode: Bool

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.delegate = context.coordinator
        
        tv.isScrollEnabled = true
        tv.isUserInteractionEnabled = true
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        tv.backgroundColor = .clear
        tv.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        tv.textContainer.lineFragmentPadding = 0

        if aurebeshMode {
            tv.autocorrectionType = .no
            tv.spellCheckingType = .no
            tv.smartDashesType = .no
            tv.smartQuotesType = .no
            tv.smartInsertDeleteType = .no
        } else {
            tv.keyboardType = .asciiCapable
            tv.autocapitalizationType = .allCharacters
        }

        applyAppearance(to: tv)
        rebuildInputView(for: tv)

        tv.inputAssistantItem.leadingBarButtonGroups  = []
        tv.inputAssistantItem.trailingBarButtonGroups = []

        return tv
    }

    func updateUIView(_ tv: UITextView, context: Context) {
        if text.isEmpty && !tv.isFirstResponder {
            tv.text = placeholder
            tv.textColor = UIColor(.secondary)
            return
        } else {
            tv.textColor = aurebeshMode ? UIColor(settings.colorAccent.color) : UIColor(.primary)
        }

        let oldText = tv.text ?? ""
        guard oldText != text else { return }
        
        let oldCaret = tv.selectedTextRange?.start
        let oldIndex = oldCaret.flatMap { tv.offset(from: tv.beginningOfDocument, to: $0) } ?? 0

        let delta = text.count - oldText.count

        tv.text = text
        
        let newOffset = max(0, oldIndex + delta)
        if let newPos = tv.position(from: tv.beginningOfDocument, offset: newOffset) {
            tv.selectedTextRange = tv.textRange(from: newPos, to: newPos)
        }
        
        let wanted = editorFont()
        if tv.font?.fontName != wanted.fontName ||
           tv.font?.pointSize != wanted.pointSize {
            tv.font = wanted
        }
    }

    private func editorFont() -> UIFont {
        if aurebeshMode {
            return UIFont(name: settings.fontAurebesh, size: settings.fontAurebeshSize)!
        } else {
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }

    private func applyAppearance(to tv: UITextView) {
        tv.font = editorFont()
        tv.textColor = text.isEmpty ? UIColor(.secondary) : aurebeshMode ? UIColor(settings.colorAccent.color) : UIColor(.primary)
    }

    private func rebuildInputView(for tv: UITextView) {
        if aurebeshMode {
            tv.inputView = SwiftUIInputView(height: 260) {
                DefaultKeyboardView(
                    showGlobeButton: false,
                    onGlobePress: {},
                    parentController: nil,
                    onKeyPress: { [weak tv] key in tv?.insertText(key) },
                    onDeletePress:{ [weak tv] in tv?.deleteBackward()  },
                    onSpacePress: { [weak tv] in tv?.insertText(" ")   },
                    onReturnPress:{ [weak tv] in tv?.insertText("\n")  },
                    accentColor: settings.colorAccent.color,
                    aurebeshFont: settings.fontAurebesh
                )
            }
        } else {
            tv.inputView = nil
        }
        tv.reloadInputViews()
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CustomTextEditor
        var cachedAurebeshMode: Bool

        init(_ parent: CustomTextEditor) {
            self.parent = parent
            self.cachedAurebeshMode = parent.aurebeshMode
        }

        func textView(_ tv: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard parent.aurebeshMode == false else { return true }
            
            let upper = text.uppercased()
            
            if let swiftRange = Range(range, in: tv.text) {
                var newString = tv.text!
                newString.replaceSubrange(swiftRange, with: upper)
                
                parent.text = newString
                tv.text = newString

                if let pos = tv.position(from: tv.beginningOfDocument, offset: range.location + upper.count) {
                    tv.selectedTextRange = tv.textRange(from: pos, to: pos)
                }
            }

            return false
        }
        
        func textViewDidBeginEditing(_ tv: UITextView) {
            if tv.textColor == UIColor(.secondary) {
                tv.text = ""
                tv.textColor = parent.aurebeshMode ? UIColor(parent.settings.colorAccent.color) : UIColor(.primary)
            }
        }

        func textViewDidEndEditing(_ tv: UITextView) {
            if tv.text.isEmpty {
                tv.text = parent.placeholder
                tv.textColor = UIColor(.secondary)
            } else {
                parent.text  = tv.text
            }
        }

        func textViewDidChange(_ tv: UITextView) {
            parent.text = tv.text
        }
    }
}

extension UITextView {
    open override var inputAssistantItem: UITextInputAssistantItem {
        let item = super.inputAssistantItem
        item.leadingBarButtonGroups  = []
        item.trailingBarButtonGroups = []
        return item
    }
}


final class KeyboardContainerView: UIView {
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 260)
    }
}

final class SwiftUIInputView<Content: View>: UIInputView {
    init(height: CGFloat,
         usesQuickTypePadding: Bool = true,
         @ViewBuilder content: () -> Content) {

        let pad: CGFloat = usesQuickTypePadding ? 36 : 0

        let root = AnyView(
            VStack(spacing: 0) {
                content()
                if pad > 0 { Color.clear.frame(height: pad) }
            }
        )

        hosting = UIHostingController(rootView: root)
        intrinsicHeight = height + pad

        super.init(frame: .zero, inputViewStyle: .keyboard)

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        addSubview(hosting.view)

        NSLayoutConstraint.activate([
            hosting.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hosting.view.topAnchor.constraint(equalTo: topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private let hosting: UIHostingController<AnyView>
    private let intrinsicHeight: CGFloat

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: intrinsicHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: intrinsicHeight)
    }
}
