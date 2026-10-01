import Foundation

#if canImport(Porcupine)
import Porcupine
#endif

@MainActor
struct WakeWordDetectorFactory {
    static func make() -> WakeWordDetector {
        #if canImport(Porcupine)
        if PorcupineWakeWordDetector.isConfigured {
            return PorcupineWakeWordDetector()
        }
        #endif
        return SpeechWakeWordDetector()
    }
}

#if canImport(Porcupine)
@MainActor
final class PorcupineWakeWordDetector: WakeWordDetector, ObservableObject {
    var onWakeWordDetected: (() -> Void)?
    var onPartialTranscript: ((String) -> Void)?

    private var manager: PorcupineManager?

    static var isConfigured: Bool {
        let accessKey = UserDefaults.standard.string(forKey: "horii.porcupine.accessKey") ?? ""
        let keywordPath = resolvedKeywordPath()
        return !accessKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && keywordPath != nil
    }

    func start() {
        guard manager == nil else { return }
        let defaults = UserDefaults.standard
        let accessKey = defaults.string(forKey: "horii.porcupine.accessKey") ?? ""
        guard !accessKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onPartialTranscript?("Porcupine mangler AccessKey. Legg den inn i appen først.")
            return
        }
        guard let keywordPath = Self.resolvedKeywordPath() else {
            onPartialTranscript?("Porcupine mangler Hei Horii .ppn keyword model. Legg filen i app bundle eller oppgi path.")
            return
        }

        do {
            try AudioSessionManager.shared.configureForAssistant()
            manager = try PorcupineManager(
                accessKey: accessKey,
                keywordPath: keywordPath,
                onDetection: { [weak self] _ in
                    Task { @MainActor in
                        self?.onPartialTranscript?("Porcupine oppdaget Hei Horii")
                        self?.stop()
                        self?.onWakeWordDetected?()
                    }
                }
            )
            try manager?.start()
            onPartialTranscript?("Porcupine lytter lokalt etter Hei Horii")
        } catch {
            onPartialTranscript?("Porcupine kunne ikke starte: \(error.localizedDescription)")
            manager = nil
        }
    }

    func stop() {
        manager?.stop()
        manager?.delete()
        manager = nil
    }

    private static func resolvedKeywordPath() -> String? {
        let stored = UserDefaults.standard.string(forKey: "horii.porcupine.keywordPath") ?? ""
        if !stored.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return stored
        }
        return Bundle.main.path(forResource: "hei_horii_ios", ofType: "ppn")
            ?? Bundle.main.path(forResource: "Hei_Horii_ios", ofType: "ppn")
            ?? Bundle.main.path(forResource: "hei-horii_ios", ofType: "ppn")
    }
}
#else
@MainActor
final class PorcupineWakeWordDetector: WakeWordDetector, ObservableObject {
    var onWakeWordDetected: (() -> Void)?
    var onPartialTranscript: ((String) -> Void)?

    static var isConfigured: Bool { false }

    func start() {
        onPartialTranscript?("Porcupine SDK er ikke lagt til i Xcode-prosjektet. Bruk fallback eller legg til Swift Package.")
    }

    func stop() {}
}
#endif
