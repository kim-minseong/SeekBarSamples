/*
 Abstract:
 An extension for handling timecode strings.
 */

import Foundation

extension Double {
    // Converts the double value to a timecode string.
    func toTimecodeString(format: String = "%02d:%02d") -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: format, minutes, seconds)
    }
}
