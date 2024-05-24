//
//  TextMemoDetailView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

private enum ViewMode {
    case create
    case update
}

struct TextMemoDetailView: View {
    @Environment(TextMemoViewModel.self) var vm
    @State var textMemo: TextMemo
    @FocusState private var isTitleFieldFocused: Bool
    
    private var originalTextMemo: Bindable<TextMemo>?
    private var viewMode: ViewMode {
        originalTextMemo == nil ? .create : .update
    }
    
    init(originalTextMemo: Bindable<TextMemo>? = nil){
        if let originalTextMemo = originalTextMemo {
            _textMemo = State(wrappedValue: originalTextMemo.wrappedValue)
            self.originalTextMemo = originalTextMemo
        } else {
            _textMemo = State(wrappedValue: TextMemo())
        }
    }
    
    var body: some View {
        ZStack{
            TopRightButtonView(action: {
                if var originalTextMemo = originalTextMemo {
                    originalTextMemo.wrappedValue = textMemo
                    vm.updateTextMemo(originalTextMemo.wrappedValue)
                } else {
                    vm.addTextMemo(textMemo)
                }
                vm.toggleIsDisplayTextMemoDetail()
            }, btnType: viewMode == .create ? .create : .complete)
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
        .padding(20)
        .onAppear{
            if viewMode == .create {
                isTitleFieldFocused = true
            }
        }
    }
}

#Preview {
    let textMemoViewModel: TextMemoViewModel = .init(container: .init())
    return TextMemoDetailView().environment(textMemoViewModel)
}
