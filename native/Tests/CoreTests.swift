import Foundation

@main struct CoreTests {
    static func main() throws {
        let cleaned = try QuestionInput.clean(" \n hello\r\nworld \n ")
        assert(cleaned == "hello\nworld")
        do { _ = try QuestionInput.clean(" \n "); fatalError("empty input accepted") } catch InputError.empty { }
        do { _ = try QuestionInput.clean(String(repeating: "字", count: 2001)); fatalError("long input accepted") } catch InputError.tooLong { }
        assert(QuestionInput.label("hello") == "hello")
        assert(QuestionInput.label(String(repeating: "字", count: 40)) == "this passage…")
        var gate = RequestGate()
        let first = gate.begin()
        let second = gate.begin()
        assert(!gate.accepts(first)); assert(gate.accepts(second))
        gate.invalidate(); assert(!gate.accepts(second))
        print("PASS: native input, quotation and stale-request checks")
    }
}
