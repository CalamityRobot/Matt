import SwiftUI

struct SettingsView: View {
    @AppStorage("preferredUnit") private var preferredUnitRaw = WeightUnit.lbs.rawValue
    @Environment(\.openURL) private var openURL

    private let repoURL = URL(string: "https://github.com/CalamityRobot/Matt")!

    private var version: String {
        let info = Bundle.main.infoDictionary
        let short = info?["CFBundleShortVersionString"] as? String ?? "—"
        let build = info?["CFBundleVersion"] as? String ?? "—"
        return "\(short) (\(build))"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Picker("Weight Unit", selection: $preferredUnitRaw) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.label).tag(unit.rawValue)
                        }
                    }
                }

                Section {
                    Button {
                        openURL(repoURL)
                    } label: {
                        Label("Check for Updates", systemImage: "arrow.down.circle")
                    }
                } header: {
                    Text("Updates")
                } footer: {
                    Text("Opens the FitTrack project on GitHub. To install the newest version, pull the latest changes and run the app from Xcode on your iPhone.")
                }

                Section("About") {
                    LabeledContent("Version", value: version)
                    Link(destination: repoURL) {
                        Label("GitHub Repository", systemImage: "link")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
