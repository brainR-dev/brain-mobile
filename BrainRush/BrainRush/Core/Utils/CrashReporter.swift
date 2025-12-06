//
//  CrashReporter.swift
//  BrainRush
//
//  Crash reporting integration with PostHog
//

import Foundation
#if canImport(PostHog)
import PostHog
#endif
#if canImport(Darwin)
import Darwin
#endif

class CrashReporter {
    static let shared = CrashReporter()
    
    private init() {
        setupCrashReporting()
    }
    
    private func setupCrashReporting() {
        // Setup crash reporting
        NSSetUncaughtExceptionHandler { exception in
            CrashReporter.shared.handleException(exception)
        }
        
        // Setup signal handlers for crashes
        signal(SIGABRT, CrashReporter.signalHandler)
        signal(SIGILL, CrashReporter.signalHandler)
        signal(SIGSEGV, CrashReporter.signalHandler)
        signal(SIGFPE, CrashReporter.signalHandler)
        signal(SIGBUS, CrashReporter.signalHandler)
        signal(SIGPIPE, CrashReporter.signalHandler)
    }
    
    private func handleException(_ exception: NSException) {
        let exceptionInfo: [String: Any] = [
            "name": exception.name.rawValue,
            "reason": exception.reason ?? "Unknown reason",
            "callStackSymbols": exception.callStackSymbols
        ]
        
        #if canImport(PostHog)
        PostHogSDK.shared.capture("$exception", properties: exceptionInfo)
        #endif
        
        AnalyticsService.shared.trackError(
            NSError(domain: exception.name.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: exception.reason ?? ""]),
            context: exceptionInfo
        )
        
        Logger.shared.error("Uncaught exception: \(exception.name.rawValue) - \(exception.reason ?? "")")
    }
    
    static func signalHandler(_ signal: Int32) {
        let signalNames: [Int32: String] = [
            SIGABRT: "SIGABRT",
            SIGILL: "SIGILL",
            SIGSEGV: "SIGSEGV",
            SIGFPE: "SIGFPE",
            SIGBUS: "SIGBUS",
            SIGPIPE: "SIGPIPE"
        ]
        
        let signalName = signalNames[signal] ?? "Unknown"
        let stackTrace = Thread.callStackSymbols
        
        let crashInfo: [String: Any] = [
            "signal": signalName,
            "signal_code": signal,
            "stack_trace": stackTrace
        ]
        
        #if canImport(PostHog)
        PostHogSDK.shared.capture("$exception", properties: crashInfo)
        #endif
        
        AnalyticsService.shared.trackError(
            NSError(domain: "Signal", code: Int(signal), userInfo: [NSLocalizedDescriptionKey: "Crash signal: \(signalName)"]),
            context: crashInfo
        )
        
        Logger.shared.error("Crash signal: \(signalName)")
    }
    
    func reportError(_ error: Error, context: [String: Any]? = nil) {
        AnalyticsService.shared.trackError(error, context: context)
    }
}
