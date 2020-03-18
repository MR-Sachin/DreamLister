//
//  MainVC.swift
//  DreamLister
//
//  Created by Sachin Verma on 3/13/20.
//  Copyright © 2020 DeviSons. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate {


    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        generateTestData()
        attempFetch()
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath )
        return cell
        
    }
    // configure cell here because we used that in two diffrentent place in this viewcontroller insted of above we generally configure cell cellforRow at table view method
    
    func configureCell(cell: ItemCell , indexPath: IndexPath)  {
        // update Cell code
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
    }
    
    // fetech data from core cada
    func attempFetch()  {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // we have 3 segment controller for displaying date by specific sorted fomes
        let dataSort = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [dataSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
        }catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // after change data table view update
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // before change data tabel view update
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
    }
    
    // create controller function which we want to preform NSFectchRequestResult opreation which are insert delete update and move
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                // update the cell date code write here
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    
     // create some data for testing propose
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I cant wait untill the september event, I hope they relaase new MBPs"

        let item2 = Item(context: context)
        item2.title = "Boss HeadPhone"
        item2.price = 300
        item2.details = "I cant wait untill the september event, I hope they relaase new MBPs"

        let item3 = Item(context: context)
        item3.title = "Tasla Model S"
        item3.price = 110000
        item3.details = "I cant wait untill the september event, I hope they relaase new MBPs"

        let item4 = Item(context: context)
        item4.title = "iPad"
        item4.price = 800
        item4.details = "I cant wait untill the september event, I hope they relaase new MBPs"

        let item5 = Item(context: context)
        item5.title = "IMac"
        item5.price = 2800
        item5.details = "I cant wait untill the september event, I hope they relaase new MBPs"
    }

}

