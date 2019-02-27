//
//  CarouselCollectionViewCell.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/03/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
