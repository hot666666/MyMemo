//
//  TextMemoDetailView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct TextMemoDetailView: View {
    @Environment(TextMemoViewModel.self) var vm
    @State var textMemo = TextMemo()
    @FocusState private var isTitleFieldFocused: Bool
    
    var body: some View {
        ZStack{
            TopRightButtonView(action: {
                vm.addTextMemo(textMemo)
                vm.toggleIsDisplayTextMemoDetail()
            }, btnType: .create)
            .disabled(textMemo.title.isEmpty || textMemo.content.isEmpty)
            .opacity((textMemo.title.isEmpty || textMemo.content.isEmpty) ? 0.3 : 1)
            
            VStack{
                TextField("메모 이름을 입력하세요", text: $textMemo.title)
                    .font(.title)
                    .focused($isTitleFieldFocused)
                TextField("메모 내용을 입력하세요", text: $textMemo.content)
                
                Spacer()
            }
            .offset(y: 20)
        }
        .onAppear{
            isTitleFieldFocused = true
        }
    }
}

#Preview {
    let textMemoViewModel: TextMemoViewModel = .init()
    return TextMemoDetailView().environment(textMemoViewModel)
}
