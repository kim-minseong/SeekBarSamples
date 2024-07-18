/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 The app's root view.
 */

import SwiftUI

struct ContentView: View {
    @State private var isPresentMusicPlayer = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Basic") {
                    NavigationLink(destination: CatalogView()) {
                        Label(
                            title: { Text("Catalog") },
                            icon: { Text("📔") }
                        )
                    }
                }
                
                Section("Usecase") {
                    NavigationLink(destination: VideoPlayerView()) {
                        Label(
                            title: { Text("Video Player") },
                            icon: { Text("👀") }
                        )
                    }
                    
                    Label(
                        title: { Text("Music Player") },
                        icon: { Text("🎧") }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isPresentMusicPlayer = true
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("SeekBar Samples")
            .fullScreenCover(isPresented: $isPresentMusicPlayer) {
                MusicPlayerView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
