
import UIKit

// View for displaying multi-day weather forecast
class DailyForecastView: UIView {
    private let tableView = UITableView()
    private var days: [Day] = []
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        tableView.register(DayCell.self, forCellReuseIdentifier: "DayCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 250)
        tableViewHeightConstraint.isActive = true
    }
    
    func configure(with days: [Day]) {
        self.days = days
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension DailyForecastView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DayCell else {
            return UITableViewCell()
        }
        cell.configure(with: days[indexPath.row])
        return cell
    }
}
