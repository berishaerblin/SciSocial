//
//  CircleView.swift
//  SciSocial
//
//  Created by Erblin Berisha on 7/26/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIImageView {
    
    
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true
    }
    

}
