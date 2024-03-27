//
//  HeaderView.swift
//  VirusSpread
//
//  Created by Кристина Пастухова on 26.03.2024.
//

import UIKit

class HeaderView: UIView {

    private let infectedLabel = UILabel()
    private let healthyLabel = UILabel()
    private let countOfInfectedLabel = UILabel()
    private let countOfHealthyLabel = UILabel()
    
    private let hHealthyStack = UIStackView()
    private let hInfectedStack = UIStackView()
    private let verticalStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure( withHealtyCount healthy: Int, withInfectedCount infected: Int ) {
        countOfHealthyLabel.text = String(healthy)
        countOfInfectedLabel.text = String(infected)
    }
    
    
    private func setupView() {
        backgroundColor = UIColor.clear
        
        healthyLabel.text = "Колличество здоровых:"
        healthyLabel.textAlignment = .left
        healthyLabel.textColor = .black
        healthyLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        healthyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infectedLabel.text = "Колличеcтво зараженных:"
        infectedLabel.textAlignment = .left
        infectedLabel.textColor = .black
        infectedLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        infectedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countOfHealthyLabel.text = "нет значения"
        countOfHealthyLabel.textAlignment = .left
        countOfHealthyLabel.textColor = .blue
        countOfHealthyLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        countOfHealthyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countOfInfectedLabel.text = "нет значения"
        countOfInfectedLabel.textAlignment = .left
        countOfInfectedLabel.textColor = .red
        countOfInfectedLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        countOfInfectedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hHealthyStack.axis = .horizontal
        hHealthyStack.alignment = .leading
        hHealthyStack.spacing = 6
        hHealthyStack.addArrangedSubview(healthyLabel)
        hHealthyStack.addArrangedSubview(countOfHealthyLabel)
        hHealthyStack.translatesAutoresizingMaskIntoConstraints = false
        
        hInfectedStack.axis = .horizontal
        hInfectedStack.alignment = .leading
        hInfectedStack.spacing = 6
        hInfectedStack.addArrangedSubview(infectedLabel)
        hInfectedStack.addArrangedSubview(countOfInfectedLabel)
        hInfectedStack.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 16
        verticalStackView.addArrangedSubview(hHealthyStack)
        verticalStackView.addArrangedSubview( hInfectedStack)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            verticalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }
    

}
