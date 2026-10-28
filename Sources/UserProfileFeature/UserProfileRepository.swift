import Foundation
import WakTrainerCoreModels

/// Storage-independent profile persistence contract.
/// Server-backed implementations can be supplied by the host app later.
public protocol UserProfileRepository: Sendable {
    func fetchProfile() async throws -> UserProfile?
    func saveProfile(_ profile: UserProfile) async throws
}
