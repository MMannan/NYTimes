//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Mannan on 12/23/20.
//  Copyright © 2020 Muhammad Mannan. All rights reserved.
//

import UIKit


/// This class is created to set the details of selected Article
class ArticleDetailController: UIViewController {

    var viewModel: ArticleDetailViewModel?
    
    @IBOutlet weak var articleDetailTextView: UITextView!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureArticleDetailsView()
    }
    
    
    /// This function will set the details of an Article
    func configureArticleDetailsView() {
        self.articleTitleLabel.text = viewModel?.articleDetail.title ?? ""
        self.articleAuthorLabel.text = viewModel?.articleDetail.byline ?? ""
        self.articleDateLabel.text = viewModel?.articleDetail.publishedDate ?? ""
        self.articleDetailTextView.text = viewModel?.articleDetail.abstract ?? ""
        self.articleImageView.contentMode = .scaleAspectFill
        self.articleImageView.clipsToBounds = true
        
        guard let media = viewModel?.articleDetail.media?.first,
           media.type == MediaType.image,
           let imageDetails = media.mediaMetadata?.first(where: { $0.format?.rawValue == Format.medium.rawValue }) else {
            
            self.articleImageView.image = UIImage(named: Constants.Defaults.iconNews)
            return
        }
        articleImageView.image = NetworkManager.downloadImageFromURL(imageURL: imageDetails.url ?? "", imageView: articleImageView, placeholder: Constants.Defaults.iconNews)
    }
}
