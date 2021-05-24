//
//  ViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-13.
//

import UIKit

class MatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let dataInfoUtility = DataInfoUtility()
    var callStatus: Bool = false
    var errorStatus: Error? = nil
    
    
    @IBOutlet weak var matchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchTableView.delegate = self
        matchTableView.dataSource = self
        

        
        dataInfoUtility.fetchLatestMatches(competitionId: 2014) { (result) in
            DispatchQueue.main.sync {
                switch result {
                case .success(let data):
                    //print(data)
                    
                    
                    self.callStatus = true
                    self.matchTableView.reloadData()
                case .failure(let error):
                    print(error)
                    self.callStatus = false
                    self.errorStatus = error
                    self.matchTableView.reloadData()
                }
            }
        }
    
    }
    
    @IBSegueAction func showMatchDetails(_ coder: NSCoder, sender: Any?) -> MatchDetailViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = matchTableView.indexPath(for: cell) {
            let matchId = latestMatches[indexPath.row].id
            let homeTeamLogo =  latestMatches[indexPath.row].homeTeam.image
            let awayTeamLogo =  latestMatches[indexPath.row].awayTeam.image
            return MatchDetailViewController(coder: coder, matchId: matchId, homeTeamLogo: homeTeamLogo, awayTeamLogo: awayTeamLogo)
        }else{
            return MatchDetailViewController(coder: coder, matchId: nil, homeTeamLogo: nil, awayTeamLogo: nil)
        }
       
    }
    
    
    
    @IBAction func unwindToMatchView(segue: UIStoryboardSegue) {
       
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
               switch tableView {
                   case matchTableView:
                    numberOfRow = latestMatches.count
                    
                   default:
                       print("something is wrong")
                   }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
                switch tableView {
                    case matchTableView:
                       let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchTableViewCell
                        let match = latestMatches[indexPath.row]
                        if callStatus{
                            cell.updateUI(with: match, index: indexPath.row)
                           // matchTableView.reloadData()
                            //print("haaaaa \(matches[indexPath.row])")
                        }
                        else {
                            cell.updateUI(with: errorStatus!)
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
        matchTableView.reloadData()
    }

}

