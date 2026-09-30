import SwiftUI
import Speech
import AVFoundation
import Contacts
import UIKit

struct DashboardView: View {
    @StateObject private var statsStore = PublicStatsStore()

    var body: some View {
        NavigationStack {
            ZStack {
                H0RIIBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        hero
                        stats
                        AfterHoursStatsCard(store: statsStore)
                        quickActions
                        SectionTitle("Live overview")
                        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                            ForEach(H0RIIService.live) { service in
                                ServiceMiniCard(service: service)
                            }
                        }
                        SectionTitle("Latest")
                        ForEach(H0RIIUpdate.feed) { item in
                            ActivityCard(title: item.title, text: item.body, symbol: item.symbol, trailing: item.time)
                        }
                    }
                    .padding(20)
                }
                .refreshable { await statsStore.refresh() }
            }
            .navigationTitle("H0RII")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { await statsStore.refresh() }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("H0RII")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                    Text("Command center")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.78))
                }
                Spacer()
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 40))
                    .symbolRenderingMode(.hierarchical)
            }

            Text("A native iOS home for Jhonatan Wik / H0RII projects, live links, ops status and product updates.")
                .foregroundStyle(.secondary)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Label("Native SwiftUI", systemImage: "swift")
                Spacer()
                Label("Ready for Xcode", systemImage: "hammer.fill")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.75))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.12)))
    }

    private var stats: some View {
        HStack(spacing: 12) {
            StatPill(value: "4", label: "Projects")
            StatPill(value: "Live", label: "Web")
            StatPill(value: "iOS", label: "Native")
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Quick actions")
            HStack(spacing: 12) {
                QuickAction(title: "Open H0RII", icon: "safari.fill", url: "https://horii.dev")
                QuickAction(title: "AfterHours", icon: "gamecontroller.fill", url: "https://afterhoursmc.gg")
            }
            HStack(spacing: 12) {
                QuickAction(title: "HXSecurity", icon: "shield.fill", url: "https://hxsecurity.net")
                QuickAction(title: "Excel", icon: "tablecells.fill", url: "https://excel.horii.dev")
            }
        }
    }
}

struct StatusView: View {
    @StateObject private var statsStore = PublicStatsStore()

    var body: some View {
        NavigationStack {
            ZStack {
                H0RIIBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Status")
                            .font(.largeTitle.bold())
                        Text("Live-facing snapshot for H0RII systems. Pull down to refresh public stats.")
                            .foregroundStyle(.secondary)
                        AfterHoursStatsCard(store: statsStore)
                        ForEach(H0RIIService.live) { service in
                            StatusRow(service: service)
                        }
                        ActivityCard(title: "Next upgrade", text: "Wire this tab to status.horii.dev for incidents, uptime history and push notifications.", symbol: "antenna.radiowaves.left.and.right", trailing: "API")
                    }
                    .padding(20)
                }
                .refreshable { await statsStore.refresh() }
            }
            .navigationTitle("Status")
            .task { await statsStore.refresh() }
        }
    }
}

struct H0RIIBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color(red: 0.035, green: 0.035, blue: 0.07)], startPoint: .top, endPoint: .bottom)
            Circle().fill(.blue.opacity(0.15)).blur(radius: 60).offset(x: 130, y: -260)
            Circle().fill(.purple.opacity(0.12)).blur(radius: 70).offset(x: -160, y: 260)
        }
        .ignoresSafeArea()
    }
}

struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View { Text(text).font(.headline).foregroundStyle(.white) }
}

struct StatPill: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.08)))
    }
}

struct QuickAction: View {
    let title: String
    let icon: String
    let url: String
    var body: some View {
        Link(destination: URL(string: url)!) {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 18))
                .foregroundStyle(.black)
        }
    }
}

struct AfterHoursStatsCard: View {
    @ObservedObject var store: PublicStatsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("AfterHoursMC public stats", systemImage: "gamecontroller.fill")
                    .font(.headline)
                Spacer()
                if store.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundStyle(.secondary)
                }
            }

            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 10) {
                MetricCell(title: "Servers", value: store.stats.servers?.compactFormatted ?? "—")
                MetricCell(title: "Online", value: store.stats.playersOnline?.compactFormatted ?? "—")
                MetricCell(title: "Nodes", value: store.stats.nodes?.compactFormatted ?? "—")
                MetricCell(title: "Customers", value: store.stats.customers?.compactFormatted ?? "—")
            }

            HStack {
                Label("Uptime", systemImage: "checkmark.seal.fill")
                Spacer()
                Text(store.stats.uptime.map { String(format: "%.2f%%", $0) } ?? "—")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            .font(.subheadline)

            Text(store.lastError ?? "Updated from public endpoint when reachable")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.08)))
    }
}

