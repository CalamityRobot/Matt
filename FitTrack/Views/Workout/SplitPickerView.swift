import SwiftUI

struct SplitPickerView: View {
    var onSelect: (Split) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Choose today's split")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)

                ForEach(Split.allCases) { split in
                    Button {
                        onSelect(split)
                    } label: {
                        SplitCard(split: split)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

struct SplitCard: View {
    let split: Split

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: split.symbol)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(split.color, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 3) {
                Text(split.title).font(.title3.bold())
                Text(split.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}
