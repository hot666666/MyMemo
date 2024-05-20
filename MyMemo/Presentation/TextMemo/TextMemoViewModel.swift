//
//  TextMemoViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation
import Observation

@Observable
class TextMemoViewModel {
    var textMemos: [TextMemo]
    var removeTextMemos = Set<TextMemo>()
    var isEditTextMemoMode = false
    var isDisplayTextMemoDetail = false
    var isShowingAlert = false

    init(textMemos: [TextMemo] = []) {
        self.textMemos = textMemos
    }
}

extension TextMemoViewModel {
    var topRightButtonViewType: TopRightButtonViewType {
        isEditTextMemoMode ? .complete : .edit
    }
    
    var textMemosCount: Int {
        textMemos.count
    }
    
    var removeTextMemosCount: Int {
        removeTextMemos.count
    }
    
    func toggleIsDisplayTextMemoDetail(){
        isDisplayTextMemoDetail.toggle()
    }
    
    func addTextMemo(_ textMemo: TextMemo){
        textMemos.append(textMemo)
    }
    
    func isSelectedInEditMode(_ textMemo: TextMemo) -> Bool {
        removeTextMemos.contains { textMemo.id == $0.id }
    }
    
    func tapTextMemoInEditMode(_ textMemo: TextMemo){
        if removeTextMemos.contains(where: {textMemo.id == $0.id}) {
            removeTextMemos.remove(textMemo)
        } else {
            removeTextMemos.insert(textMemo)
        }
    }
    
    func topRightButtonTapped() {
        if !isEditTextMemoMode {
            isEditTextMemoMode = true
        } else {
            if !removeTextMemos.isEmpty {
                isShowingAlert = true
            }
            isEditTextMemoMode = false
        }
    }
    
    func removeSelectedItems(isCanceled: Bool = false) {
        if !isCanceled{
            textMemos.removeAll { todo in
                removeTextMemos.contains(todo)
            }
        }
        removeTextMemos.removeAll()
    }
}