struct MetricCell: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value).font(.title3.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.black.opacity(0.22), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ServiceMiniCard: View {
    let service: H0RIIService
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: service.symbol)
                .font(.title2)
                .foregroundStyle(service.tint)
            Text(service.name).font(.headline)
            Text(service.value).font(.caption.bold()).foregroundStyle(service.tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 20))
    }
}

struct StatusRow: View {
    let service: H0RIIService
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: service.symbol)
                .font(.title3)
                .foregroundStyle(service.tint)
                .frame(width: 42, height: 42)
                .background(service.tint.opacity(0.14), in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name).font(.headline)
                Text(service.detail).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Text(service.value)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(service.tint.opacity(0.16), in: Capsule())
                .foregroundStyle(service.tint)
        }
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
    }
}

struct ActivityCard: View {
    let title: String
    let text: String
    let symbol: String
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol).font(.title2).foregroundStyle(.white)
                .frame(width: 44, height: 44).background(Color.white.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title).font(.headline)
                    Spacer()
                    if let trailing {
                        Text(trailing).font(.caption.bold()).foregroundStyle(.secondary)
                    }
                }
                Text(text).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
    }
}

struct VoiceAssistantView: View {
    @StateObject private var assistant = VoiceAssistantController()
    @State private var typedCommand = ""

    var body: some View {
        NavigationStack {
            ZStack {
                H0RIIBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("H0RII Voice")
                                .font(.largeTitle.bold())
                            Text("Push-to-talk assistant for bus routes, weather, calls, calculator and translation.")
                                .foregroundStyle(.secondary)
                        }

                        VStack(spacing: 14) {
                            Button {
                                assistant.toggleListening()
                            } label: {
                                VStack(spacing: 10) {
                                    Image(systemName: assistant.isListening ? "waveform.circle.fill" : "mic.circle.fill")
                                        .font(.system(size: 76))
                                        .symbolRenderingMode(.hierarchical)
                                    Text(assistant.isListening ? "Listening… tap to stop" : "Hold the idea. Tap and speak.")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 28)
                                .background(assistant.isListening ? Color.red.opacity(0.22) : Color.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 30))
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.12)))
                            }
                            .buttonStyle(.plain)

                            Text(assistant.transcript.isEmpty ? "Try: ‘Hei H0RII, når går bussen fra Oslo S til Gardermoen?’" : assistant.transcript)
                                .font(.body)
                                .foregroundStyle(assistant.transcript.isEmpty ? .secondary : .white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color.black.opacity(0.22), in: RoundedRectangle(cornerRadius: 18))
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("Type a test command")
                            HStack(spacing: 10) {
                                TextField("Ask H0RII…", text: $typedCommand)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding(14)
                                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                                Button("Run") {
                                    assistant.handle(typedCommand)
                                    typedCommand = ""
                                }
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                                .foregroundStyle(.black)
                            }
                        }

                        if !assistant.response.isEmpty {
                            ActivityCard(title: "H0RII says", text: assistant.response, symbol: "speaker.wave.2.fill", trailing: "Voice")
                        }

                        SectionTitle("Skills")
                        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                            VoiceSkillCard(title: "Bus", text: "‘buss fra Oslo til Bergen’", icon: "bus.fill")
                            VoiceSkillCard(title: "Weather", text: "‘vær i Oslo’", icon: "cloud.sun.fill")
                            VoiceSkillCard(title: "Call", text: "‘ring Sofie’ or number", icon: "phone.fill")
                            VoiceSkillCard(title: "Math", text: "‘kalkuler 12 * 8’", icon: "function")
                            VoiceSkillCard(title: "Translate", text: "‘oversett hei til engelsk’", icon: "character.book.closed.fill")
                            VoiceSkillCard(title: "Speak back", text: "Reads answers aloud", icon: "speaker.wave.3.fill")
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Voice")
        }
    }
}

