//
//  AudioPlayerView.swift
//  MyMemo
//
//  Created by 최하식 on 5/22/24.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let url: URL
    private let UPDATE_SEC = 0.1
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    var body: some View {
            VStack {
                VStack{
                    
                    Slider(value: Binding(get: {currentTime},
                                          set: { newValue in seekAudio(to: newValue)}),
                           in: 0...totalTime
                    )
                    .accentColor(.gray)
                    
                    HStack {
                        Text(currentTime.formattedTimeString)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                            .onTapGesture {
                                isPlaying ? stopAudio() : playAudio()
                            }
                        Spacer()
                        Text(totalTime.formattedTimeString)
                            .font(.subheadline)
                    }
                    .padding(.vertical, 5)
                }
            }
            .foregroundColor(.primary)
        .task{
            await setupAudio(url: url)
        }
        .onReceive(Timer.publish(every: UPDATE_SEC, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
        .onDisappear {
            player?.stop()
            player = nil
        }
    }
}

extension AudioPlayerView {
    private func test(url: URL) async throws -> AVAudioPlayer{
        try AVAudioPlayer(contentsOf: url)
    }
    
    @MainActor
    private func setupAudio(url: URL) async {
        do {
            player = try await test(url: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    private func playAudio(){
        player?.play()
        isPlaying = true
    }
    
    private func stopAudio(){
        player?.pause()
        isPlaying = false
    }
    
    private func updateProgress() {
        DispatchQueue.main.async {
            guard let player = player else { return }
            currentTime = player.currentTime
            if currentTime > totalTime-UPDATE_SEC {
                isPlaying = false
            }
        }
    }
    
    private func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
    }
}

#Preview {
    guard let url = Bundle.main.url(forResource: "example", withExtension: "mp3") else { return Text("error") }
    return AudioPlayerView(url: url)
}
