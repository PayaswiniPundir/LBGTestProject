import XCTest

final class HomeViewUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    func test_HomeMainViewcontroller() {
        let myTable = app.tables.matching(identifier: "HomeTable" )
        let email = app.textFields["Email"]
        email.tap()
        email.typeText("john@gmail.com")
        let pwd = app.secureTextFields["Password"]
        pwd.tap()
        pwd.typeText("password")
        app.staticTexts["Sign in"].tap()
        let dashBoardView = app.tables["HomeViewController"]
            .staticTexts["Nathan@yesenia.net"]
        let dashBoardShown = dashBoardView.waitForExistence(timeout: 10)
        XCTAssert(dashBoardShown)
    }
}
