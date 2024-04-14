//import UIKit
//
//class HistoryCell: UITableViewCell {
//    let sourceLabel = UILabel()
//    let typeLabel = UILabel()
//    let detailsLabel = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//    }
//
//    private func setupViews() {
//
//        sourceLabel.numberOfLines = 0
//        sourceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        sourceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
//
//
//        typeLabel.numberOfLines = 0
//        typeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        typeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
//
//
//        detailsLabel.numberOfLines = 0
//        detailsLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        detailsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
//
//        let stackView = UIStackView(arrangedSubviews: [sourceLabel, typeLabel, detailsLabel])
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 8
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
//            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
//        ])
//    }
//
//
//    func configure(with interaction: Interaction) {
//        sourceLabel.text = "Source: \(interaction.source)"
//        typeLabel.text = "Type: \(interaction.type)"
//        detailsLabel.text = "Details: \(interaction.details)"
//    }
//
//}

import UIKit

class HistoryCell: UITableViewCell {
    let sourceLabel = UILabel()
    let typeLabel = UILabel()
    let detailsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        // Setup source label
        sourceLabel.numberOfLines = 0
        sourceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        sourceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        // Setup type label
        typeLabel.numberOfLines = 0
        typeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        typeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        // Setup details label
        detailsLabel.numberOfLines = 0
        detailsLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        detailsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        // StackView to arrange labels vertically
        let stackView = UIStackView(arrangedSubviews: [sourceLabel, typeLabel, detailsLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
    }

    func configure(with interaction: Interaction) {
        // Configure labels with interaction data
        sourceLabel.text = "Source: \(interaction.source.rawValue)"
        typeLabel.text = "Type: \(interaction.type.rawValue)"
        detailsLabel.text = "Details: \(interaction.details)"
    }
}
