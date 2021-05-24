//
//  FavoriteDetailTableViewController.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-24.
//

import UIKit
import SafariServices

class FavoriteDetailTableViewController: UITableViewController {
    
    let dataInfoUtility = DataInfoUtility()
    var callStatus: Bool = false
    var errorStatus: String = "No info found"
    var favoriteId: Int?
    var favoriteImage: UIImage?
    var favoriteName: String?
    var site = ""
    
    init?(coder: NSCoder, favoriteId: Int?, favoriteImage: UIImage?, favoriteName: String?) {
        self.favoriteId = favoriteId
        self.favoriteImage = favoriteImage
        self.favoriteName = favoriteName
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var favoriteDetailTeamLogoImageView: UIImageView!
    @IBOutlet weak var favoriteDetailTeamFoundedLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamCountryLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamShortNameLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamShortNameTlaLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamClubColorsLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamStadiumLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamAddressLabel: UILabel!
    @IBOutlet weak var favoriteDetailTeamWebsiteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataInfoUtility.fetchTeamDetail(teamId: favoriteId!) { [self] (result) in
            DispatchQueue.main.sync {
                switch result {
                case .success(let data):
                    //print(data)
                    title = favoriteName
                    favoriteDetailTeamLogoImageView.image = favoriteImage
                    favoriteDetailTeamFoundedLabel.text = String(data.founded ?? 0)
                    favoriteDetailTeamCountryLabel.text = data.area?.name
                    favoriteDetailTeamShortNameLabel.text = data.shortName
                    favoriteDetailTeamShortNameTlaLabel.text = data.tla
                    favoriteDetailTeamClubColorsLabel.text = data.clubColors
                    favoriteDetailTeamStadiumLabel.text = data.venue
                    favoriteDetailTeamAddressLabel.text = data.address
                    favoriteDetailTeamWebsiteButton.setTitle(data.website, for: .normal)
                    site = data.website!
                case .failure(let error):
                    print(error)
                    self.callStatus = false
                }
            }
        }
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        if let url = URL(string: (site)) {
            let safariViewController = SFSafariViewController(url:url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 9
//        } else {
//            return 0
//        }
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
