//
//  TextMemoViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation
import SwiftUI

@Observable
class TextMemoViewModel {
    var textMemos: [TextMemo]
    var removeTextMemos = Set<TextMemo>()
    var isEditTextMemoMode = false
    var isDisplayTextMemoDetail = false
    var isShowingAlert = false
    
    @ObservationIgnored var updateTextMemo: Bindable<TextMemo>?
    @ObservationIgnored var container: DIContainer
    
    init(container: DIContainer, textMemos: [TextMemo] = []) {
        self.container = container
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
    
    func tapTodoListItem(with todo: Bindable<TextMemo>) {
        updateTextMemo = todo
        isDisplayTextMemoDetail.toggle()
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
}

extension TextMemoViewModel {
    func fetchTextMemo(){
        textMemos = container.textMemoRealmService.fetchAllTextMemo()
    }
    
    func addTextMemo(_ textMemo: TextMemo){
        let newTextMemo = container.textMemoRealmService.saveTextMemo(textMemo)
        textMemos.append(newTextMemo)
    }
    
    func updateTextMemo(_ textMemo: TextMemo){
        container.textMemoRealmService.updateTextMemo(textMemo)
    }
    
    func removeSelectedItems(isCanceled: Bool = false) {
        if !isCanceled {
            removeTextMemos.forEach { container.textMemoRealmService.deleteTextMemo($0) }
            textMemos.removeAll { removeTextMemos.contains($0) }
        }
        removeTextMemos.removeAll()
    }
}
