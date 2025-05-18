//  HourlyForecastView.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import UIKit

/// View для отображения почасового прогноза с горизонтальным скроллом
class HourlyForecastView: UIView {
    private var hours: [Hour] = []
    private let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 100)
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        collectionView.register(HourCell.self,
                                forCellWithReuseIdentifier: "HourCell")
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    /// Обновление данных и перезагрузка коллекции
    func configure(with hours: [Hour]) {
        self.hours = hours
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension HourlyForecastView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HourCell",
            for: indexPath
        ) as? HourCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hours[indexPath.item])
        return cell
    }
}
