//
//  LoggerManager.swift
//  ozPodcastApp
//
//  Created by Mert Saygılı on 27.10.2024.
//

import os
import Foundation

// MARK: - Logger
final class LoggerManager {
    static let shared = LoggerManager()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.default.ozPodcastApp", category: "Network")

    private init() {}

    func log(_ message: String, level: LogLevel = .info) {
        let logMessage = "\(level.emoji) \(message) [\(level.rawValue.uppercased())]"
        
        switch level {
        case .debug:
            logger.debug("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .warning:
            logger.warning("\(logMessage, privacy: .public)")
        }
    }
}

// MARK: - LogLevel
enum LogLevel: String {
    case debug
    case info
    case warning
    case error
    
    var emoji: String {
        switch self {
        case .debug: return "🐞"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
}
