//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by Mannan on 16/07/2021.
//

import XCTest
@testable import RxSwift
@testable import NYTimes

class NYTimesTests: XCTestCase {

    private let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
   
    func testGenericValuesForViewModel() {
        let vm = HomeViewModel()
        let filteredArticles: [Article]? = []
        
        XCTAssertEqual(1, vm.numberOfSections())
        XCTAssertEqual(filteredArticles?.count, vm.numberOfCells())
        XCTAssertEqual(100, vm.rowHeight())
        
        XCTAssertNoThrow(vm.fetchArticles())
        XCTAssertNoThrow(vm.getArticleDetails(for: IndexPath(row: 0, section: 1)))
        XCTAssertNoThrow(vm.deleteArticle(for: IndexPath(row: 0, section: 1)))
        XCTAssertNoThrow(vm.performSearchFor(searchQuery: "King"))
    }
    
    func testGenericValuesForViewController() {
        let vc = HomeViewController()
        XCTAssertNoThrow(vc.searchController)
        
        let tv = UITableView()
        XCTAssertEqual(0, vc.numberOfSections(in: tv))
        XCTAssertEqual(0, vc.tableView(tv, numberOfRowsInSection: 0))
        XCTAssertEqual(0, vc.tableView(tv, heightForRowAt: IndexPath(row: 0, section: 0)))
    }
    
    func testShowError() {
        let expectation = XCTestExpectation(description: Constants.Messages.generalErrorMessage)
        let vm = HomeViewModel()
        vm.showError.subscribe(onNext: {_ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
    }
    
    

}
