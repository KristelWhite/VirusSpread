//
//  ParametersViewController.swift
//  VirusSpread
//
//  Created by Кристина Пастухова on 26.03.2024.
//

import UIKit

class ParametersViewController: UIViewController {

    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var groupSizeTextField: UITextField!
    @IBOutlet weak var timingTextField: UITextField!
    @IBOutlet weak var infectionFactorTextField: UITextField!
    
    @IBOutlet weak var startSimulationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
    }

    private func configureAppearance(){
        firstLabel.text = "Введите количество людей в симуляции:"
        firstLabel.textColor = .black
        firstLabel.font = .systemFont(ofSize: 16, weight: .medium)
        firstLabel.textAlignment = .left
        
        secondLabel.text = "Введите колличество людей которое может быть заражено одним человеком при контакте:"
        secondLabel.textColor = .black
        secondLabel.textAlignment = .left
        secondLabel.font = .systemFont(ofSize: 16, weight: .medium)
        secondLabel.numberOfLines = 0
        
        thirdLabel.text = "Тайминг колличества зараженных людей:"
        thirdLabel.font = .systemFont(ofSize: 16, weight: .medium)
        thirdLabel.textAlignment = .left
        thirdLabel.textColor = .black
        
        startSimulationButton.setTitle("Запустить симуляцию", for: .normal)
        
        
        self.view.backgroundColor = .systemGray6
        
        
        
    }

    @IBAction func tapOnSimulationButton(_ sender: Any) {
        let vc = SimulationViewController()
        if let text = timingTextField.text{
            vc.peroidUpdating = Int(text) ?? 0
        }
        if let text = groupSizeTextField.text{
            vc.groupSize = Int(text) ?? 0
        }
        if let text = infectionFactorTextField.text{
            vc.infectionFactor = Int(text) ?? 0
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
