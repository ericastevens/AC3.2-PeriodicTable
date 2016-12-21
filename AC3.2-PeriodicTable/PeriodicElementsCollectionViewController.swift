//
//  PeriodicElementsCollectionViewController.swift
//  AC3.2-PeriodicTable
//
//  Created by Erica Y Stevens on 12/21/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ElementCell"

class PeriodicElementsCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Element>!
    //let data = [("H", 1), ("He", 2), ("Li", 3)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName:"ElementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        getData()
        initializeFetchResultsController()  

    }
    
    func getData() {
        APIRequestManager.manager.getData(endPoint: "https://api.fieldbook.com/v1/5859ad86d53164030048bae2/elements")  { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]) {
                    if let jsonArrOfDicts = jsonData as? [[String:Any]] {
                        // used to be our way of adding a record
                        // self.allArticles.append(contentsOf:Article.parseArticles(from: records))
                        
                        // create the private context on the thread that needs it
                        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.privateContext
                        
                        moc.performAndWait {
                            for dict in jsonArrOfDicts {
                                let element = NSEntityDescription.insertNewObject(forEntityName: "Element", into: moc) as! Element

                                element.populate(from: dict)
                       
                                dump(element)
                            }
                            do {
                                try moc.save()
                                
                                moc.parent?.performAndWait {
                                    do {
                                        try moc.parent?.save()
                                    }
                                    catch {
                                        fatalError("Failure to save context: \(error)")
                                    }
                                }
                            }
                            catch {
                                fatalError("Failure to save context: \(error)")
                            }
                            
                        }
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }


    func initializeFetchResultsController() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.managedObjectContext
        
        let request = NSFetchRequest<Element>(entityName: "Element")
        
        let sectionSort = NSSortDescriptor(key: "group", ascending: true)
        let numberSort = NSSortDescriptor(key: "number", ascending: true)
        request.sortDescriptors = [sectionSort, numberSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "group", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let sections = fetchedResultsController.sections else {
            fatalError("NO SECTIONS IN FETCHEDRESULTSCONTROLLER")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElementCollectionViewCell
        
        let source = fetchedResultsController.object(at: indexPath)
        if let symbol = source.symbol {
                cell.elementView.elementSymbol.text = "\(symbol)"
                cell.elementView.elementNumber.text = "\(source.number)"
        }
        

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