struct VoiceSkillCard: View {
    let title: String
    let text: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).font(.title2).foregroundStyle(.white)
            Text(title).font(.headline)
            Text(text).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 20))
    }
}

@MainActor
final class VoiceAssistantController: NSObject, ObservableObject {
    @Published var transcript = ""
    @Published var response = ""
    @Published var isListening = false

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "nb_NO"))
    private let audioEngine = AVAudioEngine()
    private let synthesizer = AVSpeechSynthesizer()
    private let contactStore = CNContactStore()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    func toggleListening() {
        isListening ? stopListening() : startListening()
    }

    func startListening() {
        Task {
            let speechAllowed = await requestSpeechPermission()
            let micAllowed = await requestMicrophonePermission()
            guard speechAllowed && micAllowed else {
                answer("I need microphone and speech recognition access first.")
                return
            }
            beginRecognition()
        }
    }

    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
        let finalText = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        if !finalText.isEmpty { handle(finalText) }
    }

    func handle(_ rawText: String) {
        let text = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        transcript = text
        let normalized = text.lowercased()
            .replacingOccurrences(of: "hei horii", with: "")
            .replacingOccurrences(of: "hei h0rii", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if normalized.contains("buss") || normalized.contains("bus") {
            openTransit(from: normalized)
        } else if normalized.contains("vær") || normalized.contains("weather") {
            openWeather(from: normalized)
        } else if normalized.hasPrefix("ring ") || normalized.contains(" ring ") || normalized.hasPrefix("call ") {
            callContactOrNumber(from: normalized)
        } else if normalized.contains("kalkuler") || normalized.contains("calculator") || normalized.contains("regn ut") {
            calculate(from: normalized)
        } else if normalized.contains("oversett") || normalized.contains("translate") {
            translate(from: normalized)
        } else {
            answer("I can help with bus routes, weather, contacts, calculator and translation. Try saying: buss fra Oslo S til Gardermoen.")
        }
    }

    private func beginRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        transcript = ""

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            answer("Could not start microphone session.")
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request

        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak request] buffer, _ in
            request?.append(buffer)
        }

        audioEngine.prepare()
        do { try audioEngine.start() } catch {
            answer("Could not start audio engine.")
            return
        }

        isListening = true
        recognitionTask = recognizer?.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor in
                guard let self else { return }
                if let result { self.transcript = result.bestTranscription.formattedString }
                if error != nil || result?.isFinal == true { self.stopListening() }
            }
        }
    }

    private func requestSpeechPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

    private func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }
    }

    private func answer(_ text: String) {
        response = text
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "nb-NO") ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.48
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }

    private func openTransit(from text: String) {
        let parts = splitFromTo(text)
        guard let from = parts.from, let to = parts.to else {
            answer("Say it like: buss fra Oslo S til Gardermoen.")
            return
        }
        openURL("http://maps.apple.com/?saddr=\(from.urlEncoded)&daddr=\(to.urlEncoded)&dirflg=r")
        answer("Opening transit directions from \(from) to \(to).")
    }

    private func openWeather(from text: String) {
        let city = text
            .replacingOccurrences(of: "hvordan er været i", with: "")
            .replacingOccurrences(of: "vær i", with: "")
            .replacingOccurrences(of: "weather in", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let query = city.isEmpty ? "current location" : city
        openURL("https://www.yr.no/en/search?q=\(query.urlEncoded)")
        answer("Opening weather for \(query).")
    }

    private func callContactOrNumber(from text: String) {
        let query = text
            .replacingOccurrences(of: "ring", with: "")
            .replacingOccurrences(of: "call", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            answer("Who should I call?")
            return
        }
        if let direct = normalizedPhoneNumber(query), !direct.isEmpty {
            openURL("tel://\(direct)")
            answer("Calling \(query).")
            return
        }

        contactStore.requestAccess(for: .contacts) { [weak self] granted, _ in
            Task { @MainActor in
                guard let self else { return }
                guard granted else {
                    self.answer("I need Contacts access before I can call saved contacts.")
                    return
                }
                let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
                let request = CNContactFetchRequest(keysToFetch: keys)
                var match: (name: String, phone: String)?
                try? self.contactStore.enumerateContacts(with: request) { contact, stop in
                    let name = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                    if name.lowercased().contains(query.lowercased()), let number = contact.phoneNumbers.first?.value.stringValue {
                        match = (name, number)
                        stop.pointee = true
                    }
                }
                if let match, let phone = self.normalizedPhoneNumber(match.phone) {
                    self.openURL("tel://\(phone)")
                    self.answer("Calling \(match.name).")
                } else {
                    self.answer("I could not find \(query) in contacts.")
                }
            }
        }
    }

    private func calculate(from text: String) {
        let expression = text
            .replacingOccurrences(of: "kalkuler", with: "")
            .replacingOccurrences(of: "regn ut", with: "")
            .replacingOccurrences(of: "calculator", with: "")
            .replacingOccurrences(of: "pluss", with: "+")
            .replacingOccurrences(of: "minus", with: "-")
            .replacingOccurrences(of: "ganger", with: "*")
            .replacingOccurrences(of: "delt på", with: "/")
        if let value = SimpleCalculator.evaluate(expression) {
            answer("Svaret er \(value.cleanString).")
        } else {
            answer("I could not calculate that yet. Try: kalkuler 12 * 8.")
        }
    }

    private func translate(from text: String) {
        let phrase = text
            .replacingOccurrences(of: "oversett", with: "")
            .replacingOccurrences(of: "translate", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phrase.isEmpty else {
            answer("Say what you want me to translate.")
            return
        }
        openURL("https://translate.google.com/?sl=auto&tl=en&text=\(phrase.urlEncoded)&op=translate")
        answer("Opening translation for: \(phrase).")
    }

    private func splitFromTo(_ text: String) -> (from: String?, to: String?) {
        let cleaned = text.replacingOccurrences(of: "når går bussen", with: "").replacingOccurrences(of: "buss", with: "")
        guard let fromRange = cleaned.range(of: "fra "), let toRange = cleaned.range(of: " til ") else { return (nil, nil) }
        let from = String(cleaned[fromRange.upperBound..<toRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
        let to = String(cleaned[toRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        return (from.isEmpty ? nil : from, to.isEmpty ? nil : to)
    }

    private func normalizedPhoneNumber(_ value: String) -> String? {
        let allowed = Set("+0123456789")
        let phone = String(value.filter { allowed.contains($0) })
        return phone.count >= 3 ? phone : nil
    }

    private func openURL(_ raw: String) {
        guard let url = URL(string: raw) else { return }
        UIApplication.shared.open(url)
    }
}

struct SimpleCalculator {
    static func evaluate(_ expression: String) -> Double? {
        let tokens = tokenize(expression)
        guard !tokens.isEmpty else { return nil }
        var values: [Double] = []
        var ops: [Character] = []

        func precedence(_ op: Character) -> Int { (op == "*" || op == "/") ? 2 : 1 }
        func apply() {
            guard values.count >= 2, let op = ops.popLast() else { return }
            let rhs = values.removeLast()
            let lhs = values.removeLast()
            switch op {
            case "+": values.append(lhs + rhs)
            case "-": values.append(lhs - rhs)
            case "*": values.append(lhs * rhs)
            case "/": values.append(rhs == 0 ? .nan : lhs / rhs)
            default: break
            }
        }

        for token in tokens {
            if let number = Double(token) {
                values.append(number)
            } else if let op = token.first, "+-*/".contains(op) {
                while let last = ops.last, precedence(last) >= precedence(op) { apply() }
                ops.append(op)
            }
        }
        while !ops.isEmpty { apply() }
        return values.first?.isFinite == true ? values.first : nil
    }

    private static func tokenize(_ expression: String) -> [String] {
        var tokens: [String] = []
        var number = ""
        for char in expression.replacingOccurrences(of: ",", with: ".") {
            if char.isNumber || char == "." {
                number.append(char)
            } else if "+-*/".contains(char) {
                if !number.isEmpty { tokens.append(number); number = "" }
                tokens.append(String(char))
            } else if char.isWhitespace, !number.isEmpty {
                tokens.append(number); number = ""
            }
        }
        if !number.isEmpty { tokens.append(number) }
        return tokens
    }
}

extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}

extension Double {
    var cleanString: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(Int(self)) : String(format: "%.2f", self)
    }
}

#Preview { DashboardView() }
#Preview { StatusView() }
#Preview { VoiceAssistantView() }
