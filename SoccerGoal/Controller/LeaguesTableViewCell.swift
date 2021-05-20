//
//  LeaguesTableViewCell.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-20.
//

import UIKit
import SVGKit

class LeaguesTableViewCell: UITableViewCell {
    
    let dataInfoUtility = DataInfoUtility()
    
    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(with competitionInfo: Competition, index: Int) {
      
        let path = competitionInfo.crestURL
       
        print(path)
        if let url = URL(string: path) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    let mySVGImage: SVGKImage = SVGKImage(data: data)
                    self.leagueImage?.image = mySVGImage.uiImage
                    self.leagueNameLabel.text = competitionInfo.name
                }
            }
            
            task.resume()
        }
        
    }
    
    func updateUI(with error: String) {
        leagueImage.image = UIImage(systemName: "exclamationmark.octagon")
        leagueNameLabel.text = error
    }
}
