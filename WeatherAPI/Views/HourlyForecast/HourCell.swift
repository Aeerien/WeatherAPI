//  HourCell.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import UIKit

/// Ячейка коллекции для отображения прогноза на конкретный час
class HourCell: UICollectionViewCell {
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.font = .systemFont(ofSize: 14)
        tempLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    /// Настраивает ячейку данными о часе
    func configure(with hour: Hour) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = formatter.date(from: hour.time) {
            formatter.dateFormat = "HH"
            timeLabel.text = formatter.string(from: date)
        }
        tempLabel.text = "\(Int(hour.tempCelsius))°"
        
        // Загрузка иконки
        if let url = URL(string: "https:\(hour.condition.icon)") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.iconImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - UIImageView Loading Extension
extension UIImageView {
    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
