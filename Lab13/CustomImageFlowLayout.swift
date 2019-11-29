

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {

    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize{
        set{}
        
        get{
            let numberOfColumns: CGFloat = 3
    let itemWith = (self.collectionView!.frame.width - (numberOfColumns - 1))/numberOfColumns
            return CGSize(width: itemWith, height: itemWith)
        }
    }
    
    
    func setupLayout(){
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
}
