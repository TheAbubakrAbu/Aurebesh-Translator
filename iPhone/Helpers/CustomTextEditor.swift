import SwiftUI

struct CustomTextView: UIViewRepresentable {
    @EnvironmentObject var settings: Settings
    
    @Environment(\.colorScheme) var systemColorScheme
    
    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true

        updateBackgroundColor(for: textView)

        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text != uiView.text {
            uiView.text = text.isEmpty ? placeholder : text
            uiView.textColor = text.isEmpty ? UIColor.lightGray : UIColor.label
        }

        updateBackgroundColor(for: uiView)
    }

    private func updateBackgroundColor(for textView: UITextView) {
        if settings.colorScheme == .dark || (settings.colorScheme == nil && systemColorScheme == .dark) {
            textView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        } else {
            textView.backgroundColor = UIColor(settings.colorAccent.color.opacity(0.01))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView

        init(_ textView: CustomTextView) {
            self.parent = textView
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
