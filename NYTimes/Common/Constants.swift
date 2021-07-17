//
//  Constants.swift
//  NYTimes
//
//  Created by Mannan on 15/07/2021.
//


import Foundation
import UIKit

/// This is a class created to handle all constants of the project
class Constants {
    
    // MARK: List of API Constants
    
    /// API Constants
    struct APIConstants {
        
        /// This is a BaseURL
        static let baseURL = "http://api.nytimes.com/svc/mostpopular/v2/"
        
        static let getMostViewedArticlesURL = "mostviewed/all-sections/7.json"
        
        /// This is a API key for New York Times Newspaper
        static let NYTimesKey = "vIa1Di5iVbaI8xcXiwxNTPUGgrADfcz4"
    }
    
    
    // MARK: List of Default Constants
    
    /// Default Constants
    struct Defaults {
        static let iconNews = "icon_news"
        static let iconMenu = "icon_menu"
        static let iconCalendar = "icon_calendar"
        static let iconAuthor = "icon_author"
    }
    
    // MARK: List of Messages
    
    /// Message Strings
    struct Messages {
        
        /// General error message
        static let generalErrorMessage = "Something went wrong. Please try again later"
    }
}
