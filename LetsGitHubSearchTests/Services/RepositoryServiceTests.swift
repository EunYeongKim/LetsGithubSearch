//
//  RepositoryServiceTests.swift
//  LetsGitHubSearchTests
//
//  Created by 60080252 on 2021/04/27.
//  Copyright © 2021 Suyeol Jeon. All rights reserved.
//

import XCTest
@testable import Alamofire
@testable import LetsGitHubSearch

final class SessionManagerStub: SessionManagerProtocol {
    var requestParameters: (
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?
    )?
    
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest {
        // 원하는 응답을 내려줄 수 있게 stub을 할 것임
        // request 메소드가 호출되었을 떄 멤버변수로 저장
        // 가짜 stub객체가 실제 request가 발생되면 stub객체자 가지고 있는 requestParamters안에 가장 최근에 불리워지었던 request함수의 parameter들이 기록이 됨
        // 정확한 url, HTTPMethod, parameter들이 들어가있는지만 확인하면 됨
        self.requestParameters = (
            url: url,
            method: method,
            parameters: parameters
        )
        // return값이 중요한게 아니기 때문에 dummy값으로 넣으면 됨
        return DataRequest.init(session: URLSession(), requestTask: .data(nil, nil))
    }
}

final class RepositoryServiceTests: XCTestCase {
    func testSearch_serachGitHub() {
        //given : 레포지토리 서비스를 만들 때 주입을 시켜줌
        let sessionManager = SessionManagerStub()
        let service = RepositoryService(
            sessionManager: sessionManager
        )
        
        //when : 서비스에 있는 search 메소드 호출
        service.search(keyword: "Let Swift",
                       completionHandler: { _ in })
        
        //then : sessionMangerStub에서 뭔가를 검사하면 됨
        //sessionManager의 requestParameters를 검사하면 됨
        let params = sessionManager.requestParameters
        
        XCTAssertEqual(try params?.url.asURL().absoluteString,
                       "https://api.github.com/search/repositories")
        
        XCTAssertEqual(params?.method,
                       HTTPMethod.get)
        
        XCTAssertEqual(params?.parameters as? [String: String],
                       ["q" : "Let Swift"])
        
//        // given
//            let expectation = XCTestExpectation()
//            XCTWaiter().wait(for: [expectation], timeout: 10)
//        //when
//        service.search(
//            keyword: "RxSwift",
//            completionHandler: { result in
//                expectation.fulfill()
//                XCTAssertEqual(result.isSuccess, true)
//                XCTAssertEqual(result.value?.items.contains {
//                    $0.name == "RxSwift"
//                }, true)
//            }
//        )
    }
}
