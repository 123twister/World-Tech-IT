//
//  InvoiceSummaryTableViewCell.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit

class InvoiceSummaryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var payMethodView: UIView!
    @IBOutlet weak var payMethodLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
