import Foundation

enum InputError: LocalizedError {
    case empty, tooLong
    var errorDescription: String? {
        switch self {
        case .empty: "Drop some text here, or paste with ⌘V."
        case .tooLong: "Try a shorter passage (up to 2,000 characters)."
        }
    }
}

enum QuestionInput {
    static func clean(_ value: String) throws -> String {
        let text = value.replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\0", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { throw InputError.empty }
        guard text.count <= 2000 else { throw InputError.tooLong }
        return text
    }
    static func label(_ text: String) -> String {
        text.count > 24 || text.contains("\n") ? "this passage…" : text
    }
}

struct RequestGate {
    private var current = UUID()
    mutating func begin() -> UUID { current = UUID(); return current }
    mutating func invalidate() { current = UUID() }
    func accepts(_ id: UUID) -> Bool { id == current }
}
