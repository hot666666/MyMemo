//
//  TimerView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct TimerView: View {
    @Environment(TimerViewModel.self) var timerViewModel
    
    var body: some View {
        if !timerViewModel.isTimerView {
            TimerSettingView()
        } else {
            TimerRunningView()
        }
    }
}

struct TimerSettingView: View {
    @Environment(TimerViewModel.self) var timerViewModel
    
    var body: some View {
        VStack{
            timerTitle
            
            VStack{
                Spacer()
                Divider()
                TimePickerView()
                Divider()
                Spacer()
            }
            
            Button(action: {
                timerViewModel.setBtnTapped()
            }, label: {
                Text("설정하기")
                    .bold()
                    .foregroundColor(.primary)
            })
            .disabled(timerViewModel.isSettable)
            
            Spacer()
        }
    }
    
    var timerTitle: some View {
        HStack{
            Text("타이머")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.top, 20)
        .padding(.leading, 20)
    }
}

struct TimerRunningView: View {
    @Environment(TimerViewModel.self) var timerViewModel
    
    var body: some View {
        VStack{
            TimerCircleView()
            
            HStack{
                Button(action: {
                    timerViewModel.cancelBtnTapped()
                }, label: {
                    CircleView(text: "취소", color: .black.opacity(0.5))
                })
                .disabled(!timerViewModel.isPaused)
                .opacity(timerViewModel.isPaused ? 1 : 0.5)
                
                Spacer()
                
                Button(action: {
                    timerViewModel.pauseOrRestartBtnTapped()
                }, label: {
                    CircleView(text: (timerViewModel.isPaused ? "시작" : "정지"), color: .orange.opacity(0.5))
                })
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
        }
        .onAppear{
            timerViewModel.onAppearTimer()
        }
    }
    
    func CircleView(text: String, color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 100, height: 100)
            .overlay {
                Text(text)
            }
    }
}

private struct TimerCircleView: View {
    @Environment(TimerViewModel.self) var timerViewModel
    
    var body: some View {
        ZStack{
            Circle()
                .trim(from: timerViewModel.animationValue, to: 1.0)
                .stroke(Color.orange.opacity(0.9).gradient, lineWidth: 10)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                .rotationEffect(.degrees(-90))
                .overlay {
                    Text(timerViewModel.timeRemaining.formattedLongTimeString)
                        .font(.largeTitle)
                        .monospaced()
                }
        }
        .padding(20)
    }
}

private struct TimePickerView: View {
    @Environment(TimerViewModel.self) var timerViewModel
    
    var body: some View {
        HStack(spacing: 0){
            TimePickerComponent(selection: Bindable(timerViewModel).hour)
            TimePickerComponent(selection: Bindable(timerViewModel).minute)
            TimePickerComponent(selection: Bindable(timerViewModel).second)
        }
    }
    
    func TimePickerComponent(selection: Binding<Int>) -> some View {
        Picker("Number", selection: selection) {
            ForEach(0..<60) { number in
                Text(String(format: "%02d", number)).tag(number)
            }
        }
        .pickerStyle(.wheel)
    }
}


#Preview {
    let container: DIContainer = .init()
    let timerViewModel: TimerViewModel = .init(container: container)
    return TimerView()
        .environment(timerViewModel)
}
