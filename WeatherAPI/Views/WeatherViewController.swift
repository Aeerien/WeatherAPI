//  WeatherViewController.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import UIKit

/// Экран с погодой, обёрнутый в UIScrollView для прокрутки содержимого
class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel()
    private let locationManager = LocationManager()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let currentWeatherView = CurrentWeatherView()
    private let hourlyForecastView = HourlyForecastView()
    private let dailyForecastView = DailyForecastView()
    
    private let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Обновить", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let li = UIActivityIndicatorView(style: .large)
        li.hidesWhenStopped = true
        li.translatesAutoresizingMaskIntoConstraints = false
        return li
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupLocationManager()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [currentWeatherView,
         hourlyForecastView,
         dailyForecastView,
         updateButton].forEach {
            contentView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        updateButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        updateButton.addTarget(self, action: #selector(didTapUpdate), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onWeatherUpdate = { [weak self] in
            self?.updateUI()
        }
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(
                title: "Ошибка",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocationAccess()
        locationManager.fetchLocation()
    }
    
    @objc private func didTapUpdate() {
        viewModel.fetchWeather()
    }
    
    private func updateUI() {
        currentWeatherView.configure(with: viewModel.currentWeather)
        hourlyForecastView.configure(with: viewModel.hourlyForecast)
        dailyForecastView.configure(with: viewModel.dailyForecast)
    }
}

// MARK: - LocationManagerDelegate
extension WeatherViewController: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        viewModel.setLocation(latitude: latitude, longitude: longitude)
    }
    
    func didFailWithLocation(error: Error?) {
        viewModel.setLocation(latitude: 55.7558, longitude: 37.6176)
    }
}
