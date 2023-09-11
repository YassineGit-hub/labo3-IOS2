import UIKit

class PreferencesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var themePicker: UIPickerView!

    let languages = ["Français", "Anglais", "Espagnol"]
    let themes = ["Clair", "Sombre", "Bleu"]

    override func viewDidLoad() {
        super.viewDidLoad()

        languagePicker.delegate = self
        languagePicker.dataSource = self

        themePicker.delegate = self
        themePicker.dataSource = self

        loadPreferences()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == languagePicker {
            return languages.count
        } else {
            return themes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == languagePicker {
            return languages[row]
        } else {
            return themes[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == languagePicker {
            UserPreferences.shared.selectedLanguage = languages[row]
        } else {
            UserPreferences.shared.selectedTheme = themes[row]
        }
    }

    func loadPreferences() {
        if let savedLanguage = UserPreferences.shared.selectedLanguage, let index = languages.firstIndex(of: savedLanguage) {
            languagePicker.selectRow(index, inComponent: 0, animated: false)
        }

        if let savedTheme = UserPreferences.shared.selectedTheme, let index = themes.firstIndex(of: savedTheme) {
            themePicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
}
