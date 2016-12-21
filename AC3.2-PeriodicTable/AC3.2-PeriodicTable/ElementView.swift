//
//  ElementView.swift
//  AC3.2-PeriodicTable
//
//  Created by Erica Y Stevens on 12/21/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit

class ElementView: UIView {

    @IBOutlet weak var elementSymbol: UILabel!
    
    @IBOutlet weak var elementNumber: UILabel!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let view = Bundle.main.loadNibNamed("ElementView", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.backgroundColor = .clear
            view.frame = self.bounds
        }
    }

}
