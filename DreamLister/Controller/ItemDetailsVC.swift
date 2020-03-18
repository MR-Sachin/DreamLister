//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by vishal chaubey on 3/14/20.
//  Copyright © 2020 DeviSons. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePikerView: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    
    
    var stores = [Store]()
    var itemToEdit: Item?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // this code for remove previous vc title name which is show automatically in sencond vc
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePikerView.delegate = self
        storePikerView.dataSource = self
        
         // now we create some core which we fetching it and displaying it
        let store = Store(context: context)
        store.name = "MacBook Dealership"
        let store2 = Store(context: context)
        store2.name = "Fry Electronic"
        let store3 = Store(context: context)
        store3.name = "Iphone Dealership"
        let store4 = Store(context: context)
        store4.name = "Tasla Dealership"
        let store5 = Store(context: context)
        store5.name = "M Mart"
        let store6 = Store(context: context)
        store6.name = "Amazon"

        // save it in core date ad is verible which we created for shortcut way in app delegate for easily access core data method for save data
        ad.saveContext()
        getStore()
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // we provied data for picker view rows which is show in picker view
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // numder of row which want to display in piker view
        return stores.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // colums in rows
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update when selected a item in piker view
    }
    
    // now we fetch those data which we store in store entity in core data see above code
    
    func getStore() {
        let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            storePikerView.reloadAllComponents()
        }
        catch {
            
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
      // creat a var for coreData item entity to store text field into Item coredata NSManagedObjectContext handle all these things for saving data into coredata
        
        let item = Item(context: context)
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue  // in price as dauble in coredata so we convert price as string and convert to double value
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePikerView.selectedRow(inComponent: 0)]
        
        //SAVE IT ALL ABOVE IN CORE DATA
            ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    
   

}
