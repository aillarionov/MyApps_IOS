//
//  QueryTableDataController.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class QueryTableDataController<C: UITableViewCell & CommonTableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    private let tableView: UITableView
    private let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>

    private let convert: (NSManagedObject) -> C.D
    
    public var onCellSelected: ((Int, C.D) -> Void)?
    
    init(tableView: UITableView, fetchRequest: NSFetchRequest<NSFetchRequestResult>, context: NSManagedObjectContext, convert: @escaping (NSManagedObject) -> C.D) {
        self.tableView = tableView
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.convert = convert
        
        super.init()
        
        self.prepareTable()
        self.prepareController()
    }
    
    private func prepareTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(C.nib, forCellReuseIdentifier: C.cellIdentifier)
        
        let height = C.getCellHeight()
        self.tableView.rowHeight = height
        self.tableView.estimatedRowHeight = height
    }
    
    private func prepareController() {
        self.fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // UITableViewDataSource
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier, for: indexPath) as! C
        let object = self.fetchedResultsController.object(at: indexPath)
        cell.fillData(self.convert(object as! NSManagedObject))
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onCellSelected = self.onCellSelected {
            let object = self.fetchedResultsController.object(at: indexPath)
            onCellSelected(indexPath.item, self.convert(object as! NSManagedObject))
        }
    }
    
    // NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
}
