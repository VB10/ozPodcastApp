//
//  NetworkFile.swift
//  ozPodcastApp
//
//  Created by vb10 on 30.04.2025.
//

import Alamofire
import Foundation

struct NetworkFile {
    // name: Document directory path
    func destinationForDownloadedFile(name: String) -> DownloadRequest.Destination? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = documentsPath.appendingPathComponent("\(name).mp4")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        return destination
    }
    
    func deleteDownloadedFile(name: String) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let fileURL = documentsPath.appendingPathComponent(name)
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}
