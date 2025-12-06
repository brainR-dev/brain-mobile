//
//  PushNotificationService.swift
//  BrainRush
//
//  Push notification service
//

import Foundation
import UserNotifications
#if os(iOS)
import UIKit
#endif

class PushNotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PushNotificationService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            
            if granted {
                await MainActor.run {
                    #if os(iOS)
                    UIApplication.shared.registerForRemoteNotifications()
                    #endif
                }
            }
            
            return granted
        } catch {
            return false
        }
    }
    
    func registerDeviceToken(_ token: Data) async {
        guard let tokenString = token.map({ String(format: "%02.2hhx", $0) }).joined() as String?,
              let accessToken = AuthService.shared.getAccessToken() else {
            return
        }
        
        do {
            let _: EmptyResponse = try await APIClient.shared.request(
                endpoint: "/mobile/push/register",
                method: "POST",
                accessToken: accessToken,
                body: [
                    "device_token": tokenString,
                    "device_type": "ios",
                    "device_model": getDeviceModel(),
                    "os_version": getOSVersion()
                ]
            )
        } catch {
            // Handle error
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        completionHandler()
    }
    
    private func getDeviceModel() -> String {
        #if os(iOS)
        return UIDevice.current.model
        #else
        return "iOS Device"
        #endif
    }
    
    private func getOSVersion() -> String {
        #if os(iOS)
        return UIDevice.current.systemVersion
        #else
        return ProcessInfo.processInfo.operatingSystemVersionString
        #endif
    }
}
