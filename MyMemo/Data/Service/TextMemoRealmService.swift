//
//  TextMemoRealmService.swift
//  MyMemo
//
//  Created by 최하식 on 5/24/24.
//

import Foundation

protocol TextMemoRealmServiceType {
    func fetchAllTextMemo() -> [TextMemo]
    func saveTextMemo(_ textMemo: TextMemo) -> TextMemo
    func updateTextMemo(_ textMemo: TextMemo)
    func deleteTextMemo(_ textMemo: TextMemo)
}

final class TextMemoRealmService: TextMemoRealmServiceType {
    private let dataRepository: RealmRepositoryProtocol

    init(dataRepository: RealmRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func fetchAllTextMemo() -> [TextMemo] {
        return dataRepository.fetchAll(TextMemoEntity.self).map { $0.toModel() }
    }

    func saveTextMemo(_ textMemo: TextMemo) -> TextMemo {
        let textMemoEntity = textMemo.toEntity()
        dataRepository.save(textMemoEntity)
        return textMemoEntity.toModel()
    }

    func updateTextMemo(_ textMemo: TextMemo) {
        dataRepository.update(textMemo.toEntity())
    }

    func deleteTextMemo(_ textMemo: TextMemo) {
        if let textMemoEntity = dataRepository.existingObject(TextMemoEntity.self, by: textMemo.id) {
            dataRepository.delete(textMemoEntity)
        }
    }
}
