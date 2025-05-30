
import UIKit

// Table cell for displaying a single day's forecast entry
class DayCell: UITableViewCell {
    private let dayLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempRangeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [dayLabel, iconImageView, tempRangeLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        dayLabel.font = .systemFont(ofSize: 16)
        tempRangeLabel.font = .systemFont(ofSize: 16)
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // Configures the cell with day data
    func configure(with day: Day) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: day.date) {
            formatter.dateFormat = "E"
            dayLabel.text = formatter.string(from: date)
        }
        tempRangeLabel.text = "\(Int(day.day.minTempCelsius))° / \(Int(day.day.maxTempCelsius))°"
        
        if let url = URL(string: "https:\(day.day.condition.icon)") {
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
