//
//  Logger.swift
//  BrainRush
//
//  Logging utility for debugging and monitoring
//

import Foundation
import OSLog

enum LogLevel: String {
    case debug = "🔍 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
}

struct Logger {
    static let shared = Logger()
    private let logger = OSLog(subsystem: "com.brainrash.BrainRush", category: "App")
    
    private init() {}
    
    func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level.rawValue)] \(fileName):\(line) \(function) - \(message)"
        
        switch level {
        case .debug:
            os_log("%{public}@", log: logger, type: .debug, logMessage)
        case .info:
            os_log("%{public}@", log: logger, type: .info, logMessage)
        case .warning:
            os_log("%{public}@", log: logger, type: .default, logMessage)
        case .error:
            os_log("%{public}@", log: logger, type: .error, logMessage)
        }
        
        #if DEBUG
        print(logMessage)
        #endif
    }
    
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
