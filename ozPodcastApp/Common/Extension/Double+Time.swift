//
//  Double+Time.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

extension Double {
    /// Double değerini saat, dakika ve saniye formatına dönüştürür.
    ///
    /// - Returns: "HH:mm:ss" formatında bir String.
    func timeString() -> String {
        let totalSeconds = Int(self)

        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        // return formatted string
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
