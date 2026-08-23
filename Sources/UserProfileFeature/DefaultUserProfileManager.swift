//
//  DefaultUserProfileManager.swift
//  UserProfileFeature
//
//  Created by COMATOKI on 2026-08-23.
//

import Foundation
import WakTrainerCoreModels

public final class DefaultUserProfileManager: UserProfileManager {
    public static let shared = DefaultUserProfileManager()
    
    public private(set) var profile: UserProfile?
    private let storageKey = "WakTrainer_UserProfileData"
    
    private init() {
        _ = loadProfile()
    }
    
    public func saveProfile(_ profile: UserProfile) {
        self.profile = profile
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    @discardableResult
    public func loadProfile() -> UserProfile? {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONEncoder().decode(UserProfile.self, from: savedData) {
            self.profile = decoded
            return decoded
        }
        return nil
    }
}
