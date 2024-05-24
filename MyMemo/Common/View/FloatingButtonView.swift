//
//  FloatingButtonView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct FloatingButtonView: View {
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }){
            Image(systemName: "plus.circle.fill")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .font(.largeTitle)
        .foregroundColor(.primary)
    }
}

#Preview {
    FloatingButtonView(action: {})
}
