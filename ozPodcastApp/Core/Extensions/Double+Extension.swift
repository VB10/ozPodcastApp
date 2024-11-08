//
//  Double+Extension.swift
//  ozPodcastApp
//
//  Created by vb10 on 8.11.2024.
//

extension Double {
    /// Convert tou your double value into time format
    ///
    /// - Returns: "HH:mm:ss"
    func timeString() -> String {
        let hours = Int(self / 3600)
        let minutes = Int(self / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: " %02d:%02d:%02d", hours, minutes, seconds)
    }
}
