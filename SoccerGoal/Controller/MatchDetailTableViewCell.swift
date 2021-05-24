//
//  MatchDetailTableViewCell.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-23.
//

import UIKit

class MatchDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(with bookingDetails : MatchDetailBooking, with statusTeam : String) {
        if statusTeam == "home"{
         
        }
    }
    
    func updateUI(with error: String) {
        homeTeamLabel.text = "no data available"
        awayTeamLabel.text = "no data available"
    }

}
