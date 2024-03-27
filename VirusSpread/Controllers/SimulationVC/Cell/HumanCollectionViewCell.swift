//
//  HumanCollectionViewCell.swift
//  VirusSpread
//
//  Created by Кристина Пастухова on 26.03.2024.
//

import UIKit

class HumanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50)
    }
    
    func configure(with isInfected: Bool) {
        if isInfected {
            label.text = "😷"
            view.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 64/255, alpha: 0.7)
        }

        else {
            label.text = "😜"
            view.backgroundColor = .clear
        }
    }
}
