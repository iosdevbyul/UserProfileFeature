import Foundation
import Testing
import WakTrainerCoreModels
@testable import UserProfileFeature

@Suite("UserDefaults profile repository")
struct UserProfileRepositoryTests {
    @Test("Absent profile returns nil and saved profile round-trips")
    func roundTrip() async throws {
        let suiteName = "UserProfileRepositoryTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let repository = UserDefaultsUserProfileRepository(userDefaults: defaults)
        #expect(try await repository.fetchProfile() == nil)

        let profile = UserProfile(
            gender: .male,
            birthDate: Date(timeIntervalSince1970: 1_125_014_400),
            heightCm: 175,
            weightKg: 70
        )
        try await repository.saveProfile(profile)
        #expect(try await repository.fetchProfile() == profile)
        #expect(defaults.data(forKey: UserDefaultsUserProfileRepository.legacyStorageKey) != nil)
    }

    @Test("Corrupt stored profile surfaces decoding failure")
    func corruptData() async throws {
        let suiteName = "UserProfileRepositoryTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }
        defaults.set(Data([0x00, 0x01]), forKey: UserDefaultsUserProfileRepository.legacyStorageKey)
        let repository = UserDefaultsUserProfileRepository(userDefaults: defaults)
        await #expect(throws: DecodingError.self) {
            _ = try await repository.fetchProfile()
        }
    }
}
