import SwiftUI

extension Color {
    static let primaryGreen = Color(red: 0.20, green: 0.65, blue: 0.45)
    static let streakOrange = Color(red: 0.95, green: 0.55, blue: 0.15)
    static let cardBackground = Color.gray.opacity(0.12)
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
}
