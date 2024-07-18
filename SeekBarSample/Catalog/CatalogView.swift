/*
 Abstract:
 The catalog view.
 */

import SwiftUI
import SeekBar

struct CatalogView: View {
    @State private var value = 0.0
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section("Appearance") {
                Group {
                    // MARK: Default SeekBar
                    SeekBar(value: $value)
                    
                    // MARK: SeekBar with Track only style
                    SeekBar(value: $value)
                        .seekBarDisplay(with: .trackOnly)
                        .trackDimensions(trackHeight: 10, inactiveTrackCornerRadius: 10)
                        .trackColors(activeTrackColor: .blue)
                    
                    // MARK: SeekBar with handle, track color changed.
                    SeekBar(value: $value)
                        .handleColors(handleColor: .red)
                        .handleDimensions(handleSize: 24)
                        .trackColors(activeTrackColor: .red)
                }
                .padding(.vertical, 16)
            }
            
            Section("Action") {
                Group {
                    // MARK: SeekBar action move with value.
                    SeekBar(value: $value)
                        .seekBarTrackAction(with: .moveWithValue)
                    
                    // MARK: SeekBar action interact with only handle
                    SeekBar(value: $value)
                        .seekBarInteractive(with: .handle)
                        .trackColors(activeTrackColor: .accentColor)
                }
                .padding(.vertical, 16)
            }
            
            Section("With Animation") {
                Group {
                    // MARK: SeekBar Change colors and dimensions
                    SeekBar(
                        value: $value,
                        onEditingChanged: { edited in
                            withAnimation {
                                isEditing = edited
                            }
                        }
                    )
                    .handleDimensions(handleSize: isEditing ? 12 : 0)
                    .handleColors(handleColor: isEditing ? .red : HandleDefaults.handleColor)
                    .trackColors(activeTrackColor: isEditing ? .red : .white)
                    .frame(height: 12)
                    
                    // MARK: SeekBar Change colors and dimensions 2
                    SeekBar(
                        value: $value,
                        onEditingChanged: { edited in
                            withAnimation {
                                isEditing = edited
                            }
                        }
                    )
                    .seekBarDisplay(with: .trackOnly)
                    .trackDimensions(
                        trackHeight: isEditing ? 24 : 12,
                        inactiveTrackCornerRadius: 24
                    )
                    .trackColors(
                        activeTrackColor: isEditing ? .white : .gray
                    )
                    .frame(height: 24)
                }
                .padding(.vertical, 16)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Catalog")
    }
}

#Preview("Catalog View Preview") {
    NavigationStack {
        CatalogView()
            .preferredColorScheme(.dark)
    }
}
