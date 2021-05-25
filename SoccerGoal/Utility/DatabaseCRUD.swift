//
//  DatabaseCRUD.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-24.
//

import Foundation
import CoreData
import UIKit

struct DatabaseCRUD {
    
    func retrieveValues() {
        listOfFavorites.removeAll()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<FavsTeams>(entityName: "FavsTeams")

            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    let favoriteTeam = FavoriteTeam(id: Int(result.id), name: result.name!, image: result.image)
                    listOfFavorites.append(favoriteTeam)
                    print(listOfFavorites.description)
                }
            } catch  {
                print("could not retrieve")
            }
        }
    }
    
    func deleteAllObjects(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context  = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavsTeams")
            //let result = try? context.fetch(fetchRequest)
            

            do {
                
                //let resultData = result as [FavoriteTeam]
                let favorite = try context.fetch(fetchRequest)
                
                for element in favorite{
                    context.delete(element)
                }
                try context.save()
                print("Objects Deleted")
            } catch  {
                print("Saving Error")
            }
        }
    }
    
    func deleteObject(value: String){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context  = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavsTeams")
            //let result = try? context.fetch(fetchRequest)
            

            do {
                
                //let resultData = result as [FavoriteTeam]
                let favorite = try context.fetch(fetchRequest)
                for i in 0..<listOfFavorites.count {
                    if listOfFavorites[i].id == Int(value) {
                        context.delete(favorite[i])
                    }
                }
                
//                for element in favorite{
//                    context.delete(element)
//                }
                try context.save()
                print("Deleted: \(value)")
                retrieveValues()
            } catch  {
                print("Saving Error")
            }
        }
    }
    
    func saveObject(favorite: FavoriteTeam){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context  = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "FavsTeams", in: context) else {return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            newValue.setValue(favorite.id, forKey: "id")
            newValue.setValue(favorite.name, forKey: "name")
            newValue.setValue(favorite.image, forKey: "image")
            
            do {
                try context.save()
                print("Saved: \(favorite.id)\(favorite.name)\(String(describing: favorite.image))")
                retrieveValues()
            } catch  {
                print("Saving Error")
            }
        }
    }
    
    func updateRecords() -> Void {
            let moc = getContext()

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavsTeams")

            let result = try? moc.fetch(fetchRequest)

                let resultData = result as! [FavoriteTeam]
                for object in resultData {
//                    object.name = "\(object.name)"
                    print(object.name)
                }
                do{
                    try moc.save()
                    print("saved")
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }


        }
    
    // MARK: Get Context

        func getContext () -> NSManagedObjectContext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
}
