import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .receive(on: DispatchQueue.main)
        .debounce(for: .milliseconds(10), scheduler: DispatchQueue.main)
        .sink { [weak self] isVisible in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.smooth) {
                    self?.isKeyboardVisible = isVisible
                }
            }
        }
        .store(in: &cancellables)
    }

    deinit {
        cancellables.removeAll()
    }
}
