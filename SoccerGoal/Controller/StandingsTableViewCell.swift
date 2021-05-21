//
//  StandingsTableViewCell.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-20.
//

import UIKit
import SVGKit

class StandingsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var standingTeamPositionLabel: UILabel!
    @IBOutlet weak var standingTeamImageViewLabel: UIImageView!
    @IBOutlet weak var standingTeamNameLabel: UILabel!
    @IBOutlet weak var standingPlayedGameLabel: UILabel!
    @IBOutlet weak var standingTeamWinsLabel: UILabel!
    @IBOutlet weak var standingTeamDrawsLabel: UILabel!
    @IBOutlet weak var standingTeamLossesLabel: UILabel!
    @IBOutlet weak var standingTeamPointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(with leagueInfo: TeamStandingTable, index: Int) {
        //standingTeamImageViewLabel.image = UIImage(systemName: "exclamationmark.octagon")
        let path = leagueInfo.team.crestUrl

//        print(path)
        if let url = URL(string: path!) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async { /// execute on main thread
                    let mySVGImage: SVGKImage = SVGKImage(data: data)
                    self.standingTeamPositionLabel.text = String(leagueInfo.position)
                    self.standingTeamImageViewLabel?.image = mySVGImage.uiImage
                    self.standingTeamNameLabel.text = leagueInfo.team.name
                    self.standingPlayedGameLabel.text = String(leagueInfo.playedGames)
                    self.standingTeamWinsLabel.text = String(leagueInfo.won)
                    self.standingTeamDrawsLabel.text = String(leagueInfo.draw)
                    self.standingTeamLossesLabel.text = String(leagueInfo.lost)
                    self.standingTeamPointsLabel.text = String(leagueInfo.points)
                }
            }

            task.resume()
        }
        
    }
    
    func updateUI(with error: String) {
        standingTeamImageViewLabel.image = UIImage(systemName: "exclamationmark.octagon")
//        leagueNameLabel.text = error
    }

}
