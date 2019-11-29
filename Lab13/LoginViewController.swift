

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernametxt: UITextField!
    
    @IBOutlet weak var passwordtxt: UITextField!
    
    @IBOutlet weak var error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonlogin(_ sender: Any) {
        
        print("Inicio de Sesiòn")
        if(usernametxt.text != "" && passwordtxt.text != "" ){
            Auth.auth().signIn(withEmail: usernametxt.text! , password: passwordtxt.text!){
                (user, error) in
               
                if(user != nil){
                     print("usuario autenticado")
                self.presentingViewController?.dismiss(animated: true, completion: nil);
                } else {
                    print("A ocurrido un error")
                    self.error.isHidden = false
                }
            }
        }else {
            print("A ocurrido un error")
             self.error.isHidden = false
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
