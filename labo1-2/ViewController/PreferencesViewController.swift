import UIKit

class PreferencesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let languages = ["Français", "Anglais", "Espagnol"]
    let themes = ["Clair", "Sombre", "Bleu"]

    let languagePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    let themePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ajoutez les pickers à la vue
        view.addSubview(languagePicker)
        view.addSubview(themePicker)

        // Définissez les contraintes
        NSLayoutConstraint.activate([
            languagePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            languagePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            languagePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            languagePicker.heightAnchor.constraint(equalToConstant: 100),

            themePicker.topAnchor.constraint(equalTo: languagePicker.bottomAnchor, constant: 20),
            themePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            themePicker.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Configurez les pickers
        languagePicker.delegate = self
        languagePicker.dataSource = self
        themePicker.delegate = self
        themePicker.dataSource = self

        // Chargez les préférences
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

