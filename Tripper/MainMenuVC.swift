//
//  ViewController.swift
//  TravelBook
//
//  Created by Sebastian Strus on 2017-03-10.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit

class MainMenuVC
: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerTitle.alpha = 0.0
        UIView.animate(withDuration: 3.0, animations: {
            self.headerTitle.alpha = 1.0
        })
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: headerImage.frame.size.height - width, width:  headerImage.frame.size.width, height: headerImage.frame.size.height)
        border.borderWidth = width
        headerImage.layer.addSublayer(border)
        headerImage.layer.masksToBounds = true
        let borderTop = CALayer()
        borderTop.borderColor = UIColor.black.cgColor
        borderTop.frame = CGRect(x: 0, y: 0, width:  headerImage.frame.size.width, height: width)
        borderTop.borderWidth = width
        headerImage.layer.addSublayer(borderTop)
        headerImage.layer.masksToBounds = true
 
    }
}

