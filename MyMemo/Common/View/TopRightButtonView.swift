//
//  TopRightButtonView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

enum TopRightButtonViewType: String{
    case close
    case edit = "편집"
    case complete = "완료"
    case create = "생성"
}

struct TopRightButtonView: View {
    let action: () -> Void
    let buttonType: TopRightButtonViewType
    
    init(action: @escaping () -> Void = {}, btnType: TopRightButtonViewType = .edit) {
        self.action = action
        self.buttonType = btnType
    }
    
    var body: some View {
        Button(action: {
            withAnimation{
                action()
            }
        }, label: {
            if buttonType == .close {
              Image("close")
            } else {
              Text(buttonType.rawValue)
                .foregroundColor(.primary)
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

#Preview {
    TopRightButtonView()
}
