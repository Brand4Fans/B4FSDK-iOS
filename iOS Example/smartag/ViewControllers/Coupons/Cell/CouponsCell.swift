//
//  CouponsCell.swift
//  iOS Example
//
//  Created by Rubén Alonso on 12/3/21.
//

import UIKit

class CouponsCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    static var reuseId = "CouponsCell"
    class func nib() -> UINib {
        return UINib(nibName: String(describing: CouponsCell.self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height / 2
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawHole()
    }

    func drawHole() {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: containerView.bounds.origin.x,
                                        y: containerView.bounds.midY),
                    radius: 10,
                    startAngle: 0,
                    endAngle: 2 * CGFloat.pi,
                    clockwise: true)
        path.append(UIBezierPath(rect: containerView.bounds))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        containerView.layer.mask = mask
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
