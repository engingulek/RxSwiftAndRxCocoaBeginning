//
//  CoffeTableViewCell.swift
//  RxSwiftAndRxCocoaBeginning
//
//  Created by engin gülek on 27.01.2023.
//

import UIKit

class CoffeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
  
    func configure(with coffee: Coffee) {
      iconImageView.image = UIImage(named: coffee.icon)
      nameLabel.text = coffee.name
    }

}
