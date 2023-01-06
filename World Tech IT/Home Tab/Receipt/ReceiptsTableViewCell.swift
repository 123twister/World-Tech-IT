//
//  ReceiptsTableViewCell.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit

class ReceiptsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var receiptDateLbl: UILabel!
    @IBOutlet weak var receiptAmtLbl: UILabel!
    @IBOutlet weak var paymentMtdLbl: UILabel!
    @IBOutlet weak var chequeNumberLbl: UILabel!
    @IBOutlet weak var bankLbl: UILabel!
    @IBOutlet weak var dueAmtLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var sendReceiptsBtn: UIButton!
    
    var onSendReceipts: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sendReceiptsClicked(_ sender: UIButton) {
        onSendReceipts?()
    }
    
}
