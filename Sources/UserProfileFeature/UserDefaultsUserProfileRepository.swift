import Foundation
import WakTrainerCoreModels

/// Local profile repository compatible with the existing DefaultUserProfileManager key.
public actor UserDefaultsUserProfileRepository: UserProfileRepository {
    public static let legacyStorageKey = "WakTrainer_UserProfileData"

    private let userDefaults: UserDefaults
    private let storageKey: String

    public init(
        userDefaults: UserDefaults = .standard,
        storageKey: String = UserDefaultsUserProfileRepository.legacyStorageKey
    ) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
    }

    public func fetchProfile() async throws -> UserProfile? {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return nil
        }
        return try JSONDecoder().decode(UserProfile.self, from: data)
    }

    public func saveProfile(_ profile: UserProfile) async throws {
        let encoded = try JSONEncoder().encode(profile)
        userDefaults.set(encoded, forKey: storageKey)
    }
}
