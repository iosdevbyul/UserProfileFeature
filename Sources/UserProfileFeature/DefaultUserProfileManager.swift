//
//  DefaultUserProfileManager.swift
//  UserProfileFeature
//
//  Created by COMATOKI on 2026-08-23.
//

import Foundation
import WakTrainerCoreModels

public final class DefaultUserProfileManager: UserProfileManager, @unchecked Sendable {
    public static let shared = DefaultUserProfileManager()
    
    private var _profile: UserProfile?
    private let queue = DispatchQueue(label: "com.waktrainer.userprofilemanager", attributes: .concurrent)
    private let storageKey = "WakTrainer_UserProfileData"
    
    public var profile: UserProfile? {
        queue.sync { _profile }
    }
    
    private init() {
        _ = loadProfile()
    }
    
    public func saveProfile(_ profile: UserProfile) {
        queue.async(flags: .barrier) {
            self._profile = profile
            if let encoded = try? JSONEncoder().encode(profile) {
                UserDefaults.standard.set(encoded, forKey: self.storageKey)
            }
        }
    }
    
    @discardableResult
    public func loadProfile() -> UserProfile? {
        queue.sync {
            if let savedData = UserDefaults.standard.data(forKey: storageKey),
               let decoded = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
                self._profile = decoded
                return decoded
            }
            return nil
        }
    }
}
