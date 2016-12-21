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
    
    var elements = [Element]()
    var fetchedResultsController: NSFetchedResultsController<Element>!
    let data = [("H", 1), ("He", 2), ("Li", 3)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName:"ElementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        getData()
        
        

        // Do any additional setup after loading the view.
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

    
//    func initializeFetchResultsController() {
//        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.managedObjectContext
//        
//        let request = NSFetchRequest<Element>(entityName: "Element")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElementCollectionViewCell
    
        // Configure the cell
        cell.elementView.elementSymbol.text = "\(data[indexPath.row].0)"
        cell.elementView.elementNumber.text = "\(data[indexPath.row].1)"

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
