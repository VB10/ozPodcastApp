//
//  SpeedRateCollectionViewCell.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 11.02.2024.
//

import UIKit

class SpeedRateCollectionViewCell: UICollectionViewCell {
    var currentRate: SpeedRateItems = .x1
    static let reuseIdentifier = String(describing: SpeedRateCollectionViewCell.self)

    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = ThemeManager.defaultTheme.themeFont.subtitleFontSize
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setup() {
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 10
        contentView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        configure(with: .x1)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rate: SpeedRateItems) {
        currentRate = rate
        rateLabel.text = "\(rate.rawValue)"
    }

}

#Preview {
    SpeedRateCollectionViewCell()
}
