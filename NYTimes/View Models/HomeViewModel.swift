//
//  HomeViewModel.swift
//  NYTimes
//
//  Created by Mannan on 15/07/2021.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var reloadData = PublishSubject<Void>()
    var showError = PublishSubject<String>()
    var deleteArticle = PublishSubject<IndexPath>()
    var articles: [Article]?
    var filteredArticles: [Article]?
    
    init() {
        self.fetchArticles()
    }
    
    /// This function will fetch the news/articles from get request and will set tableView data
    func fetchArticles() {
        NetworkManager.getMostPopularArticles() { [weak self] errorMessage, responseData in
            guard let articles = responseData else {
                self?.showError.onNext(errorMessage ?? Constants.Messages.generalErrorMessage)
                self?.reloadData.onNext(())
                return
            }
            self?.articles = articles
            self?.filteredArticles = articles
            self?.reloadData.onNext(())
        }
    }
    
    func getArticleDetails(for indexPath: IndexPath) -> Article? {
        if let details = self.filteredArticles?[indexPath.row] {
            return details
        }
        return nil
    }
    
    func deleteArticle(for indexPath: IndexPath) {
        if let articleToDelete = self.getArticleDetails(for: indexPath),
           let articleId = articleToDelete.id {
            
            if let articleIndex = self.articles?.firstIndex(where: {$0.id == articleId}),
               let filteredArticleIndex = self.filteredArticles?.firstIndex(where: {$0.id == articleId}) {
                
                self.articles?.remove(at: articleIndex)
                self.filteredArticles?.remove(at: filteredArticleIndex)
                self.deleteArticle.onNext(indexPath)
            }
        }
    }
    
    func performSearchFor(searchQuery: String?) {
        guard let query = searchQuery, !query.isEmpty else {
            filteredArticles?.removeAll()
            filteredArticles?.append(contentsOf: articles ?? [])
            self.reloadData.onNext(())
            return
        }
        
        filteredArticles = articles?.filter({ (article) -> Bool in
            if article.title?.lowercased().contains(query.lowercased()) ?? false ||
                article.byline?.lowercased().contains(query.lowercased()) ?? false {
                return true
            } else {
                return false
            }
        })
        
        self.reloadData.onNext(())
    }
}

extension HomeViewModel {
    //MARK: - Tableview helper methods
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfCells() -> Int {
        return self.filteredArticles?.count ?? 0
    }
    
    func rowHeight() -> CGFloat {
        return 100
    }
}
