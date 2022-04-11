//
//  ApiManager.swift
//  smartag
//
//  Created by Rubén Alonso on 28/12/2020.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class APIManager {
    
    static let shared = APIManager()
    var accessToken: String?
    private init(){ }
    
    
    private func parseError<T>(error: AFError,
                               data: Data?,
                               code: Int,
                               completion:  ((Result<T, B4FError>) -> Void)?) {
        switch error {
        case .requestAdaptationFailed(let error):
            completion?(.failure(error as! B4FError))
        case .requestRetryFailed(let error, _):
            completion?(.failure(error as! B4FError))
        default:
            completion?(.failure(B4FError(error: error,
                                            data: data,
                                            code: code)))
        }
    }
    
    func vinculation(parameters: VinculationRequest, _ completion: ((Result<Vinculation, B4FError>) -> Void)?) {
        AF.request(Constants.API.Access.vinculation,
                   method: .post,
                   parameters: parameters.toJSON(),
                   encoding: JSONEncoding.default,
                   interceptor: VinculationInterceptor())
            .validate()
            .responseObject { (response: DataResponse<Vinculation, AFError>) in
                switch response.result {
                case .success(let value):
                    self.accessToken = value.accessToken
                    completion?(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getUserCampaigns(query: Query?, _ completion: @escaping (Result<CampaignList, B4FError>) -> Void) {
        let url = Constants.API.Campaigns.user
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CampaignList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getAvailableCampaigns(query: Query?, _ completion: @escaping (Result<CampaignList, B4FError>) -> Void) {
        let url = Constants.API.Campaigns.available
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CampaignList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func getCampaignBy(id: String, _ completion: @escaping (Result<CampaignDetail, B4FError>) -> Void) {
        let url = Constants.API.Campaigns.get.replacingOccurrences(of: Constants.API.Campaigns.replace,
                                                                   with: "\(id)")
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CampaignDetail, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getCampaignFilters(_ completion: @escaping (Result<CampaignFilter, B4FError>) -> Void) {
        let url = Constants.API.Campaigns.filter
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CampaignFilter, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func linkAndSubscribeToCampaignWith(id: String, code: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.Campaigns.linkAndSubscribe.replacingOccurrences(of: Constants.API.Campaigns.replace,
                                                                                with: "\(id)")
        let parameters = LinkRequest(code: code)
        AF.request(url,
                   method: .post,
                   parameters: parameters.toJSON(),
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func subscribeToCampaignWith(id: String, smartTagId: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.Campaigns.subscribe.replacingOccurrences(of: Constants.API.Campaigns.replace,
                                                                         with: "\(id)")
        let parameters = SubscribeRequest(id: smartTagId)
        AF.request(url,
                   method: .post,
                   parameters: parameters.toJSON(),
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func unsubscribeFromCampaignWith(id: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.Coupons.unsubscribe.replacingOccurrences(of: Constants.API.Coupons.replace,
                                                                         with: "\(id)")
        AF.request(url,
                   method: .delete,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getCoupons(query: Query?, _ completion: @escaping (Result<CouponList, B4FError>) -> Void) {
        let url = Constants.API.Coupons.available
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CouponList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getCouponsUnavailable(query: Query?, _ completion: @escaping (Result<CouponList, B4FError>) -> Void) {
        let url = Constants.API.Coupons.unavailable
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CouponList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getFiltersCoupon(query: Query?, _ completion: @escaping (Result<CouponFilter, B4FError>) -> Void) {
        let url = Constants.API.Coupons.filter
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CouponFilter, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getCouponBy(id: String, _ completion: @escaping (Result<CouponListItem, B4FError>) -> Void) {
        let url = Constants.API.Coupons.get.replacingOccurrences(of: Constants.API.Coupons.replace,
                                                                 with: "\(id)")
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<CouponListItem, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func redeemCouponWith(id: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.Coupons.redeem.replacingOccurrences(of: Constants.API.Coupons.replace,
                                                                    with: id)
        AF.request(url,
                   method: .put,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func getNews(query: Query?, _ completion: @escaping (Result<NewsList, B4FError>) -> Void) {
        let url = Constants.API.News.list
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<NewsList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func getNewBy(id: String, _ completion: @escaping (Result<NewsDetail, B4FError>) -> Void) {
        let url = Constants.API.News.get.replacingOccurrences(of: Constants.API.Campaigns.replace,
                                                              with: id)
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<NewsDetail, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func getSmartTags(query: Query?, _ completion: @escaping (Result<SmartTagList, B4FError>) -> Void) {
        let url = Constants.API.SmartTag.list
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<SmartTagList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func getSmartTagBy(id: String, _ completion: @escaping (Result<SmartTagListItem, B4FError>) -> Void) {
        let url = Constants.API.SmartTag.get.replacingOccurrences(of: Constants.API.SmartTag.replace,
                                                                  with: id)
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<SmartTagListItem, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func associateSmartTag(code: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.SmartTag.list
        let parameters = LinkRequest(code: code)
        AF.request(url,
                   method: .post,
                   parameters: parameters.toJSON(),
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
    
    func disassociateSmartTag(code: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.SmartTag.list
        let parameters = LinkRequest(code: code)
        AF.request(url,
                   method: .delete,
                   parameters: parameters.toJSON(),
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { (response) in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getAlerts(query: Query?, _ completion: @escaping (Result<AlertList, B4FError>) -> Void) {
        let url = Constants.API.Alert.list
        AF.request(url,
                   method: .get,
                   parameters: query?.toJSON(),
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<AlertList, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getNotReadAlertsCount(_ completion: @escaping (Result<AlertCountNotRead, B4FError>) -> Void) {
        let url = Constants.API.Alert.notRead
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding(arrayEncoding: .noBrackets),
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<AlertCountNotRead, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func readAlertBy(id: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.Alert.read.replacingOccurrences(of: Constants.API.Alert.replace,
                                                                with: id)
        AF.request(url,
                   method: .put,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func readAllAlerts(_ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.Alert.readAll
        AF.request(url,
                   method: .put,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func getUser(_ completion: @escaping (Result<User, B4FError>) -> Void) {
        let url = Constants.API.User.get
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<User, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func updateUser(user: User, _ completion: @escaping (Result<User, B4FError>) -> Void) {
        let url = Constants.API.User.get
        AF.request(url,
                   method: .put,
                   parameters: user.toJSON(),
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .responseObject { (response: DataResponse<User, AFError>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }

    func deleteUser(_ completion: @escaping (Result<Void, B4FError>) -> Void) {
        let url = Constants.API.User.get
        AF.request(url,
                   method: .delete,
                   encoding: JSONEncoding.default,
                   interceptor: APIInterceptor())
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    self.parseError(error: error,
                                    data: response.data,
                                    code: response.response?.statusCode ?? 400,
                                    completion: completion)
                }
            }
    }
}
