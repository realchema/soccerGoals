//
//  FavoritesViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-23.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var callStatus: Bool = false
    var errorStatus: String = "No favorites found"
    
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveValues()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        if listOfFavorites.isEmpty {
            callStatus = false
        }
        else {
            callStatus = true
        }
    }
    
    @IBSegueAction func showFavoriteDetails(_ coder: NSCoder, sender: Any?) -> FavoriteDetailTableViewController {
        if let cell = sender as? UITableViewCell, let indexPath = favoritesTableView.indexPath(for: cell) {
            let favoriteId = listOfFavorites[indexPath.row].id
            let favoriteImage = listOfFavorites[indexPath.row].image?.image
            let favoriteName = listOfFavorites[indexPath.row].name
            return FavoriteDetailTableViewController(coder: coder, favoriteId: favoriteId, favoriteImage: favoriteImage, favoriteName: favoriteName )!
        }else{
            return FavoriteDetailTableViewController(coder: coder, favoriteId: nil, favoriteImage: nil,favoriteName: nil)!
        }
       
    }
    
    @IBAction func unwindToFavoriteTableView(segue: UIStoryboardSegue) {
       
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
               switch tableView {
                   case favoritesTableView:
                    numberOfRow = listOfFavorites.count
                   default:
                       print("something is wrong")
                   }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch tableView {
            case favoritesTableView:
               let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
                let favorite = listOfFavorites[indexPath.row]
                if callStatus{
                    cell.updateUI(with: favorite, index: indexPath.row)
                }
                else {
                    cell.updateUI(with: errorStatus)
                }
                cell.showsReorderControl = true
                return cell
        default:
            print("Something is Wrong")
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesTableView.reloadData()
    }

}

extension FavoritesViewController {
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
                }
            } catch  {
                print("could not retrieve")
            }
        }
    }
}

