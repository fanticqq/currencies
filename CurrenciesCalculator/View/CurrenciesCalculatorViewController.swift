//
//  CurrenciesCalculatorViewController.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import UIKit

final class CurrenciesCalculatorViewController: UIViewController {
	var output: CurrenciesCalculatorViewOutput!

    private var didSetupConstraints = false

    private lazy var dataDisplayManager = CurrenciesDataDisplayManager(tableView: self.tableView)

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        view.setNeedsUpdateConstraints()
        output.didLoadView()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

extension CurrenciesCalculatorViewController: CurrenciesCalculatorViewInput {
    func display(loading: Bool) {
        if loading {
            activityIndicatorView.startAnimating()
            tableView.isHidden = true
        } else {
            activityIndicatorView.stopAnimating()
            tableView.isHidden = false
        }
    }

    func display(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func display(data: [CurrencyCellViewModel]) {
        dataDisplayManager.reload(data: data)
    }
    
    func moveCell(from oldIndex: Int, to newIndex: Int) {
        dataDisplayManager.moveCell(from: oldIndex, to: newIndex)
    }
}
