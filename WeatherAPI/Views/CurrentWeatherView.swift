
import UIKit

// View for displaying current weather
class CurrentWeatherView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureBaseStyle(
            fontSize: 16,
            weight: .medium,
            text: "MY LOCATION"
        )
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.configureBaseStyle(
            fontSize: 22,
            weight: .medium
        )
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.configureBaseStyle(
            fontSize: 88,
            weight: .bold
        )
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.configureBaseStyle(
            fontSize: 18,
            weight: .regular
        )
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationLabel,
            temperatureLabel,
            conditionLabel
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with weather: CurrentWeather?) {
        guard let weather = weather else { return }
        locationLabel.text = weather.location.name
        temperatureLabel.text = "\(Int(weather.current.tempCelsius))°"
        conditionLabel.text = weather.current.condition.text
    }
}

private extension UILabel {
    func configureBaseStyle(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        text: String? = nil
    ) {
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textAlignment = .center
        self.textColor = .label
        self.text = text
    }
}
