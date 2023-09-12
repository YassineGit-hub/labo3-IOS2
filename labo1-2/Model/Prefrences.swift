import Foundation

class UserPreferences {
    static let shared = UserPreferences()

    private let userDefaults = UserDefaults.standard

    var selectedLanguage: String? {
        get { return userDefaults.string(forKey: "userLanguage") }
        set { userDefaults.set(newValue, forKey: "userLanguage") }
    }

    var selectedTheme: String? {
        get { return userDefaults.string(forKey: "userTheme") }
        set {
        userDefaults.set(newValue, forKey: "userTheme")
            NotificationCenter.default.post(name: .themeDidChange, object: nil)
        }
    }
}

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}
