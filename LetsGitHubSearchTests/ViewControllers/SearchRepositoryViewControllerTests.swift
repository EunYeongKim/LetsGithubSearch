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
        XCTAssertEqual(service.searchParameters, "Hello, world!")
    }
}

final class RepositoryServiceStub: RepositoryServiceProtocol {
    var searchParameters: String?
    
    @discardableResult
    func search(keyword: String, completionHandler: @escaping (Result<RepositorySearchResult>) -> Void) -> DataRequest {
        self.searchParameters = keyword
        return DataRequest.init(session: URLSession(), requestTask: .data(nil, nil))
    }
}
