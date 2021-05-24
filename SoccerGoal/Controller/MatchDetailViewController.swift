//
//  MatchDetailViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-21.
//

import UIKit

class MatchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let dataInfoUtility = DataInfoUtility()
    var callStatus: Bool = false
    var errorStatus: String = "No info found"
    var matchDetails = listOfMatchDetails
    var matchId : Int?
    var homeTeamLogo : Data?
    var awayTeamLogo : Data?
    
    init?(coder: NSCoder, matchId: Int?, homeTeamLogo : Data?, awayTeamLogo : Data?) {
        self.matchId = matchId
        self.homeTeamLogo = homeTeamLogo
        self.awayTeamLogo = awayTeamLogo
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var matchStatsTableView: UITableView!
    @IBOutlet weak var homeFavoriteTeamButton: UIButton!
    @IBOutlet weak var awayFavoriteTeamButton: UIButton!
    @IBOutlet weak var homeTeamLogoImageView: UIImageView!
    @IBOutlet weak var awayTeamLogoImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var matchTimeLabel: UILabel!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var refereeNameLabel: UILabel!
    @IBOutlet weak var nationalityRefereeLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchStatsTableView.delegate = self
        matchStatsTableView.dataSource = self

        if let matchId = matchId {
            dataInfoUtility.fetchMatchDetail(matchId: matchId) { [self] (result) in
                DispatchQueue.main.sync {
                    switch result {
                    case .success(let data):
                        matchDetails = [data]
                        title = "\(matchDetails[0].homeTeam.name) vs \(matchDetails[0].awayTeam.name)"
                        homeTeamLogoImageView.image = homeTeamLogo?.image
                        awayTeamLogoImageView.image = awayTeamLogo?.image
                        
                        if let scoreHome = matchDetails[0].score?.fullTime?.homeTeam{
                            scoreLabel.text = String(scoreHome)
                            scoreLabel.text! += " - "
                        }
                        if let scoreAway = matchDetails[0].score?.fullTime?.awayTeam{
                            scoreLabel.text! += String(scoreAway)
                        }
                        matchTimeLabel.text = DataInfoUtility.dateFormatterHours.string(from: matchDetails[0].utcDate)
                        stadiumNameLabel.text = "🏟 \(matchDetails[0].venue)"
                        matchDateLabel.text = DataInfoUtility.dateFormatterDayOfTheWeek.string(from: matchDetails[0].utcDate)
                        refereeNameLabel.text = matchDetails[0].referees![0].name
                        nationalityRefereeLabel.text = matchDetails[0].referees![0].nationality
                        matchStatsTableView.reloadData()
                        callStatus = true
                    case .failure(let error):
                        print(error)
                        callStatus = false
                        matchStatsTableView.reloadData()
                    }
                }
            }
        }
        else {
        }
    }
    
    @IBAction func homeFavoriteTeamPressed(_ sender: UIButton) {
        if homeFavoriteTeamButton.currentImage == UIImage(systemName: "star"){
            let favorite = FavoriteTeam(id: matchDetails[0].homeTeam.id, name: matchDetails[0].homeTeam.name, image: homeTeamLogo?.image?.data)
            listOfFavorites.append(favorite)
            //Favorite.saveFavorites(favorites)
            homeFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)

        }else if homeFavoriteTeamButton.currentImage == UIImage(systemName: "star.fill") {
            for element in listOfFavorites {
                if element.id == matchDetails[0].homeTeam.id{
                    if let index = listOfFavorites.firstIndex(of: element) {
                        listOfFavorites.remove(at: index)
                        //Favorite.saveFavorites(favorites)
                        homeFavoriteTeamButton.setImage(UIImage(systemName: "star"), for: .normal)
                    }
                }
            }
        }
        print(listOfFavorites.description)
    
    }
    
    @IBAction func awayFavoriteTeamPressed(_ sender: UIButton) {
        if awayFavoriteTeamButton.currentImage == UIImage(systemName: "star"){
            let favorite = FavoriteTeam(id: matchDetails[0].awayTeam.id, name: matchDetails[0].awayTeam.name, image: awayTeamLogo?.image?.data)
            listOfFavorites.append(favorite)
            //Favorite.saveFavorites(favorites)
            awayFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)

        }else if awayFavoriteTeamButton.currentImage == UIImage(systemName: "star.fill") {
            for element in listOfFavorites {
                if element.id == matchDetails[0].awayTeam.id{
                    if let index = listOfFavorites.firstIndex(of: element) {
                        listOfFavorites.remove(at: index)
                        //Favorite.saveFavorites(favorites)
                        awayFavoriteTeamButton.setImage(UIImage(systemName: "star"), for: .normal)
                    }
                }
            }
        }
        print(listOfFavorites.description)
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
               switch tableView {
                   case matchStatsTableView:
                    print("")
                    //guard let goals = matchDetails[0].goals?.count else { return 1 }
                    //guard let booking  = matchDetails[0].bookings?.count else { return 1 }
                    //guard let substitutions = matchDetails[0].substitutions?.count else { return 1 }
                    //numberOfRow = goals + booking + substitutions
                    //numberOfRow = booking
                   default:
                       print("something is wrong")
                   }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var statusTeam  = "home"
        let cell = UITableViewCell()
        switch tableView {
            case matchStatsTableView:
               let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! MatchDetailTableViewCell
                
                //let matchDetails = matchDetails[indexPath.row]
//                guard let booking = matchDetails.bookings?[indexPath.row] else { return <#default value#> }
//                guard let subtitution = matchDetails.substitutions?[indexPath.row] else { return <#default value#> }
//                guard let goals = matchDetails.goals?[indexPath.row] else { return <#default value#> }
                
//                if matchDetails[0].homeTeam.name == matchDetails[0].bookings?[indexPath.row].team.name{
//                    statusTeam = "home"
//                    if let stats = matchDetails[0].bookings?[indexPath.row] {
//                        if callStatus{
//                            cell.updateUI(with: stats, with: statusTeam)
//                        }
//                        else {
//                            cell.updateUI(with: errorStatus)
//                        }
//                    }
//                }
                
                
                cell.showsReorderControl = true
                return cell
        default:
            print("Something is Wrong")
        }
        return cell

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        matchStatsTableView.reloadData()
    }
    
}
