//
//  SearchRepositoryViewControllerTests.swift
//  LetsGitHubSearchTests
//
//  Created by 60080252 on 2021/04/28.
//  Copyright © 2021 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Alamofire
@testable import LetsGitHubSearch

class SearchRepositoryViewControllerTests: XCTestCase {
    // service를 viewController에서 잘 쓰고 있는지 테스트
    func testSeachBar_search() {
        //given
        let service = RepositoryServiceStub()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchRepositoryViewController") as! SearchRepositoryViewController
        
        viewController.loadViewIfNeeded()
        viewController.repositoryService = service
        
        //when
        let searchBar = viewController.searchController.searchBar
        searchBar.text = "Hello, world!"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        //then
        XCTAssertEqual(service.searchParameters?.keyword, "Hello, world!")
    }
    
    func testActivityIndicator_animating_whenLoading() {
        //given : search가 진행 중일때 searchIndicator 테스트
        let service = RepositoryServiceStub()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchRepositoryViewController") as! SearchRepositoryViewController
        
        viewController.loadViewIfNeeded()
        viewController.repositoryService = service
        
        //when
        let searchBar = viewController.searchController.searchBar
        searchBar.text = "Hello, world!"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        //then
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, true)
    }
    
    func testActivityIndicator_notAnimating_whenLoading() {
        //given : search가 진행 중일때 searchIndicator 테스트
        let service = RepositoryServiceStub()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchRepositoryViewController") as! SearchRepositoryViewController
        
        viewController.loadViewIfNeeded()
        viewController.repositoryService = service
        
        //when
        let searchBar = viewController.searchController.searchBar
        searchBar.text = "Hello, world!"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        //의도적으로 컴플리션 핸들러를 부르는 것임
        service.searchParameters?.completionHandler(
            .failure(NSError(domain: "", code: 0, userInfo: nil))
        )
        
        //then
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, false)
    }
    
    func testTableView_configureCell() {
        // 이름뿐만 아니라 star 개수까지 rendering하는지 확인
        //given : search가 진행 중일때 searchIndicator 테스트
        let service = RepositoryServiceStub()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchRepositoryViewController") as! SearchRepositoryViewController
        
        viewController.loadViewIfNeeded()
        viewController.repositoryService = service
        
        //when
        let searchBar = viewController.searchController.searchBar
        searchBar.text = "Hello, world!"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        let searchResult = RepositorySearchResult(
            totalCount: 3,
            items: [
                Repository(name: "A", starCount: 1321),
                Repository(name: "B", starCount: 9876),
                Repository(name: "C", starCount: 4567)
            ]
        )
        
        service.searchParameters?.completionHandler(
            .success(searchResult)
        )
        
        //then
        let tableView = viewController.tableView
        let cell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell?.textLabel?.text, "A")
        XCTAssertEqual(cell?.detailTextLabel?.text, "⭐️1,321")
    }
}

final class RepositoryServiceStub: RepositoryServiceProtocol {
    var searchParameters: (
        keyword: String,
        completionHandler: (Result<RepositorySearchResult>) -> Void
    )?
    
    @discardableResult
    func search(keyword: String, completionHandler: @escaping (Result<RepositorySearchResult>) -> Void) -> DataRequest {
        self.searchParameters = (
            keyword: keyword,
            completionHandler: completionHandler
        )
        return DataRequest.init(session: URLSession(), requestTask: .data(nil, nil))
    }
}
