//
//  ArticleTableViewCell.swift
//  NYTimes
//
//  Created by Mannan on 15/07/2021.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        articleImageView.layer.cornerRadius = articleImageView.frame.size.width / 2
        articleImageView.layer.masksToBounds = true
        accessoryType = .disclosureIndicator
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    /// This function is used to configure each article cell
    /// - Parameter data: Article details
    func configure(with data: Article) {
        articleTitleLabel.text = data.title
        articleAuthorLabel.text = data.byline
        
        guard let media = data.media?.first,
              media.type == MediaType.image,
              let imageDetails = media.mediaMetadata?.first(where: { $0.format?.rawValue == Format.thumbnail.rawValue }) else {
            
            articleImageView.image = UIImage(named: Constants.Defaults.iconNews)
            return
        }
        
        articleImageView.image = NetworkManager.downloadImageFromURL(imageURL: imageDetails.url ?? "", imageView: articleImageView, placeholder: Constants.Defaults.iconNews)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
