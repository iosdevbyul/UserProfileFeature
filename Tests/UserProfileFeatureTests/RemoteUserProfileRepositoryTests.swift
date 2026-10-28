import Foundation
import Testing
import WakTrainerCoreModels
@testable import UserProfileFeature

private actor RemoteProfileTransportSpy: UserProfileRemoteTransport {
    private var storedProfile: UserProfile?
    private var fetches = 0
    private var saves = 0

    func fetchProfile() async throws -> UserProfile? {
        fetches += 1
        return storedProfile
    }

    func saveProfile(_ profile: UserProfile) async throws {
        saves += 1
        storedProfile = profile
    }

    func counts() -> (Int, Int) { (fetches, saves) }
}

@Suite("Remote profile repository")
struct RemoteUserProfileRepositoryTests {
    @Test("Delegates reads and writes to the supplied transport")
    func delegates() async throws {
        let spy = RemoteProfileTransportSpy()
        let repository = RemoteUserProfileRepository(transport: spy)
        #expect(try await repository.fetchProfile() == nil)

        let profile = UserProfile(
            gender: .male,
            birthDate: Date(timeIntervalSince1970: 1_125_014_400),
            heightCm: 175,
            weightKg: 70
        )
        try await repository.saveProfile(profile)
        #expect(try await repository.fetchProfile() == profile)
        let (fetches, saves) = await spy.counts()
        #expect(fetches == 2)
        #expect(saves == 1)
    }
}
