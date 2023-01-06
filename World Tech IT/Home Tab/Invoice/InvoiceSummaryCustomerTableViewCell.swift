//
//  InvoiceSummaryCustomerTableViewCell.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 26/02/21.
//

import UIKit

class InvoiceSummaryCustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var customerIdLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
