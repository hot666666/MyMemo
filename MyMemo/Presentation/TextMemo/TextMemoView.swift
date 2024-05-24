//
//  TextMemoView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct TextMemoView: View {
    @Environment(TextMemoViewModel.self) private var textMemoViewModel
    
    var body: some View {
        ZStack{
            if textMemoViewModel.textMemos.isEmpty {
                DefaultView(title: "메모를\n추가해 보세요.", subTitle: "\"앱 아이디어 메모\"\n\"여행 위치 메모\"\n\"주식 정보 메모\"")
                    .padding(20)
            } else {
                TopRightButtonView(action: {
                    textMemoViewModel.topRightButtonTapped()
                }, btnType: textMemoViewModel.topRightButtonViewType)
                    .padding(20)
                TextMemoContentView()
                    .padding(20)
            }
            
            if !textMemoViewModel.isEditTextMemoMode {
                FloatingButtonView(action: {
                    textMemoViewModel.toggleIsDisplayTextMemoDetail()
                })
                .padding(.trailing, 20)
            }
        }
        .sheet(isPresented: Bindable(textMemoViewModel).isDisplayTextMemoDetail,
               onDismiss: { textMemoViewModel.updateTextMemo = nil },
               content: { TextMemoDetailView(originalTextMemo: textMemoViewModel.updateTextMemo) })
        .alert(isPresented: Bindable(textMemoViewModel).isShowingAlert){
            Alert(
                title: Text("알림"),
                message: Text("\(textMemoViewModel.removeTextMemosCount)개를 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("확인")) {
                    textMemoViewModel.removeSelectedItems()
                },
                secondaryButton: .cancel(Text("취소")) {
                    textMemoViewModel.removeSelectedItems(isCanceled: true)
                }
            )
        }
        .onAppear {
            textMemoViewModel.fetchTextMemo()
        }
        .environment(textMemoViewModel)
    }
}

private struct TextMemoContentView: View {
    @Environment(TextMemoViewModel.self) var vm
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(vm.textMemosCount)개의 메모가\n있습니다.")
                .font(.title)
                .bold()
                .padding(.bottom, 30)
            
            Text("메모 목록")
                .bold()
            
            ScrollView {
                Divider()
                ForEach(vm.textMemos){ textMemo in
                    TextMemoContenCellView(textMemo: textMemo)
                    Divider()
                }
            }
            
            Spacer()
        }
    }
}

private struct TextMemoContenCellView: View {
    @Environment(TextMemoViewModel.self) var vm
    let textMemo: TextMemo
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(textMemo.title)
                Text("\(textMemo.day.formattedDay) - \(textMemo.day.formattedTime)")
            }
            .onTapGesture {
                vm.tapTodoListItem(with: Bindable(textMemo))
            }
            
            Spacer()
            
            if vm.isEditTextMemoMode {
                Button(
                    action: {
                        vm.tapTextMemoInEditMode(textMemo)
                    },
                    label: { vm.isSelectedInEditMode(textMemo) ? Image(systemName: "circlebadge.fill") : Image(systemName: "circlebadge") }
                )
                .font(.title)
                .foregroundColor(.primary)
            }
        }
    }
}



#Preview("TextMemo") {
    let textMemoViewModel: TextMemoViewModel = .init(container: .init(), textMemos: TextMemo.stub)
    return TextMemoView().environment(textMemoViewModel)
}
