import SwiftUI

@available(macOS 13.0, *)
struct ThemePickerView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    
    var body: some View {
        Menu {
            ForEach(Theme.allCases, id: \.self) { theme in
                Button(action: {
                    themeSettings.setTheme(theme)
                }) {
                    HStack {
                        Image(systemName: theme.icon)
                        Text(theme.rawValue)
                        if themeSettings.selectedTheme == theme {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: themeSettings.selectedTheme.icon)
                .font(.title2)
                .foregroundColor(.secondary)
                .frame(width: 32, height: 32)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .menuStyle(.borderlessButton)
        .help("Tema Seçimi")
    }
}

#Preview {
    ThemePickerView()
        .environmentObject(ThemeSettings())
} 