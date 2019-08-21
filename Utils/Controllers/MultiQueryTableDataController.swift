//
//  MultiQueryTableDataController.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class MultiQueryTableDataController<C: UITableViewCell & CommonTableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    private let tableView: UITableView
    private let context: NSManagedObjectContext
    
    private var controllers: [Int: NSFetchedResultsController<NSFetchRequestResult>] = [:]
    private var controllersIndex: [NSFetchedResultsController<NSFetchRequestResult>: Int] = [:]
    private var converters: [Int: (NSManagedObject) -> C.D] = [:]
    private var sections: Int = 0
    
    public var onCellSelected: ((Int, C.D) -> Void)?
    
    init(tableView: UITableView, context: NSManagedObjectContext) {
        self.tableView = tableView
        self.context = context
        
        super.init()
        
        self.prepareTable()
    }
    
    private func prepareTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(C.nib, forCellReuseIdentifier: C.cellIdentifier)
        
        let height = C.getCellHeight()
        self.tableView.rowHeight = height
        self.tableView.estimatedRowHeight = height
    }
    
    public func addSection(fetchRequest: NSFetchRequest<NSFetchRequestResult>, convert: @escaping (NSManagedObject) -> C.D) {
        
        let section = self.sections
        self.sections += 1
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controllers[section] = controller
        self.converters[section] = convert
        self.controllersIndex[controller] = section
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        self.tableView.insertSections(IndexSet(integer: section), with: .fade)
    }
    
    public func clearSections() {
        let oldSections = self.sections
        self.sections = 0
        self.controllers = [:]
        self.converters = [:]
        self.controllersIndex = [:]

        if oldSections != 0 {
            self.tableView.deleteSections(IndexSet(0...oldSections-1), with: .fade)
        }
        
    }
    
    // UITableViewDataSource
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.controllers[section]!.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[0]
        return sectionInfo.numberOfObjects
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.getObjectAtIndex(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier, for: indexPath) as! C
        cell.fillData(object)
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onCellSelected = self.onCellSelected {
            let object = self.getObjectAtIndex(indexPath)
            onCellSelected(indexPath.item, object)
        }
    }
    
    private func getObjectAtIndex(_ indexPath: IndexPath) -> C.D {
        let controller = self.controllers[indexPath.section]!
        let convert = self.converters[indexPath.section]!
        let ip = IndexPath(row: indexPath.row, section: 0)
        let object = controller.object(at: ip)
        return convert(object as! NSManagedObject)
    }
    
    // NSFetchedResultsControllerDelegate
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let section = self.controllersIndex[controller]!
        
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: section), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: section), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let section = self.controllersIndex[controller]!
        let ip: IndexPath? = indexPath != nil ? IndexPath(row: indexPath!.row, section: section) : nil
        let nip: IndexPath? = newIndexPath != nil ? IndexPath(row: newIndexPath!.row, section: section) : nil
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [nip!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [ip!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [ip!], with: .fade)
        case .move:
            self.tableView.moveRow(at: ip!, to: nip!)
        }
    }
}
