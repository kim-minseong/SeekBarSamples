/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The video view.
 */

import SwiftUI
import AVKit
import SeekBar

struct VideoPlayerView: View {
    @Bindable private var videoStore = VideoStore()
    
    @State private var timeoutTask: DispatchWorkItem?
    @State private var isShowingPlayerControls = true
    @GestureState private var isDragging = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Video player.
            videoPlayer
            
            // Background dimming view.
            Rectangle().fill(.black.opacity(0.4))
                .opacity(isShowingPlayerControls || isDragging ? 1 : 0)
                .animation(.easeInOut(duration: 0.35), value: isDragging)
        }
        .ignoresSafeArea()
        .overlay {
            playerControls
        }
        .safeAreaInset(edge: .bottom) {
            bottomMenu
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.35)) {
                isShowingPlayerControls.toggle()
            }
            
            if videoStore.isPlaying {
                scheduleHidePlayerControls()
            }
        }
        .navigationBarBackButtonHidden()
        .foregroundStyle(.white)
        .onAppear {
            AppDelegate.orientationLock = .landscapeRight
        }
        .onDisappear {
            videoStore.resetVideo()
            AppDelegate.orientationLock = .portrait
        }
    }
    
    @ViewBuilder
    private var videoPlayer: some View {
        if let videoPlayer = videoStore.player {
            VideoPlayer(player: videoPlayer)
        } else {
            EmptyView()
        }
    }
    
    private var playerControls: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 30) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .bold()
                }
                
                VStack(alignment: .leading) {
                    Text("Big Buck Bunny")
                        .font(.title3)
                        .bold()
                    Text("blender")
                        .font(.subheadline)
                        .foregroundStyle(.secondaryWhite)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "airplayvideo")
                }
                
                Button(action: {}) {
                    Image(systemName: "tray")
                }
                
                Button(action: {}) {
                    Image(systemName: "gearshape")
                }
            }
            
            HStack(spacing: 45) {
                PlayBackButton(systemName: "backward.end.fill", size: .title3)
                
                PlayBackButton(
                    systemName: videoStore.isFinishedPlaying ? "arrow.clockwise" : (videoStore.isPlaying ? "pause.fill" : "play.fill")
                ) {
                    videoStore.togglePlayVideo()
                    
                    if videoStore.isPlaying {
                        if let timeoutTask {
                            timeoutTask.cancel()
                        }
                    } else {
                        scheduleHidePlayerControls()
                    }
                    
                    videoStore.isPlaying.toggle()
                }
                
                PlayBackButton(systemName: "forward.end.fill", size: .title3)
            }
            .frame(maxHeight: .infinity)
            .padding(.top, 30)
            
            HStack {
                Text(videoStore.currentTimeText)
                    .bold()
                    .foregroundStyle(.white)
                Text("/")
                Text(videoStore.totalDurationText)
                Spacer()
            }
            .font(.caption)
            .foregroundStyle(.secondaryWhite)
            
            // MARK: SeekBar
            SeekBar(
                value: $videoStore.currentTime,
                bufferedValue: videoStore.bufferedValue,
                in: 0...videoStore.totalDuration,
                onEditingChanged: { edited in
                    // On Changed
                    if edited {
                        if let timeoutTask {
                            timeoutTask.cancel()
                        }
                    }
                    
                    // Ended
                    if !edited {
                        videoStore.seek(to: videoStore.currentTime)
                        if videoStore.isPlaying {
                            scheduleHidePlayerControls()
                        }
                    }
                    
                    withAnimation(.easeInOut(duration: 0.35)) {
                        videoStore.isSeeking = edited
                    }
                }
            )
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, transaction in
                        state = true
                    }
            )
            .handleDimensions(handleSize: videoStore.isSeeking ? 16 : 12)
            .handleColors(handleColor: .red)
            .trackColors(activeTrackColor: .red)
            .frame(minHeight: 30)
        }
        .padding(.vertical, 10)
        .opacity(isShowingPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isShowingPlayerControls && !isDragging)
    }
    
    private var bottomMenu: some View {
        HStack(spacing: 30) {
            Button(action: {}) {
                Image(systemName: "hand.thumbsup")
            }
            
            Button(action: {}) {
                Image(systemName: "hand.thumbsdown")
            }
            
            Button(action: {}) {
                Image(systemName: "quote.bubble")
            }
            
            Button(action: {}) {
                Image(systemName: "bookmark")
            }
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
            }
            
            Spacer()
        }
        .opacity(isShowingPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isShowingPlayerControls && !isDragging)
    }
    
    private func scheduleHidePlayerControls() {
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.35)) {
                isShowingPlayerControls = false
            }
        }
        
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: timeoutTask)
        }
    }
}

private struct PlayBackButton: View {
    let systemName: String
    var size: Font = .title
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(size)
                .foregroundStyle(.white)
                .padding(15)
                .background {
                    Circle()
                        .fill(.black.opacity(0.35))
                }
        }
    }
}

#Preview("Video Player View Preview") {
    VideoPlayerView()
}
