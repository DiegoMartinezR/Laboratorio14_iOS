
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
   
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
