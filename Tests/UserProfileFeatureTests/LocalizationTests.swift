import XCTest
@testable import UserProfileFeature

final class LocalizationTests:
    XCTestCase {

    func testEnglishLocalizationResourceExists() {
        let value =
            L10n.string(
                "profile.navigation_title"
            )

        XCTAssertFalse(
            value.isEmpty
        )

        XCTAssertNotEqual(
            value,
            "profile.navigation_title"
        )
    }
}
