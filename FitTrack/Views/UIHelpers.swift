import SwiftUI
import UIKit

extension Color {
    /// High-contrast accent for tappable text on dark list backgrounds.
    static let lime = Color(red: 0.49, green: 0.84, blue: 0.13)
}

extension View {
    /// Resigns the first responder, dismissing the keyboard / number pad.
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
}
