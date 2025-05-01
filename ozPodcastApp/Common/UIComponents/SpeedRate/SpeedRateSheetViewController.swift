//
//  SpeedRateSheetViewController.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 11.02.2024.
//

import SnapKit
import UIKit

enum SpeedRateItems: Float, CaseIterable {
    case x1 = 1
    case x1_25 = 1.25
    case x1_5 = 1.5
    case x1_75 = 1.75
    case x2 = 2
    case x2_5 = 2.5
    case x3 = 3
}

final class SpeedRateSheetViewController: UIViewController {
    private lazy var rateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SpeedRateCollectionViewCell.self, forCellWithReuseIdentifier: SpeedRateCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.speedRate
        label.textColor = .secondary
        label.font = ThemeManager.defaultTheme.themeFont.mainTitleFontSize
        label.textAlignment = .left
        return label
    }()

    var selectionHandler: ((SpeedRateItems) -> Void)?

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = CGSize(width: view.bounds.width, height: 100)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(rateCollectionView)
        view.addSubview(infoLabel)

        preferredContentSize = CGSize(width: view.bounds.width, height: 100)

        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        rateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.left.right.equalTo(infoLabel)
        }
    }
}

extension SpeedRateSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SpeedRateItems.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpeedRateCollectionViewCell.reuseIdentifier, for: indexPath) as? SpeedRateCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: SpeedRateItems.allCases[indexPath.row])
        return cell
    }
}

#Preview {
    SpeedRateSheetViewController()
}
