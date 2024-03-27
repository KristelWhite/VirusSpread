//
//  HumanCollectionViewCell.swift
//  VirusSpread
//
//  Created by Кристина Пастухова on 26.03.2024.
//

import UIKit

class HumanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with isInfected: Bool) {
        if isInfected {
            label.text = "Заражен"
            label.backgroundColor = .red
        }
        else {
            label.text = "Здоров"
            label.backgroundColor = .clear
        }
    }
}
