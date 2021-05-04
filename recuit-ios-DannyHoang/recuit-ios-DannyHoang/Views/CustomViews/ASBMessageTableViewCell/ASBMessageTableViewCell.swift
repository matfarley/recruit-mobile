//
//  ASBMessageTableViewCell.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import UIKit

class ASBMessageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  
  var actionHandler: (() -> ())?
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func didTouchActionButton(_ sender: Any) {
    if let handler = actionHandler {
      handler()
    } else {
      print("ASBMessageTableViewCell: No Handler")
    }
  }
  
  func populateUI(_ message: String?, _ actionButtonTitle: String) {
    messageLabel.text = message
    actionButton.setTitle(actionButtonTitle, for: .normal)
    messageLabel.isHidden = false
    actionButton.isHidden = false
  }
}
