import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @EnvironmentObject var settings: Settings

    @Binding var text: String
    let aurebeshMode: Bool
    let autocorrect: Bool
    
    init(text: Binding<String>, aurebeshMode: Bool, autocorrect: Bool = true) {
        self._text = text
        self.aurebeshMode = aurebeshMode
        self.autocorrect = autocorrect
    }

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.delegate = context.coordinator

        tv.isScrollEnabled = true
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        tv.backgroundColor = .clear
        
        tv.textContainerInset = calculatedInsets()
        
        tv.textContainer.lineFragmentPadding = 0
        tv.inputAssistantItem.leadingBarButtonGroups = []
        tv.inputAssistantItem.trailingBarButtonGroups = []
        
        if !autocorrect {
            tv.autocorrectionType = .no
            tv.spellCheckingType = .no
            tv.autocapitalizationType = .none
            tv.smartQuotesType = .no
            tv.smartDashesType = .no
            tv.smartInsertDeleteType = .no
        }
        
        let ph = UILabel()
        ph.text = "Type here"
        ph.textColor = UIColor(.secondary)
        ph.numberOfLines = 0
        ph.lineBreakMode = .byWordWrapping
        ph.isUserInteractionEnabled = false
        ph.translatesAutoresizingMaskIntoConstraints = false

        tv.addSubview(ph)
        
        let topConstraint = ph.topAnchor.constraint(equalTo: tv.topAnchor, constant: tv.textContainerInset.top)
        context.coordinator.placeholderTopConstraint = topConstraint

        NSLayoutConstraint.activate([
            ph.leadingAnchor.constraint(equalTo: tv.leadingAnchor, constant: tv.textContainerInset.left),
            ph.trailingAnchor.constraint(equalTo: tv.trailingAnchor, constant: -tv.textContainerInset.right),
            topConstraint
        ])
        
        context.coordinator.placeholder = ph
        context.coordinator.startObservingBounds(of: tv)
        ph.isHidden = !text.isEmpty
        ph.font = editorFont()

        applyAppearance(to: tv)
        rebuildInputView(for: tv)
        
        return tv
    }

    func updateUIView(_ tv: UITextView, context: Context) {
        let wantedFont = editorFont()

        if context.coordinator.cachedAurebeshMode != aurebeshMode || context.coordinator.cachedFontName != settings.aurebeshFont || context.coordinator.cachedFontSize != settings.aurebeshFontSize {
            context.coordinator.cachedAurebeshMode = aurebeshMode
            context.coordinator.cachedFontName = settings.aurebeshFont
            context.coordinator.cachedFontSize = settings.aurebeshFontSize
            rebuildInputView(for: tv)
        }
        
        let newInsets = calculatedInsets()
        if tv.textContainerInset != newInsets {
            tv.textContainerInset = newInsets
            context.coordinator.placeholderTopConstraint?.constant = newInsets.top
        }

        if tv.font?.fontName != wantedFont.fontName ||
           abs(tv.font?.pointSize ?? 0 - wantedFont.pointSize) > 0.5 {
            tv.font = wantedFont
        }

        tv.textColor = aurebeshMode ? UIColor(settings.accentColor.color) : UIColor(.primary)
        
        if let ph = context.coordinator.placeholder {
            ph.font = editorFont()
            ph.isHidden = !text.isEmpty
        }

        if tv.text != text { tv.text = text }
    }

    private func editorFont() -> UIFont {
        if aurebeshMode && !autocorrect {
            let fontName: String
            if settings.aurebeshFont.contains("Aurebesh") && !settings.aurebeshFont.contains("Digraph") {
                fontName = settings.aurebeshFont + "Digraph"
            } else {
                fontName = settings.aurebeshFont
            }

            let size = UIFont.preferredFont(forTextStyle: .title1).pointSize
            return UIFont(name: fontName, size: size)!
        } else if aurebeshMode {
            return UIFont(name: settings.aurebeshFont, size: settings.aurebeshFontSize)!
        } else {
              return UIFont.preferredFont(forTextStyle: .body)
            
             // let size = UIFont.preferredFont(forTextStyle: .body).pointSize * 1.1
             // return UIFont(name: settings.englishFont, size: size)!
        }
    }

    private func applyAppearance(to tv: UITextView) {
        tv.font = editorFont()
        tv.textColor = text.isEmpty ? UIColor(.secondary) : aurebeshMode ? UIColor(settings.accentColor.color) : UIColor(.primary)
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
                    accentColor: settings.accentColor.color,
                    aurebeshFont: settings.aurebeshFont
                )
                .id(settings.aurebeshFont)
            }
        } else {
            tv.inputView = nil
        }
        tv.reloadInputViews()
    }
    
    private func calculatedInsets() -> UIEdgeInsets {
        let top: CGFloat = aurebeshMode
            ? settings.aurebeshFont.contains("AurebeshNexus") ? 20
            : settings.aurebeshFont.contains("AurebeshDroid") ? 15
            : settings.aurebeshFont.contains("AurebeshPixel") ? 4
            : settings.aurebeshFont.contains("AurebeshCantina") || settings.aurebeshFont.contains("AurebeshCore") ? 9
            : settings.aurebeshFont.contains("Mando") ? 16
            : settings.aurebeshFont.contains("OuterRimHive") ? 20
            : settings.aurebeshFont.contains("OuterRimProtobesh") ? 6
            : 12
            : 12

        return UIEdgeInsets(top: top, left: 13, bottom: top, right: 13)
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CustomTextEditor
        var cachedAurebeshMode: Bool
        var cachedFontName: String
        var cachedFontSize: CGFloat
        weak var placeholder: UILabel?
        var placeholderTopConstraint: NSLayoutConstraint?
        private var boundsObserver: NSKeyValueObservation?

        init(_ parent: CustomTextEditor) {
            self.parent = parent
            self.cachedAurebeshMode = parent.aurebeshMode
            self.cachedFontName = parent.settings.aurebeshFont
            self.cachedFontSize = parent.settings.aurebeshFontSize
        }
        
        deinit {
            boundsObserver?.invalidate()
        }

        func textViewDidChange(_ tv: UITextView) {
            parent.text = tv.text
            placeholder?.isHidden = !tv.text.isEmpty
            updatePlaceholder(in: tv)
        }

        func textViewDidEndEditing(_ tv: UITextView) {
            placeholder?.isHidden = !tv.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            parent.text = tv.text
        }
        
        func startObservingBounds(of tv: UITextView) {
            boundsObserver = tv.observe(\.bounds, options: [.new]) { [weak self] tv, _ in
                self?.updatePlaceholder(in: tv)
            }
        }
        
        func updatePlaceholder(in tv: UITextView) {
            guard let ph = placeholder else { return }

            let max = tv.bounds.width - tv.textContainerInset.left - tv.textContainerInset.right
            if ph.preferredMaxLayoutWidth != max { ph.preferredMaxLayoutWidth = max }

            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.0
            style.alignment = .natural

            ph.attributedText = NSAttributedString(
                string: "Type here",
                attributes: [.font: tv.font!, .foregroundColor: UIColor(.secondary), .paragraphStyle: style]
            )

            ph.isHidden = !tv.text.isEmpty
        }
    }
}

extension UITextView {
    open override var inputAssistantItem: UITextInputAssistantItem {
        let item = super.inputAssistantItem
        item.leadingBarButtonGroups = []
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
