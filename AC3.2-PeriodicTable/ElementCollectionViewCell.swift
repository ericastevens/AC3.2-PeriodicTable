//
//  ElementCollectionViewCell.swift
//  AC3.2-PeriodicTable
//
//  Created by Erica Y Stevens on 12/21/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit

class ElementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var elementView: ElementView!
    
//    var elementSymbolString = ""
//    var elementNumberString = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.elementView.elementSymbol.text = elementSymbolString
//        
//        self.elementView.elementNumber.text = elementNumberString
    }

}
