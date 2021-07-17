//
//  NetworkManager.swift
//  NYTimes
//
//  Created by Mannan on 15/07/2021.
//

import UIKit
import Alamofire
import AlamofireImage

/// This is a class created for handling Network Requests in the Project
class NetworkManager: NSObject {
    
    /// Call this function to download image from URL
    ///
    /// - Parameters:
    ///   - imageURL: the actual URL to download image
    ///   - imageView: imageView in which the downloaded image will be shown
    ///   - placeholder: this is a placeholde image which will be shown in the imageView untill the image get downloaded from URL.
    /// - Returns: this method will return UIImage
    class func downloadImageFromURL(imageURL: String, imageView: UIImageView, placeholder: String) -> UIImage {
        imageView.af.setImage(
            withURL: URL(string: imageURL)!,
            placeholderImage: UIImage(named: placeholder),
            filter: nil,
            imageTransition: .crossDissolve(0.5))
        
        return imageView.image!
    }
    
    
    /// Call this function to get HTTPHeaders for any Network Request
    ///
    /// - Returns: This function will return HTTPHeaders
    class func headerForNetworkRequest() -> HTTPHeaders {
        var header: HTTPHeaders! = nil
        header = [
                "Content-Type": "application/json"
        ]
        return header
    }
    
    
    /// Call this function to get most popular articles. This will hit a URL by making a Get Request and will get most popular articles
    ///
    /// - Parameter completionHandler: a block containg
    ///   - String -> error message if request failed
    ///   - [Article] -> array of articles
    class func getMostPopularArticles(completionHandler: @escaping (String?, [Article]?) -> Void) {
        let url = URL(string: Constants.APIConstants.baseURL + Constants.APIConstants.getMostViewedArticlesURL)!
        let finalURL = url.appending("api-key", value: Constants.APIConstants.NYTimesKey)
        
        AF.request(finalURL, method: .get, encoding: JSONEncoding.default, headers: headerForNetworkRequest())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    guard let data = response.data else {
                        completionHandler(Constants.Messages.generalErrorMessage, nil)
                        return
                    }
                    do {
                        let articles = try JSONDecoder().decode(Articles.self, from: data)
                        completionHandler(nil, articles.results)
                    } catch let error as NSError {
                        completionHandler(error.localizedDescription, nil)
                    }
                    
                case .failure(let error):
                    completionHandler(error.localizedDescription, nil)
                }
        }
    }
    
}
