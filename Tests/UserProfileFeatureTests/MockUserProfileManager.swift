//
//  MockUserProfileManager.swift
//  UserProfileFeature
//
//  Created by COMATOKI on 2026-08-24.
//

import Foundation
import WakTrainerCoreModels

public final class MockUserProfileManager: UserProfileManager, @unchecked Sendable {
    public var profile: UserProfile?
    public var saveProfileCalled = false
    
    public init(initialProfile: UserProfile? = nil) {
        self.profile = initialProfile
    }
    
    public func saveProfile(_ profile: UserProfile) {
        self.saveProfileCalled = true
        self.profile = profile
    }
    
    public func loadProfile() -> UserProfile? {
        return profile
    }
}
