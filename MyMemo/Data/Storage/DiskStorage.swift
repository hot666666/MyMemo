//
//  DiskStorage.swift
//  MyMemo
//
//  Created by 최하식 on 5/22/24.
//

import Foundation
import AVFoundation

enum DiskStorageError: Error {
    case getAttributeError
    case getContentsOfDirectoryError
    case removeItemError
}

protocol DiskStorageType {
    func getFile(for url: URL) -> VoiceMemoObject?
    func getFileURLs() throws -> [URL]
    func getNewFileURL(fileName: String) -> URL
    func removeFile(url: URL) throws
}

class DiskStorage: DiskStorageType {
    
    let fileManager: FileManager
    let storedURL: URL
    
    init(fileManager: FileManager = .default,
         directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         subdirectory: String = "voiceMemos") {
        self.fileManager = fileManager
        
        let documentsURL = self.fileManager.urls(for: directory, in: domainMask)[0]
        self.storedURL = documentsURL.appendingPathComponent(subdirectory)

        /// 서브 디렉터리가 없으면 생성
        if !fileManager.fileExists(atPath: self.storedURL.path) {
            do {
                try fileManager.createDirectory(at: self.storedURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Failed to create directory: \(error)")
            }
        }
    }
    
    func getFile(for url: URL) -> VoiceMemoObject? {
        do {
            let fileName = url.lastPathComponent
            
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            let creationDate = fileAttributes[.creationDate] as? Date ?? .now

            // TODO: - Extract
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            let duration = audioPlayer.duration
            
            return VoiceMemoObject(title: fileName, day: creationDate, duration: duration, fileURL: url)
        } catch {
            return nil
        }
    }
    
    func getFileURLs() throws -> [URL] {
        do {
            return try fileManager.contentsOfDirectory(at: storedURL, includingPropertiesForKeys: nil)
        } catch {
            throw DiskStorageError.getContentsOfDirectoryError
        }
    }
    
    func getNewFileURL(fileName: String) -> URL {
        storedURL.appendingPathComponent(fileName)
    }
    
    func removeFile(url: URL) throws {
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw DiskStorageError.removeItemError
        }
    }
}
