//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 30/08/20


import UIKit
import SnapKit
import Kingfisher

class CavistaImageCell: UITableViewCell {
    
    static let identifier: String = Cell.cavistaImageCell
    
    // MARK: - Public Properties
    public var didSavedPhotos: (Error?) -> Void = {_ in}
    public var didOnImage: () -> Void = {}
    
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
        transparantView.backgroundColor = UIColor.app.background.withAlphaComponent(0.80)
        mainView.addSubview(transparantView)
        transparantView.bringSubviewToFront(btnDownload)
        transparantView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        return mainView
    }()
    
    public lazy var imgItem: UIImageView = {
        let imageView = UIImageView()
        mainView.addSubview(imageView)
        imageView.bringSubviewToFront(lblDate)
        imageView.contentMode = .scaleToFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage)))
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(220)
        }
        return imageView
    }()
    
    private lazy var btnDownload: UIButton = {
        let downloadButton = UIButton()
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(UIColor.systemBlue, for: .normal)
        downloadButton.addTarget(self, action: #selector(didTapOnDownload(_:)), for: .touchUpInside)
        mainView.addSubview(downloadButton)
        downloadButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(0)
        }
        return downloadButton
    }()
    
    private lazy var lblDate: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.secondaryText
        label.numberOfLines = 0
        label.layer.zPosition = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        transparantView.addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
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
        if let strURL = data.details, let url = URL(string: strURL) {
            imgItem.kf.setImage(with: url, placeholder: UIImage(named: "default_image"), options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        }
        lblDate.text = data.createdDate ?? "NA"
    }
    
    /// Save image when user tap on download button
    /// - Parameter sender: sender description
    @objc func didTapOnDownload(_ sender: UIButton) {
        guard let img = imgItem.image else { return }
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// Image Preview in full screen
    @objc func didTapOnImage() {
        didOnImage()
    }
    
    /// Save image in to photos
    /// - Parameters:
    ///   - image: image description
    ///   - error: error description
    ///   - contextInfo: contextInfo description
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        didSavedPhotos(error)
    }
}
