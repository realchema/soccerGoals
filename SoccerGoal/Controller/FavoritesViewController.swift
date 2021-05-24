//
//  FavoritesViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-23.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var callStatus: Bool = false
    var errorStatus: String = "No favorites found"
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        if listOfFavorites.isEmpty {
            callStatus = false
        }
        else {
            callStatus = true
        }
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

}
