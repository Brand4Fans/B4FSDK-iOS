//
//  APIInterceptor.swift
//  smartag
//
//  Created by Rubén Alonso on 29/12/2020.
//

import Foundation
import Alamofire

class VinculationInterceptor: Interceptor {

    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let apiKey = B4F.shared.apiKey else {
            let error = B4FError(message: "apikey_required")
            completion(.failure(error))
            return
        }
        var urlRequest = urlRequest
        urlRequest.headers.add(.acceptLanguage(B4F.shared.language ?? "es"))
        urlRequest.headers.add(name: Constants.API.key, value: apiKey)
        completion(.success(urlRequest))
    }
}

class APIInterceptor: Interceptor {

    private var isRefreshing = false
    private var requestToRetry: [(RetryResult) -> Void] = []
    private var lock = NSRecursiveLock()

    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let apiKey = B4F.shared.apiKey else {
            let error = B4FError(message: "apikey_required")
            completion(.failure(error))
            return
        }
        var urlRequest = urlRequest
        if let accessToken = APIManager.shared.accessToken {
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        urlRequest.headers.add(.acceptLanguage(B4F.shared.language ?? "es"))
        urlRequest.headers.add(name: Constants.API.key, value: apiKey)
        completion(.success(urlRequest))
    }

    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        if request.response?.statusCode == 401 {
            requestToRetry.append(completion)
            if !isRefreshing {
                refresh { [weak self] (error) in
                    guard let _self = self else {
                        completion(.doNotRetry)
                        return
                    }
                    _self.lock.lock()
                    defer { _self.lock.unlock() }
                    if let error = error {
                        _self.requestToRetry.forEach({ $0(.doNotRetryWithError(error))})
                    } else {
                        _self.requestToRetry.forEach({ $0(.retry) })
                    }
                    _self.requestToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    private func refresh(_ completion: @escaping (Error?) -> Void) {
        guard !isRefreshing else { return }
        isRefreshing = true

        let token = (B4F.shared.deviceToken ?? Data()).map { String(format: "%02.2hhx", $0) }.joined()
        guard let userId = B4F.shared.userId else {
            let error = B4FError(message: "user_id_required")
            completion(error)
            return
        }
        let parameters = VinculationRequest(idUser: userId, deviceToken: token)
        APIManager.shared.vinculation(parameters: parameters) { [weak self] (result) in
            guard let _self = self else { return }
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
            _self.isRefreshing = false
        }
    }
}
