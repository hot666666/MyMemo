//
//  VoiceMemoViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/21/24.
//

import Foundation
import AVFoundation

@Observable
class VoiceMemoViewModel{
    @ObservationIgnored var container: DIContainer
    
    var voiceMemos: [VoiceMemo]
    var selectedVoiceMemo: VoiceMemo? = nil
    var isDisplayRemoveVoiceRecorderAlert: Bool = false
    var isDisplayAlert: Bool = false
    var alertMessage: String = ""
    var isLoading: Bool = false
    
    /// 음성메모 녹음 관련 프로퍼티
    var isRecording: Bool = false
    
    init(container: DIContainer, voiceMemos: [VoiceMemo] = []) {
        self.container = container
        self.voiceMemos = voiceMemos
    }
}

extension VoiceMemoViewModel {
    @MainActor
    func loadVoiceMemos() async {
        isLoading = true
        if let res = await _fetchModel(){
            voiceMemos = res
        }
        isLoading = false
    }
    
    func removeSelectedVoiceRecord() {
        guard let voiceMemoToRemove = selectedVoiceMemo else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        let fileToRemove = voiceMemoToRemove.fileURL
        
        do {
            try container.diskStorage.removeFile(url: fileToRemove)
            if let indexToRemove = voiceMemos.firstIndex(of: voiceMemoToRemove){
                voiceMemos.remove(at: indexToRemove)
            }
            
            selectedVoiceMemo = nil
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    func onItemTapped(_ item: VoiceMemo) {
        if selectedVoiceMemo == item {
            selectedVoiceMemo = nil
        } else {
            selectedVoiceMemo = item
        }
    }
    
    func removeBtnTapped() {
      setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    private func _fetchModel() async -> [VoiceMemo]? {
        if let fileURLs = try? container.diskStorage.getFileURLs(){
            return fileURLs.compactMap { container.diskStorage.getFile(for: $0) }.map { $0.toModel() }
        }
        return nil
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
      isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
      alertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
      isDisplayAlert = isDisplay
    }
    
    private func displayAlert(message: String) {
      setErrorAlertMessage(message)
      setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음 관련
extension VoiceMemoViewModel {
    func recordBtnTapped() async {
        if isRecording{
            await stopRecording()
            return
        }
        
        if audioCaptureAuthorized == .authorized {
            await startRecording()
        } else {
            requestPermission()
        }
    }
    
    private var audioCaptureAuthorized: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .audio)
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Access granted")
                } else {
                    print("Access not granted")
                }
            }
        }
    }
    
    @MainActor
    private func startRecording() async {
        defer {
            self.isLoading = false
        }
        let fileURL = container.diskStorage.getNewFileURL(fileName: Date.now.fomattedFullDate)
        
        do {
            self.isLoading = true
            try await container.audioRecordService.startRecording(fileURL: fileURL)
            self.isRecording = true
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    @MainActor
    private func stopRecording() async {
        if let url = await container.audioRecordService.stopRecording(){
            if let voiceMemoObject = container.diskStorage.getFile(for: url){
                let voiceMemo = voiceMemoObject.toModel()
                self.voiceMemos.append(voiceMemo)
            }
        }
        self.isRecording = false
    }
}
