import Foundation
import AVFoundation
import Speech

@MainActor
final class HoriiAssistantController: ObservableObject {
    @Published private(set) var state: HoriiAssistantState = .idle
    @Published private(set) var transcript = ""
    @Published private(set) var answer = ""
    @Published private(set) var microphoneStatus = "Not requested"
    @Published private(set) var backgroundListeningActive = false
    @Published private(set) var technicalLimitation = ""

    private let wakeWordDetector: WakeWordDetector
    private let speechRecognizer: HoriiSpeechRecognizer
    private let aiService: HoriiAIService
    private let tts: HoriiTTS

    init(
        wakeWordDetector: WakeWordDetector = SpeechWakeWordDetector(),
        speechRecognizer: HoriiSpeechRecognizer = HoriiSpeechRecognizer(),
        aiService: HoriiAIService = MockHoriiAIService(),
        tts: HoriiTTS = HoriiTTS()
    ) {
        self.wakeWordDetector = wakeWordDetector
        self.speechRecognizer = speechRecognizer
        self.aiService = aiService
        self.tts = tts
        self.wakeWordDetector.onWakeWordDetected = { [weak self] in
            Task { @MainActor in await self?.handleWakeWord() }
        }
    }

    func enableAssistant() async {
        let allowed = await speechRecognizer.requestPermissions()
        microphoneStatus = allowed ? "Microphone and Speech authorized" : "Missing microphone or speech permission"
        guard allowed else { return }

        do {
            try AudioSessionManager.shared.configureForAssistant()
            backgroundListeningActive = true
            technicalLimitation = "Background audio mode is configured. iOS may still suspend third-party continuous speech recognition; use a real local wake-word SDK in WakeWordDetector for production testing."
            enterWakeWordMode()
        } catch {
            microphoneStatus = "Audio session failed: \(error.localizedDescription)"
            disableAssistant()
        }
    }

    func disableAssistant() {
        wakeWordDetector.stop()
        speechRecognizer.stop()
        tts.stop()
        AudioSessionManager.shared.deactivate()
        backgroundListeningActive = false
        state = .idle
    }

    private func enterWakeWordMode() {
        state = .waitingForWakeWord
        transcript = ""
        wakeWordDetector.start()
    }

    private func handleWakeWord() async {
        state = .wakeWordDetected
        try? await Task.sleep(nanoseconds: 250_000_000)
        await listenForCommand()
    }

    private func listenForCommand() async {
        state = .listening
        do {
            let command = try await speechRecognizer.listenForCommand(timeout: 6.0)
            transcript = command.isEmpty ? "No command detected after Hei Horii." : command
            guard !command.isEmpty else {
                enterWakeWordMode()
                return
            }
            state = .processing
            let response = try await aiService.send(message: command)
            answer = response
            state = .speaking
            await tts.speak(response)
            enterWakeWordMode()
        } catch {
            answer = "Horii kunne ikke høre kommandoen: \(error.localizedDescription)"
            enterWakeWordMode()
        }
    }
}
