

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error != nil {
                // error description
                print("some sign in error...") // TODO: todo
            } else {
                self.showAlert(with: "Успішно!", and: "Ви авторизовані", completion: {
                    let pageVC = PageViewController(urlString: "")
                    self.present(pageVC, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    

}
