import Foundation
import AVFoundation
import Speech

@MainActor
protocol WakeWordDetector: AnyObject {
    func start()
    func stop()
    var onWakeWordDetected: (() -> Void)? { get set }
}

@MainActor
final class SpeechWakeWordDetector: NSObject, WakeWordDetector, ObservableObject {
    var onWakeWordDetected: (() -> Void)?
    @Published private(set) var isRunning = false
    @Published private(set) var lastHeard = ""
    @Published private(set) var limitation = "Prototype detector uses Apple Speech as an adapter. Replace with a true on-device wake-word engine later."

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "nb_NO"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let wakeWords = ["hei horii", "hey horii", "hei hori", "hey hori", "hei h0rii"]

    func start() {
        guard !isRunning else { return }
        do {
            try AudioSessionManager.shared.configureForAssistant()
            beginRecognition()
        } catch {
            limitation = "Could not start audio session: \(error.localizedDescription)"
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        request?.endAudio()
        request = nil
        if audioEngine.isRunning { audioEngine.stop() }
        audioEngine.inputNode.removeTap(onBus: 0)
        isRunning = false
    }

    private func beginRecognition() {
        task?.cancel()
        task = nil

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false
        self.request = recognitionRequest

        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak recognitionRequest] buffer, _ in
            recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRunning = true
        } catch {
            limitation = "Could not start wake-word audio engine: \(error.localizedDescription)"
            return
        }

        task = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor in
                guard let self else { return }
                if let result {
                    let text = result.bestTranscription.formattedString.lowercased()
                    self.lastHeard = text
                    if self.wakeWords.contains(where: { text.contains($0) }) {
                        self.stop()
                        self.onWakeWordDetected?()
                    }
                }
                if error != nil && self.isRunning {
                    self.stop()
                    self.start()
                }
            }
        }
    }
}
