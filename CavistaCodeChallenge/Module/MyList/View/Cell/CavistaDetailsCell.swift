//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 30/08/20


import UIKit
import SnapKit

class CavistaDetailsCell: UITableViewCell {

    static let identifier: String = Cell.cavistaDetailsCell
    
    // MARK: - Custom Views
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.layer.cornerRadius = 8
        mainView.layer.masksToBounds = true
        mainView.backgroundColor = UIColor.app.cardBackground
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.top.equalTo(contentView).offset(10)
            $0.bottom.equalTo(contentView).offset(-10)
        }
        return mainView
    }()
    
    private lazy var transparantView: UIView = {
        let transparantView = UIView()
        transparantView.backgroundColor = UIColor.app.background.withAlphaComponent(0.60)
        mainView.addSubview(transparantView)
        transparantView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        return mainView
    }()
    
    private lazy var imgItem: UIImageView = {
        let imageView = UIImageView()
        mainView.addSubview(imageView)
        imageView.bringSubviewToFront(lblDate)
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(220)
        }
        return imageView
    }()
    
    private lazy var lblDescription: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.primaryText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        mainView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
        }
        return label
    }()
    
    private lazy var lblDate: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.secondaryText
        label.numberOfLines = 0
        label.layer.zPosition = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        mainView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(lblDescription.snp.bottom).offset(8)
            $0.left.equalTo(lblDescription)
            $0.right.equalTo(lblDescription)
            $0.bottom.equalToSuperview().offset(-12)
        }
        return label
    }()
    
    // MARK: - Initialization Methos
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    /// Setup view
    private func configureView() {
        contentView.backgroundColor = UIColor.app.background
    }
    
    // MARK: - Public Method
    /// ConfigerModel data to the view
    /// - Parameter data: data description
    public func configureData(data: MyItemDetails) {
        lblDescription.text = data.details
        lblDate.text = data.createdDate
    }
    
}
