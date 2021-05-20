//
//  MatchTableViewCell.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-18.
//

import UIKit
import SVGKit

class MatchTableViewCell: UITableViewCell {
    
    let dataInfoUtility = DataInfoUtility()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var matchTimeLabel: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func updateUI(with matchInfo: Match, index: Int) {
        print(matchInfo.homeTeam.clubLogoUrl!)
        let path = matchInfo.homeTeam.clubLogoUrl!
       
        print(path)
        if let url = URL(string: path) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    let mySVGImage: SVGKImage = SVGKImage(data: data)
                    self.homeImageView?.image = mySVGImage.uiImage
                    self.homeTeamNameLabel.text = matchInfo.homeTeam.name
                    if let homeScore = matchInfo.score.fullTime?.homeTeam {
                        self.homeScoreLabel.text = String(homeScore)
                    }
                    
                    self.matchTimeLabel.text = DataInfoUtility.dateFormatterHours.string(from: matchInfo.utcDate)
                }
            }
            
            task.resume()
        }
        
        if let url2 = URL(string: matchInfo.awayTeam.clubLogoUrl!) {
            let task = URLSession.shared.dataTask(with: url2) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    let mySVGImage: SVGKImage = SVGKImage(data: data)
                    self.awayImageView.image = mySVGImage.uiImage
                    self.awayTeamNameLabel.text = matchInfo.awayTeam.name
                    if let awayScore = matchInfo.score.fullTime?.awayTeam {
                        self.awayScoreLabel.text = String(awayScore)
                    }
                }
            }
            
            task.resume()
        }
        
//        let url = URL(string: matchInfo.homeTeam.clubLogoUrl!)
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                self.homeImageView.image = UIImage(data: data!)
//                self.homeTeamNameLabel.text = matchInfo.homeTeam.name
//                if let homeScore = matchInfo.score.fullTime?.homeTeam {
//                    self.homeScoreLabel.text = String(homeScore)
//                }
//                self.matchTimeLabel.text = matchInfo.utcDate.description
//            }
//        }
//
//        let url2 = URL(string: matchInfo.awayTeam.clubLogoUrl!)
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url2!)
//            DispatchQueue.main.async {
//                self.awayImageView.image = UIImage(data: data!)
//                self.awayTeamNameLabel.text = matchInfo.awayTeam.name
//                if let awayScore = matchInfo.score.fullTime?.awayTeam {
//                    self.awayScoreLabel.text = String(awayScore)
//                }
//
//            }
//        }
        
    }
    
    func updateUI(with error: Error) {
        homeImageView.image = UIImage(systemName: "exclamationmark.octagon")
        awayImageView.image = UIImage(systemName: "exclamationmark.octagon")
        homeTeamNameLabel.text = "homeName"
        awayTeamNameLabel.text = "awayName"
        homeScoreLabel.text = "0"
        awayScoreLabel.text = "0"
        matchTimeLabel.text = "time"
    }
    
    
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//    
//    func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async() { [weak self] in
//                self?.imageView!.image = UIImage(data: data)
//            }
//        }
//    }

}




//    func updateUI(with matchInfo: Match, index: Int) {
//        fetchImage(from: matchInfo.homeTeam.clubLogoUrl!) { (result) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self.homeImageView.image = image
//                    self.homeTeamNameLabel.text = matchInfo.homeTeam.name
//                    if let homeScore = matchInfo.score.fullTime?.homeTeam {
//                        self.homeScoreLabel.text = String(homeScore)
//                    }
//                    self.matchTimeLabel.text = matchInfo.utcDate.description
//                case .failure(let error):
//                    self.updateUI(with: error)
//                    print("errrrrrrrror1")
//                    print(error)
//                }
//            }
//        }
//        fetchImage(from: matchInfo.awayTeam.clubLogoUrl!) { (result) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self.awayImageView.image = image
//                    self.awayTeamNameLabel.text = matchInfo.awayTeam.name
//                    if let awayScore = matchInfo.score.fullTime?.awayTeam {
//                        self.awayScoreLabel.text = String(awayScore)
//                    }
//                case .failure(let error):
//                    self.updateUI(with: error)
//                    print("errrrrrrrror2")
//                }
//            }
//        }
