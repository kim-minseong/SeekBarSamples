/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The music player view.
 */

import SwiftUI
import SeekBar

struct MusicPlayerView: View {
    @Bindable private var musicStore = MusicStore()
    @State private var isMusicEditing = false
    @State private var volumnValue = 0.5
    @State private var isVolumnEditing = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            thumbnail
            musicInfo
            musicTrack
            musicControl
            volumnControl
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 30)
        .safeAreaInset(edge: .bottom) {
            bottomMenu
        }
        .overlay(alignment: .topLeading) {
            dismissButton
                .padding(.leading, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.thumbGradientTop, .thumbGradientBottom],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onReceive(
            Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                if !isMusicEditing {
                    let updated = musicStore.updateProgress()
                    if updated {
                        withAnimation {
                            musicStore.isPlaying = false
                        }
                    }
                }
            }
    }
    
    private var thumbnail: some View {
        ZStack {
            Image(.musicThumb)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 20, y: 10)
        }
        .frame(minHeight: 400)
        .padding(.horizontal, musicStore.isPlaying ? 45 : 0)
        .padding(.top, 24)
        .padding(.bottom, 30)
    }
    
    private var musicInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Finding Happiness")
                    .bold()
                Text("Tokyo Music Walker")
            }
            .font(.title3)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .tertiaryWhite)
            }
            .buttonStyle(.borderless)
        }
    }
    
    private var musicTrack: some View {
        VStack {
            SeekBar(
                value: $musicStore.currentTime,
                in: 0...musicStore.totalDuration,
                onEditingChanged: { edited in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isMusicEditing = edited
                    }
                    if !edited {
                        musicStore.seek(to: musicStore.currentTime)
                    }
                }
            )
            .seekBarDisplay(with: .trackOnly)
            .trackColors(
                activeTrackColor: isMusicEditing ? .white : .secondaryWhite,
                inactiveTrackColor: .tertiaryWhite
            )
            .trackDimensions(
                trackHeight: isMusicEditing ? 16 : 8,
                inactiveTrackCornerRadius: 16
            )
            
            HStack {
                Text(musicStore.currentTimeText)
                Spacer()
                Text(musicStore.totalDurationText)
            }
            .font(.caption)
            .foregroundStyle(isMusicEditing ? .white : .secondaryWhite)
        }
        .padding(.top, 20)
        .scaleEffect(isMusicEditing ? 1.05 : 1, anchor: .center)
    }
    
    private var musicControl: some View {
        HStack(spacing: 72) {
            Button(action: {}) {
                Image(systemName: "backward.fill")
                    .font(.title)
            }
            
            Button(
                action: {
                    musicStore.togglePlayMusic()
                    withAnimation {
                        musicStore.isPlaying.toggle()
                    }
                }
            ) {
                Image(systemName: musicStore.isPlaying ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .animation(nil, value: musicStore.isPlaying)
            }
            
            Button(action: {}) {
                Image(systemName: "forward.fill")
                    .font(.title)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.vertical, 32)
    }
    
    private var volumnControl: some View {
        HStack(spacing: 10) {
            Image(systemName: "speaker.fill")
                .font(.subheadline)
                .padding(.trailing, 8)
            
            // MARK: SeekBar
            SeekBar(
                value: $volumnValue,
                onEditingChanged: { edited in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isVolumnEditing = edited
                    }
                }
            )
            .seekBarDisplay(with: .trackOnly)
            .trackColors(activeTrackColor: isVolumnEditing ? .white : .secondaryWhite)
            .trackDimensions(
                trackHeight: isVolumnEditing ? 16 : 8,
                inactiveTrackCornerRadius: 16
            )
            
            Image(systemName: "speaker.wave.3.fill")
                .font(.subheadline)
        }
        .padding(.bottom, 24)
        .foregroundStyle(isVolumnEditing ? .white : .secondaryWhite)
        .scaleEffect(isVolumnEditing ? 1.05 : 1, anchor: .center)
    }
    
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.down.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .clear, .gray)
        }
        .buttonStyle(.borderless)
        .opacity(0.8)
        .font(.title)
    }
    
    private var bottomMenu: some View {
        HStack(spacing: 75) {
            Spacer()
            Button(action: {}) {
                Image(systemName: "quote.bubble")
            }
            Button(action: {}) {
                Image(systemName: "airplayaudio")
            }
            Button(action: {}) {
                Image(systemName: "list.bullet")
            }
            Spacer()
        }
        .font(.title3.bold())
        .foregroundStyle(.secondaryWhite)
    }
}

#Preview("Music Player View Preview") {
    MusicPlayerView()
}
