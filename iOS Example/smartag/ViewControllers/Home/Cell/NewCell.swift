//
//  NewCell.swift
//  iOS Example
//
//  Created by Rubén Alonso on 12/3/21.
//

import UIKit

class NewCell: UITableViewCell {

    @IBOutlet weak var imageNew: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!

    static var reuseId = "NewCell"
    class func nib() -> UINib {
        return UINib(nibName: String(describing: NewCell.self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
