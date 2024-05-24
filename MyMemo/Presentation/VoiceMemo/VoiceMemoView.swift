//
//  VoiceMemoView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct VoiceMemoView: View {
    @Environment(VoiceMemoViewModel.self) private var voiceMemoViewModel
    @Environment(HomeViewModel.self) private var homeViewModel

    var body: some View {
        ZStack{
            if voiceMemoViewModel.voiceMemos.isEmpty {
                DefaultView(title: "음성메모", subTitle: "현재 등록된 음성메모가 없습니다.\n하단의 녹음버튼을 눌러 음성메모를 기록하세요.", icon: "waveform.and.mic")
                    .padding(20)
                    .opacity(voiceMemoViewModel.isLoading ? 0.3 : 1)
                if voiceMemoViewModel.isLoading {
                    loadingView
                }
            } else {
                VStack{
                    titleView
                    VoiceMemoListView()
                }
            }
            RecordButtonView()
                .disabled(voiceMemoViewModel.isLoading)
        }
        .alert(
          "선택된 음성메모를 삭제하시겠습니까?",
          isPresented: Bindable(voiceMemoViewModel).isDisplayRemoveVoiceRecorderAlert
        ) {
          Button("삭제", role: .destructive) {
              voiceMemoViewModel.removeSelectedVoiceRecord()
          }
          Button("취소", role: .cancel) { }
        }
        .alert(
            voiceMemoViewModel.alertMessage,
          isPresented: Bindable(voiceMemoViewModel).isDisplayAlert
        ) {
          Button("확인", role: .cancel) { }
        }
        .task{
            await voiceMemoViewModel.loadVoiceMemos()
            homeViewModel.setVoiceMemosCount(voiceMemoViewModel.voiceMemos.count)
        }
    }
    
    var titleView: some View {
        Text("음성메모")
            .frame(maxWidth: .infinity, alignment: .leading)
            .bold()
            .font(.largeTitle)
            .padding(20)
    }
    
    var loadingView: some View {
        ProgressView()
            .font(.largeTitle)
            .bold()
    }
}

private struct RecordButtonView: View {
    @Environment(VoiceMemoViewModel.self) var vm
    @State var isAnimation: Bool = false
    
    var body: some View {
        Button(action: {
            Task{
                await vm.recordBtnTapped()
            }
        }){
            if vm.isRecording {
                Image(systemName: "smallcircle.filled.circle.fill")
                    .scaleEffect(isAnimation ? 1.5 : 1)
                    .foregroundColor(.red)
                    .onAppear {
                        withAnimation(.spring().repeatForever()) {
                            isAnimation.toggle()
                        }
                    }
                    .onDisappear {
                        isAnimation = false
                    }
            } else {
                Image(systemName: "smallcircle.filled.circle.fill")
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.trailing, 20)
        .font(.largeTitle)
    }
}

private struct VoiceMemoListView: View {
    @Environment(VoiceMemoViewModel.self) var vm
    
    var body: some View {
        ScrollView{
            Divider()
            ForEach(vm.voiceMemos, id: \.self){ item in
                VoiceMemoRowView(item: item)
                    .onTapGesture {
                        withAnimation{
                            vm.onItemTapped(item)
                        }
                    }
                Divider()
            }
        }
    }
}

private struct VoiceMemoRowView: View {
    @Environment(VoiceMemoViewModel.self) var vm
    let item: VoiceMemo

    var body: some View {
        VStack(alignment: .leading, spacing: 3){
            Text(item.title)
                .bold()
            HStack{
                Text(item.day.fomattedVoiceMemoTime)
                Spacer()
                if vm.selectedVoiceMemo != item {
                    Text(item.duration.formattedTimeString)
                } else {
                    Button(action: {
                        vm.removeBtnTapped()
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
            .foregroundColor(.secondary)
            
            if vm.selectedVoiceMemo == item {
                AudioPlayerView(url: item.fileURL)
            }
        }
        .padding(.horizontal, 20)
    }
}


#Preview {
    let contaienr: DIContainer = .init()
    let voiceMemoViewModel: VoiceMemoViewModel = .init(container: contaienr)
    let HomeViewModel: HomeViewModel = .init()
    return VoiceMemoView()
        .environment(voiceMemoViewModel)
        .environment(HomeViewModel)
}
