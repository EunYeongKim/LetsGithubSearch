//
//  RepositoryService.swift
//  LetsGitHubSearch
//
//  Created by Suyeol Jeon on 03/11/2018.
//  Copyright © 2018 Suyeol Jeon. All rights reserved.
//

import Alamofire

protocol RepositoryServiceProtocol {
    @discardableResult
    func search(keyword: String, completionHandler: @escaping (Result<RepositorySearchResult>) -> Void) -> DataRequest
}

// 단순히 search라는 메소드 제공
//    - Alamofire를 사용해서 url에 쿼리를 날리고 그 결과를 decodable로 맵핑함
final class RepositoryService: RepositoryServiceProtocol{
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    //class func -> func : 인스턴스 메소드로 변경
    @discardableResult
      func search(keyword: String, completionHandler: @escaping (Result<RepositorySearchResult>) -> Void) -> DataRequest {
        let url = "https://api.github.com/search/repositories"
        let parameters: Parameters = ["q": keyword]
        return self.sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding(), headers: nil)
          .responseData { response in
            let decoder = JSONDecoder()
            let result = response.result.flatMap {
              try decoder.decode(RepositorySearchResult.self, from: $0)
            }
            completionHandler(result)
          }
      }
}


