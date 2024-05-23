//
//  AudioRecordService.swift
//  MyMemo
//
//  Created by 최하식 on 5/22/24.
//

import Foundation
import AVFoundation

enum AudioRecordServiceError: Error{
    case initError
}

protocol AudioRecordServiceType {
    var isAudioCaptureAuthorized: Bool { get }
    func requestPermission()
    func startRecording(fileURL: URL) async throws
    func stopRecording() async -> URL? 
}

actor AudioRecordService: AudioRecordServiceType {
    nonisolated var isAudioCaptureAuthorized: Bool {
        AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    nonisolated func requestPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("Access granted")
            } else {
                print("Access not granted")
            }
        }
    }
    
    private var audioRecorder: AVAudioRecorder? = nil
    private var settings: [String: Int] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
    ]
    
    private func initSession(){ /// AVAudioSession은 오디오 녹음 및 재생을 관리하는 싱글톤 객체, 녹음전 초기화 필요
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording(fileURL: URL) async throws {
        do {
            initSession()
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
        } catch {
            throw AudioRecordServiceError.initError
        }
    }
    
    func stopRecording() async -> URL? {
        if let audioRecorder = audioRecorder{
            audioRecorder.stop()
            self.audioRecorder = nil
            return audioRecorder.url
        }
        return nil
    }
    
}
