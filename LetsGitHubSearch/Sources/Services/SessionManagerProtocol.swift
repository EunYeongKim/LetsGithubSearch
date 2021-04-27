//
//  SessionManagerProtocol.swift
//  LetsGitHubSearch
//
//  Created by 60080252 on 2021/04/27.
//  Copyright © 2021 Suyeol Jeon. All rights reserved.
//

import Alamofire

protocol SessionManagerProtocol {
    func request(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    )-> DataRequest
}

// 이미 있는 클래스에 위의 프로토콜을 적용
// requset 메소드를 또 구현하지 않아도 됨 sessionManager는 위에 있는 request 메소드를 이미 구현을 하고 있기 때문
extension SessionManager: SessionManagerProtocol {
}
