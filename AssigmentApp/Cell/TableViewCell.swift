//
//  ViewController.swift
//  Article
//
//  Created by Prerna Chauhan on 01/07/20.
//  Copyright © 2020 Prerna Chauhan. All rights reserved.
//
import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var article_Content: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var article_Url: UILabel!
    @IBOutlet weak var article_Title: UILabel!
    @IBOutlet weak var user_descrip: UILabel!
    @IBOutlet weak var user_Name: UILabel!
    @IBOutlet weak var user_Img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.user_Img.setRounded()
    }
    @IBOutlet weak var atricle_img: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
