//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 30/08/20


import UIKit
import Alamofire
import SnapKit
import Lightbox

class MyListViewController: UIViewController {
    
    // MARK:- Private Properties
    private let viewModel = MyListViewModel()
    
    // MARK: - Custom Views
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.backgroundColor = .clear
        activityView.color = .white
        view.addSubview(activityView)
        activityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return activityView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.backgroundColor = UIColor.app.background
        tableView.backgroundView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CavistaDetailsCell.self, forCellReuseIdentifier: CavistaDetailsCell.identifier)
        tableView.register(CavistaImageCell.self, forCellReuseIdentifier: CavistaImageCell.identifier)
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var lblError: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.primaryText
        label.numberOfLines = 0
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view)
            $0.left.equalTo(self.view).offset(20)
            $0.right.equalTo(self.view).offset(-20)
        }
        return label
    }()
    
    // MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        title = "Cavista"
        view.addSubview(tableView)
        view.backgroundColor = UIColor.app.background
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        getMyListing()
    }
    
    /// API Call to fetch My Listing Data
    private func getMyListing() {
        if Connectivity.isConnectedToInternet() {
            activityIndicator.startAnimating()
            viewModel.callSignInAPI { [weak self] (error) in
                self?.activityIndicator.stopAnimating()
                self?.viewModel.addUpdateDataToDB()
                self?.tableView.reloadData()
                guard let error = error else {
                    self?.lblError.isHidden = true
                    return
                }
                self?.lblError.isHidden = false
                self?.lblError.text = error
            }
        } else {
            viewModel.fetchDataFromDB()
            if viewModel.myItemList?.count ?? 0 == 0 {
                lblError.isHidden = false
                lblError.text = Constant.Message.fetchError
            } else {
                lblError.isHidden = true
                tableView.reloadData()
            }
        }
    }
    
    /// Display Alert for user that image has save or not
    /// - Parameter isError: isError description
    private func displayAlertForSaveImage(_ error: Error?) {
        if let error = error {
            let ac = UIAlertController(title: Constant.Message.saveError, message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Constant.Message.ok, style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: Constant.Message.saved, message: Constant.Message.savedMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Constant.Message.ok, style: .default))
            present(ac, animated: true)
        }
    }
    
    /// Preview Image Full Screen
    /// - Parameter image: image description
    private func viewImagePreview(_ image: UIImage?) {
        guard let image = image else { return }
        let controller = LightboxController(images: [LightboxImage(image: image)])
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    /// Configer CavistaImageCell
    /// - Parameters:
    ///   - model: myListdetails model
    ///   - indexPath: indexPath of tableview
    /// - Returns: CavistaImageCell Object
    private func configCavistaImageCell(for model: MyItemDetails, at indexPath: IndexPath) -> CavistaImageCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CavistaImageCell.identifier, for: indexPath) as? CavistaImageCell
        cell?.configureData(data: model)
        // Call back when user tap on download button
        cell?.didSavedPhotos = { [weak self] error in
            self?.displayAlertForSaveImage(error)
        }
        // Call back when user tap on image
        cell?.didOnImage = { [weak self] in
            self?.viewImagePreview(cell?.imgItem.image)
        }
        return cell
    }
    
    /// Configer CavistaDetailsCell
    /// - Parameters:
    ///   - model: myListdetails model
    ///   - indexPath: indexPath of tableview
    /// - Returns: CavistaDetailsCell Object
    private func configCavistaDetailsCell(for model: MyItemDetails, at indexPath: IndexPath) -> CavistaDetailsCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CavistaDetailsCell.identifier, for: indexPath) as? CavistaDetailsCell
        cell?.configureData(data: model)
        return cell
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myItemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.myItemList?[indexPath.row] else {
            return UITableViewCell()
        }
        // Here we are set Cell base on type
        if let type = model.type, type == DetailType.image.rawValue {
            return configCavistaImageCell(for: model, at: indexPath) ?? UITableViewCell()
        } else {
            return configCavistaDetailsCell(for: model, at: indexPath) ?? UITableViewCell()
        }
    }
}
