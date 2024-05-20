//
//  DefaultView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct DefaultView: View {
    var title: String
    var subTitle: String
    
    var body: some View {
        ZStack {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.title)
                .bold()
            
            VStack{
                Image(systemName: "pencil")
                    .font(.title3)
                    .padding(3)
                VStack{
                    ForEach(subTitle.split(separator: "\n"), id: \.self){ item in
                        Text(item)
                    }
                }
                
            }
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DefaultView(title: "항목을 항목을 추가\n해보세요", subTitle: "기본메시지 기본메시지 기본메시지\n기본메시지 기본메시지 기본메시지\n 기본메시지 기본메시지")
}
