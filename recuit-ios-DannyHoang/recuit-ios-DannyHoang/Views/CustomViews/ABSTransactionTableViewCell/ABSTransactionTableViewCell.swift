//
//  ABSTransactionTableViewCell.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import UIKit

class ABSTransactionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    bgView.layer.masksToBounds = true
    bgView.layer.cornerRadius = 5.0
  }
  
  func populateUI(_ transaction: ASBTransaction) {
    
    dateLabel.text = transaction.getDateString()
    summaryLabel.text = transaction.summary
    idLabel.text = "ID: " + (transaction.id ?? "")
    amountLabel.text = transaction.getAmountString()
  }
  
}
