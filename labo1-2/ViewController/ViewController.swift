import UIKit

class ViewController: UIViewController {

    // Définir les éléments de l'interface utilisateur, comme les labels et les boutons.
    @IBOutlet weak var devinetteLabel: UILabel!
    @IBOutlet weak var userInputField: UITextField!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var hangmanView: UIImageView!

    var jeuPendu: JeuPendu!

    override func viewDidLoad() {
        super.viewDidLoad()
       movieDownloader.shared.downloadMovie(withID:
        listeFilms.randomElement()!) {(film) in
        JeuPendu.shared.jouer(avec:film!)
           self.devinnetteLabel.text=
              JeuPendu.shared.devinette
         self.poinsLabel.text="Pointage:
                                    
           \(JeuPendu.shared.erreurs)"
        }
        
    }

    @IBAction func validateBtn(_ sender: any) {
      if let res=userInputField.text,res.count==1{
        JeuPendu.shared.verifier(lettre:character(res))
        devinetteLabel.text=JeuPendu.shared.devinette
      }
    userInputField.text=""
    userUsedLetters.text=
       JeuPendu.shared.letterUtilisees
    pointsLabel.text="Erreurs:
      \(JeuPendu.shared.erreurs)"
    hangmanView.Image=JeuPendu.shared.image
      if let fin = JeuPendu.shared.verifierFinDePartie(){
        print("DB gagne: ",fin)
        
        let alert=UIAlertController(title:"fin",
            message:"\(fin)",preferredStyle:.alert)
        let OKAction=UIAlertAction(title:"ok", style:
            .default){(_) in
            print("end of game")
        }
        alert.addAction(OKAction)
        self.present(alert,animated:true, completion:
              nil)
        
      }
  }
}

 
