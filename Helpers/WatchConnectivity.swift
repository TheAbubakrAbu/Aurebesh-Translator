import Foundation
import WatchConnectivity
import Combine

final class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()

    private let session = WCSession.default
    private var cancellables = Set<AnyCancellable>()
    private let outgoing  = PassthroughSubject<[String:Any], Never>()
    private var lastPayloadData: Data?

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        session.delegate = self
        session.activate()

        outgoing
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] msg in Task { await self?.send(msg) } }
            .store(in: &cancellables)
    }

    func queue(message: [String:Any]) { outgoing.send(message) }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error { print("WC activation failed: \(error)") }
        print("WC activation →", activationState.rawValue)
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
    #endif

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let settings = message["settings"] as? [String:Any] else { return }
        Task { @MainActor in Settings.shared.update(from: settings) }
    }

    private func send(_ payload: [String:Any]) async {
        guard let data = try? JSONSerialization.data(withJSONObject: payload), data != lastPayloadData else { return }
        lastPayloadData = data

        #if os(iOS) || targetEnvironment(macCatalyst)
        guard session.isPaired, session.isWatchAppInstalled else { return }
        #endif

        if session.isReachable {
            session.sendMessage(payload, replyHandler: nil) { err in
                print("WC sendMessage error: \(err.localizedDescription)")
            }
        } else {
            _ = session.transferUserInfo(payload)
        }
    }
}
