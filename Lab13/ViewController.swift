

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage
import FirebaseStorage

class ViewController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	

    @IBOutlet weak var loginbutton: UIBarButtonItem!
    
    @IBOutlet weak var logoutbutton: UIBarButtonItem!
    
    @IBOutlet weak var logininfolabel: UILabel!
    
    
    @IBOutlet weak var imagencolecction: UICollectionView!
    
    var images = [CatInsta]()
    
    var customImageFlowLayout: CustomImageFlowLayout!
    
    var dbRef: DatabaseReference!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        dbRef = Database.database().reference().child("images")
        loadDB()
        
        customImageFlowLayout = CustomImageFlowLayout()
        imagencolecction.collectionViewLayout = customImageFlowLayout
        imagencolecction.backgroundColor = .white
        
    }

    func loadDB(){
        dbRef.observe( DataEventType.value, with: { (snapshot) in
            var newImages = [CatInsta]()
            for catInstaSnapshot in snapshot.children {
                let catInstaObject = CatInsta(snapshot: catInstaSnapshot as! DataSnapshot)
                newImages.append(catInstaObject)
            }
            self.images = newImages
            self.imagencolecction.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  Auth.auth().currentUser != nil {
            self.loginbutton.isEnabled = false
            self.logoutbutton.isEnabled = true
            self.logininfolabel.text = "Hello " + (Auth.auth().currentUser?.email)!
        }else{
            self.loginbutton.isEnabled = true
            self.logoutbutton.isEnabled = false
            self.logininfolabel.text = "Hello. Please Login"
        }
    }
    

    @IBAction func logoutbuttonclick(_ sender: Any) {
        
        if  Auth.auth().currentUser != nil {
            
            do{
            try Auth.auth().signOut()
                
            self.loginbutton.isEnabled = true
            self.logoutbutton.isEnabled = false
            self.logininfolabel.text = "Hello please login"
                
            }catch let signOutError as NSError{
                print("Error signin out: %@" , signOutError)
        }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = imagencolecction.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        
        
        let image = images[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "image1"))
        return cell
        
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        
        dismiss(animated: true, completion: nil)
        
        if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            var  data = Data()
            data =  pickedimage.jpegData(compressionQuality: 0.8)!
            
            
            let imageRef = Storage.storage().reference().child("images/" + randomString(20));
            
            _ = imageRef.putData(data, metadata: nil) {(metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                
                let downloadURL = metadata.storageReference.self
                print(downloadURL?.debugDescription ?? "")
                
                let key = self.dbRef.childByAutoId().key
                let image = ["url": downloadURL?.debugDescription]
                
                let childUpdates = ["/\(key)": image]
                self.dbRef.updateChildValues(childUpdates)
            }
            
        }
    }
    
    
    
    
    @IBAction func loadImageButtonClick(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func randomString(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            
            let rand  = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
        
    }
}

