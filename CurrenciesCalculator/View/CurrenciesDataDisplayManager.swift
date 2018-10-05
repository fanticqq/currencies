//
//  CurrenciesDataDisplayManager.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import UIKit

final class CurrenciesDataDisplayManager: NSObject {

    private let tableView: UITableView
    private var dataSource = [CurrenciesCellViewModel]()

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.register(CurrenciesTableViewCell.self, forCellReuseIdentifier: String(describing: CurrenciesTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    func reload(data: [CurrenciesCellViewModel]) {
        guard !dataSource.isEmpty else {
            dataSource = data
            tableView.reloadData()
            return
        }
        dataSource = data
        var indices = tableView.indexPathsForVisibleRows ?? []
        if let index = indices.firstIndex(of: IndexPath(row: 0, section: 0)) {
            indices.remove(at: index)
        }
        tableView.reloadRows(at: indices, with: .none)
    }
    
    func moveCell(from oldIndex: Int, to newIndex: Int) {
        dataSource.swapAt(oldIndex, newIndex)
        let oldIndexPath = IndexPath(row: oldIndex, section: 0)
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        tableView.reloadRows(at: [newIndexPath, oldIndexPath], with: .fade)
    }
}

extension CurrenciesDataDisplayManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrenciesTableViewCell.self), for: indexPath) as? CurrenciesTableViewCell else {
            fatalError("Unavailable to dequeue cell")
        }
        let model = dataSource[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension CurrenciesDataDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        model.onSelectCurrency?(model, indexPath.row)
    }
}
