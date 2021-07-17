//
//  HomeViewController.swift
//  NYTimes
//
//  Created by Mannan on 15/07/2021.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel?
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Article"
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createViewModel()
        bindViewModel()
    }

    func setupUI() {
        setupTableView()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        tableView.showActivityIndicator()
    }
    
    /// This method will refresh the tableView date when user will do pull to refresh in tableView
    @objc func refreshArticles() {
        viewModel?.fetchArticles()
    }
    
    @IBAction func menuClickAction(_ sender: UIBarButtonItem) {
    }
    
}

// MARK: - Private Methods
extension HomeViewController {
    
    private func createViewModel() {
        viewModel = HomeViewModel()
    }
    
    private func bindViewModel() {
        viewModel?
            .reloadData
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.hideActivityIndicator()
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .showError
            .subscribe(onNext: { [weak self] message in
                DispatchQueue.main.async {
                    self?.showAlertWithMessage(message: message)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .deleteArticle
            .subscribe(onNext: { [weak self] indexPath in
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
// MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfCells() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell {
            if let articleData = self.viewModel?.getArticleDetails(for: indexPath) {
                cell.configure(with: articleData)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.rowHeight() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailController") as? ArticleDetailController {

            if let articleData = self.viewModel?.getArticleDetails(for: indexPath) {
                let viewModel = ArticleDetailViewModel(articleDetail: articleData)
                viewController.viewModel = viewModel
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel?.deleteArticle(for: indexPath)
        }
    }
    
}

// MARK: - UISearchResult Updating and UISearchControllerDelegate  Extension
  extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.performSearchFor(searchQuery: searchController.searchBar.text)
    }
 }

