import Cocoa

extension Sequence {
    func isSubset<S: Sequence>(of other: S, by areEquivalent: (Element, S.Element) -> Bool) -> Bool {
        for element in self {
            guard other.contains(where: { areEquivalent(element, $0) }) else {
                return false
            }
        }
        return true
    }
   
}
