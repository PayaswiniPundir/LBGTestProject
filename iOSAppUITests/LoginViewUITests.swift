import XCTest

final class LoginViewUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    func test_emailTextFieldExists() {
        let email = app.textFields["Email"]
        email.tap()
        XCTAssertTrue(email.waitForExistence(timeout: 5))
    }
    func test_passwordTextFieldExists() {
        let passwd = app.textFields["Password"]
        passwd.tap()
        XCTAssertTrue(passwd.waitForExistence(timeout: 5))
    }
    func test_LoginFlow() {
        let email = app.textFields["Email"]
        email.tap()
        email.typeText("jon@gmail.com")
        let pwd = app.secureTextFields["Password"]
        pwd.tap()
        pwd.typeText("password")
        let button = app.buttons["Sign in"]
        button.forceTapElement()
        let dashBoardView = app.otherElements["UserListViewController"]
        let dashBoardShown = dashBoardView.waitForExistence(timeout: 10)
        XCTAssert(dashBoardShown)
    }
}

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(
                withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)
            )
            coordinate.tap()
        }
    }
}
