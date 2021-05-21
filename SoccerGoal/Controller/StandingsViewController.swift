//
//  StandingsViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-20.
//

import UIKit

class StandingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataInfoUtility = DataInfoUtility()
    var callStatus: Bool = false
    var errorStatus: String = "No info found"
    var standings = teamStandingTable
    
    var leagueId: Int?
    var leagueName: String?
    var leagueCrestURL: String?
    init?(coder: NSCoder, leagueId: Int?, leagueName: String?, leagueCrestURL: String?) {
        self.leagueId = leagueId
        self.leagueName = leagueName
        self.leagueCrestURL = leagueCrestURL
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var standingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        standingTableView.delegate = self
        standingTableView.dataSource = self
        
        if let leagueId = leagueId {
//            imageViewDetail.image = movieImage
//            nameTextField.text = result.title
//            overviewTextView.text = result.overview
//            releaseDateTextField.text = result.release_date
            
            dataInfoUtility.fetchLatestStandings(competitionId: leagueId) { (result) in
                DispatchQueue.main.sync {
                    switch result {
                    case .success(let data):
                        //print(data)
                        self.standings = data
                        print(self.standings.description)
                        self.standingTableView.reloadData()
                        self.callStatus = true
                    case .failure(let error):
                        print(error)
                        self.callStatus = false
                        self.standingTableView.reloadData()
                    }
                }
            }
        } else {
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
               switch tableView {
                   case standingTableView:
                    numberOfRow = standings.count
                   default:
                       print("something is wrong")
                   }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch tableView {
            case standingTableView:
               let cell = tableView.dequeueReusableCell(withIdentifier: "standingCell", for: indexPath) as! StandingsTableViewCell
                let standing = standings[indexPath.row]
                if callStatus{
                    cell.updateUI(with: standing, index: indexPath.row)
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
        standingTableView.reloadData()
    }
}
