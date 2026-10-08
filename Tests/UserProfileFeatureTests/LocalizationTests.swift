import Foundation
import XCTest
@testable import UserProfileFeature

final class LocalizationTests: XCTestCase {
    func testEnglishLocalizationUsesEnglishText() throws {
        let bundle = try localizedBundle(language: "en")

        XCTAssertEqual(
            bundle.localizedString(
                forKey: "profile.navigation_title",
                value: nil,
                table: nil
            ),
            "Body Information"
        )

        XCTAssertEqual(
            bundle.localizedString(
                forKey: "profile.gender",
                value: nil,
                table: nil
            ),
            "Gender"
        )
    }

    func testKoreanLocalizationUsesKoreanText() throws {
        let bundle = try localizedBundle(language: "ko")

        XCTAssertEqual(
            bundle.localizedString(
                forKey: "profile.navigation_title",
                value: nil,
                table: nil
            ),
            "신체 정보 설정"
        )

        XCTAssertEqual(
            bundle.localizedString(
                forKey: "profile.gender",
                value: nil,
                table: nil
            ),
            "성별"
        )
    }

    private func localizedBundle(
        language: String
    ) throws -> Bundle {
        let path = try XCTUnwrap(
            Bundle.module.path(
                forResource: language,
                ofType: "lproj"
            )
        )

        return try XCTUnwrap(
            Bundle(path: path)
        )
    }
}
