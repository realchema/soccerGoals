//
//  FavoritesTableViewCell.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-23.
//

import UIKit
import SVGKit
class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteTeamLogoImageView: UIImageView!
    @IBOutlet weak var favoriteTeamNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateUI(with favoriteInfo: FavoriteTeam, index: Int) {
//        let mySVGImage: SVGKImage = SVGKImage(data: favoriteInfo.image)
//        favoriteTeamLogoImageView.image = mySVGImage.uiImage
        favoriteTeamLogoImageView.image = favoriteInfo.image?.image
        favoriteTeamNameLabel.text = favoriteInfo.name
    }
    func updateUI(with error: String) {
        favoriteTeamNameLabel.text = "No Favorite Saved!"
    }

}
