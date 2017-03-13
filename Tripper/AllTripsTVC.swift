//
//  AllTripsTVC.swift
//  TravelBook
//
//  Created by Sebastian Strus on 2017-03-11.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import CoreData

class AllTripsTVC: UITableViewController {

    var allTrips: [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "sky")
        self.tableView.backgroundView = UIImageView(image: backgroundImage)
        tableView.backgroundColor = UIColor.clear

        // retrive from CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        do {
            let trips = try context.fetch(request) as! [Trip]
            allTrips = trips
        }
        catch let error {
            print("\(error)")
        }
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let delete = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAll))
        delete.tintColor = UIColor.red
        
        navigationItem.rightBarButtonItems = [add, delete]
    }

    func addTapped() {
        performSegue(withIdentifier: "newTripSegue", sender: nil)
    }
    
    func deleteAll() {
        let isEmpty = allTrips?.isEmpty
        let message = isEmpty! ? "There is no trips." : "Are you sure you want to delete all the trips??"
        let alertController = UIAlertController(title: "DELETE ALL ITEMS", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (result: UIAlertAction) -> Void in
            print("ok")
        }
        let deleteAllAction = UIAlertAction(title: "Delete all", style: .destructive) { (result: UIAlertAction) -> Void in
            self.deleteAllData(entity: "Trip")
            self.allTrips?.removeAll()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result: UIAlertAction) -> Void in
            print("cancel")
        }
        if !isEmpty! {
            alertController.addAction(deleteAllAction)
            alertController.addAction(cancelAction)
        }
        else {
            alertController.addAction(okAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }

    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    




    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTrips!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.imageView?.image = UIImage(data: allTrips?[indexPath.row].image as! Data)
        cell.imageView?.frame.size.width = 80
        
        cell.textLabel?.text = allTrips?[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "Baskerville-BoldItalic", size:25)
        
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: delete from CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
            do {
                let results = try context.fetch(request)
                if !results.isEmpty {
                    for result in results as! [Trip] {
                        if let title = result.value(forKey: "title") as? String {
                            //TODO: set old and new image that vill change image in CoreData
                            if title == allTrips?[indexPath.row].title {//or == unik number
                                context.delete(result as NSManagedObject)
                                print("deleted")
                                do {
                                    try context.save()
                                    print("saved")
                                }
                                catch {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                print("error when retrieving")
            }
            
            
            allTrips?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTrip" {
            if let IndexPath = self.tableView.indexPathForSelectedRow {
                let trip = allTrips?[IndexPath.row]
                (segue.destination as! TripVC).trip = trip
            }
        }
    }
}

