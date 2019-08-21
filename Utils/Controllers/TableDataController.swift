//
//  TableDataController.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class TableDataController<C: UITableViewCell & CommonTableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView
    private var data: [C.D]
    
    public var onCellSelected: ((Int, C.D) -> Void)?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.data = []

        super.init()
        
        self.prepareTable()
    }
    
    public func setData(_ data: [C.D]) {
        self.data = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func prepareTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(C.nib, forCellReuseIdentifier: C.cellIdentifier)
        
        let height = C.getCellHeight()
        self.tableView.rowHeight = height
        self.tableView.estimatedRowHeight = height
    }
    
    // UITableViewDataSource
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier, for: indexPath) as! C
        cell.fillData(data[indexPath.item])
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onCellSelected = self.onCellSelected {
            onCellSelected(indexPath.item, data[indexPath.item])
        }
    }
    
}
