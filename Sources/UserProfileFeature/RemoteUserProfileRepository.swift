import Foundation
import WakTrainerCoreModels

/// Host-provided authenticated transport. AuthenticationKit/NetworkKit can implement this
/// without becoming dependencies of UserProfileFeature.
public protocol UserProfileRemoteTransport: Sendable {
    func fetchProfile() async throws -> UserProfile?
    func saveProfile(_ profile: UserProfile) async throws
}

/// A remote repository with no assumptions about a particular backend's routes,
/// payload envelopes, authentication scheme, or ownership of tokens.
public struct RemoteUserProfileRepository: UserProfileRepository {
    private let transport: any UserProfileRemoteTransport

    public init(transport: any UserProfileRemoteTransport) {
        self.transport = transport
    }

    public func fetchProfile() async throws -> UserProfile? {
        try await transport.fetchProfile()
    }

    public func saveProfile(_ profile: UserProfile) async throws {
        try await transport.saveProfile(profile)
    }
}
