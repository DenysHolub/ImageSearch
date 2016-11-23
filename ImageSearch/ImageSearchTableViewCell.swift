//
//  ImageSearchTableViewCell.swift
//  ImageSearch
//
//  Created by Denys on 18.11.16.
//  Copyright © 2016 Denys. All rights reserved.
//

import UIKit

protocol ImageSearchTableViewCellDelegate: class {
  func tableViewCell(cell: UITableViewCell)
}

class ImageSearchTableViewCell: UITableViewCell {


  @IBOutlet weak var thumbnailImageView: UIImageView!

  weak var delegate: ImageSearchTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
