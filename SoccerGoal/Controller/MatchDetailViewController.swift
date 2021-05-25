//
//  MatchDetailViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-21.
//

import UIKit
import CoreData

class MatchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let dataInfoUtility = DataInfoUtility()
    let databaseCRUD = DatabaseCRUD()
    var callStatus: Bool = false
    var errorStatus: String = "No info found"
    var matchDetails = listOfMatchDetails
    var matchId : Int?
    var homeTeamLogo : Data?
    var awayTeamLogo : Data?
    var awayTeamId: Int?
    var homeTeamId: Int?
    
    init?(coder: NSCoder, matchId: Int?, homeTeamLogo : Data?, awayTeamLogo : Data?, awayTeamId: Int?, homeTeamId: Int?) {
        self.matchId = matchId
        self.homeTeamLogo = homeTeamLogo
        self.awayTeamLogo = awayTeamLogo
        self.awayTeamId = awayTeamId
        self.homeTeamId = homeTeamId
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
                        databaseCRUD.retrieveValues()
                        matchDetails = [data]
                        print("holaaaaa")
                        print(listOfFavorites.description)
                        print(matchDetails[0].awayTeam.id)
                        //checkIfFavorite(matchDetail: matchDetails[0])
                        for element in listOfFavorites{
                            if awayTeamId == element.id{
                                print("true")
                                awayFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                            }
                            if homeTeamId == element.id{
                                homeFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                            }
                        }
                        
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
            //listOfFavorites.append(favorite)
            //Favorite.saveFavorites(favorites)
            self.save(favorite: favorite)
            homeFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)

        }else if homeFavoriteTeamButton.currentImage == UIImage(systemName: "star.fill") {
            homeFavoriteTeamButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.deleteDb(value: String(matchDetails[0].homeTeam.id))
            //for element in listOfFavorites {
                //if element.id == matchDetails[0].homeTeam.id{
                    //if let index = listOfFavorites.firstIndex(of: element) {
                        //listOfFavorites.remove(at: index)
                        
                        //Favorite.saveFavorites(favorites)
                        
                    //}
                //}
            //}
        }
    }
    
    @IBAction func awayFavoriteTeamPressed(_ sender: UIButton) {
        if awayFavoriteTeamButton.currentImage == UIImage(systemName: "star"){
            let favorite = FavoriteTeam(id: matchDetails[0].awayTeam.id, name: matchDetails[0].awayTeam.name, image: awayTeamLogo?.image?.data)
            //listOfFavorites.append(favorite)
            //Favorite.saveFavorites(favorites)
            self.save(favorite: favorite)
            awayFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)

        }else if awayFavoriteTeamButton.currentImage == UIImage(systemName: "star.fill") {
            self.deleteDb(value: String(matchDetails[0].awayTeam.id))
            awayFavoriteTeamButton.setImage(UIImage(systemName: "star"), for: .normal)
//            for element in listOfFavorites {
//                if element.id == matchDetails[0].awayTeam.id{
//                    if let index = listOfFavorites.firstIndex(of: element) {
//                        listOfFavorites.remove(at: index)
//
//                        //Favorite.saveFavorites(favorites)
//
//                    }
//                }
//            }
        }
        //print(listOfFavorites.description)
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
    
    func checkIfFavorite(matchDetail: MatchDetail){
        databaseCRUD.retrieveValues()
        for element in listOfFavorites {
            if element.id == matchDetail.homeTeam.id {
                homeFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            else if element.id == matchDetail.awayTeam.id {
                awayFavoriteTeamButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
    }
    
}

extension MatchDetailViewController {
    
    func save(favorite: FavoriteTeam){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context  = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "FavsTeams", in: context) else {return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            newValue.setValue(favorite.id, forKey: "id")
            newValue.setValue(favorite.name, forKey: "name")
            newValue.setValue(favorite.image, forKey: "image")
            
            do {
                try context.save()
                print("Saved: \(favorite.id)\(favorite.name)\(favorite.image)")
                databaseCRUD.retrieveValues()
            } catch  {
                print("Saving Error")
            }
        }
    }
    
    func deleteDb(value: String){
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
                databaseCRUD.retrieveValues()
            } catch  {
                print("Saving Error")
            }
        }
    }
    
    
}
