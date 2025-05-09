//
//  MusicHelper.swift
//  ozPodcastApp
//
//  Created by vb10 on 30.04.2025.
//

import Foundation


struct MusicDocumentHelper {
    /// The path to the file relative to the Documents directory.
    let relativePath: String

    // Returns the full URL to the file in the Documents directory if it exists.
    var documentURL: URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let fileURL = documentsURL.appendingPathComponent(relativePath)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        return fileURL
    }
}
