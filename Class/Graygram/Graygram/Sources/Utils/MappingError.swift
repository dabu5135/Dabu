
import Foundation

struct MappingError: Error, CustomStringConvertible {
  
  let description: String
  
  init(from: Any, to: Any.Type) {
    self.description = "Failed to mapping \(from) to \(to)"
  }
}
