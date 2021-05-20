//
//  LeaguesViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-20.
//

import UIKit

class LeaguesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let dataInfoUtility = DataInfoUtility()
    var callStatus: Bool = false
    var errorStatus: String = "No leagues found"
    var leagues = Competition.defaultCompetitions
    
    @IBOutlet weak var leaguesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaguesTableView.delegate = self
        leaguesTableView.dataSource = self
       
        if leagues.isEmpty {
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
                   case leaguesTableView:
                    numberOfRow = leagues.count
                    
                   default:
                       print("something is wrong")
                   }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
                switch tableView {
                    case leaguesTableView:
                       let cell = tableView.dequeueReusableCell(withIdentifier: "leaguesCell", for: indexPath) as! LeaguesTableViewCell
                        let league = leagues[indexPath.row]
                        if callStatus{
                            cell.updateUI(with: league, index: indexPath.row)
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
        leaguesTableView.reloadData()
    }

}
