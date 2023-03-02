//
//  UserViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/07.
//

import Moya
import UIKit
import Combine

//MARK: LoginViewModel
final class UserViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    let provider = MoyaProvider<UserService>()
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input.request
            .sink { service in
                switch service {
                case .profileImage:
                    self.requestProfileImage()
                case .terms(let type):
                    self.requestTerms(type: type)
                case .token:
                    self.requestToken()
                case .nickname(let name):
                    self.requestNickname(name: name)
                case .signup(let user):
                    self.requestSignup(user: user)
                case .signin(let user):
                    self.requestSignin(user: user)
                case .signout:
                    self.requestSignOut()
                case .withdrawal:
                    self.requestWithdrawal()
                }
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension UserViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        let request = PassthroughSubject<UserService, Never>()
    }
    
    struct Output {
        let requestProfileImage = PassthroughSubject<[String], Never>()
        let requestTerms = PassthroughSubject<String, Never>()
        let requestToken = PassthroughSubject<String?, Never>()
        let requestNickname = PassthroughSubject<Bool, Never>()
        let requestSignUp = PassthroughSubject<Bool, Never>()
        let requestSignIn = PassthroughSubject<SignIn, Never>()
        let requestSignOut = PassthroughSubject<Bool, Never>()
        let requestWithdrawal = PassthroughSubject<Bool, Never>()
    }
    
    enum SignIn: Int {
        case success = 200
        case register = 401
        case error = 500
    }
}

//MARK: - Method
extension UserViewModel {
    //MARK: 전체 프로필 이미지 조회
    func requestProfileImage() {
        provider.request(.profileImage) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[String]>.self).data else {
                            throw APIError.decoding
                        }
                        self?.output.requestProfileImage.send(model)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: 약관 조회
    func requestTerms(type: String) {
        provider.request(.terms(type)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[String: String]>.self).data,
                              let contents = model["contents"] else {
                            throw APIError.decoding
                        }
                        
                        self?.output.requestTerms.send(contents)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: 토큰 재발급
    func requestToken() {
        provider.request(.token) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[String: String]>.self).data,
                              let key = model["token_type"],
                              let value = model["authorization"] else {
                            throw APIError.decoding
                        }
                        
                        UserDefaults.standard.set("\(key) \(value)", forKey: UserService.ACCESS_TOKEN_KEY)
                        UserDefaults.standard.synchronize()
                        
                        self?.output.requestToken.send(model["message"])
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: 닉네임 중복체크
    func requestNickname(name: String) {
        provider.request(.nickname(name)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        let status = try result.map(APIResponse<[String: String]>.self).status
                        
                        guard var user = UserDefaults.standard.value(forKey: UserService.USER_INFO_KEY) as? [String: Any] else {
                            self?.output.requestNickname.send(false)
                            return
                        }
                        
                        user["nickname"] = name
                        UserDefaults.standard.set(user, forKey: UserService.USER_INFO_KEY)
                        UserDefaults.standard.synchronize()
                        
                        self?.output.requestNickname.send(status == .success)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: 회원가입
    func requestSignup(user: UserModel) {
        provider.request(.signup(user)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[String: String]>.self).data,
                              let key = model["token_type"],
                              let value = model["authorization"] else {
                            throw APIError.decoding
                        }
                        
                        UserDefaults.standard.set("\(key) \(value)", forKey: UserService.ACCESS_TOKEN_KEY)
                        UserDefaults.standard.synchronize()
                        
                        self?.output.requestSignUp.send(true)
                    } catch {
                        self?.output.requestSignUp.send(false)
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    self?.output.requestSignUp.send(false)
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: 로그인
    private func requestSignin(user: UserModel) {
        UserDefaults.standard.removeObject(forKey: UserService.USER_INFO_KEY)
        provider.request(.signin(user)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        let response = try result.map(APIResponse<[String: String]>.self)
                        
                        var status: SignIn = .error
                        if response.status == .success {
                            status = .success
                        } else {
                            status = SignIn(rawValue: response.code ?? 500) ?? .error
                        }
                        
                        switch status {
                        case .success:
                            guard let model = response.data,
                                  let key = model["token_type"],
                                  let value = model["authorization"] else {
                                throw APIError.decoding
                            }
                            
                            UserDefaults.standard.set(user.toDictionary, forKey: UserService.USER_INFO_KEY)
                            UserDefaults.standard.synchronize()
                            
                            UserDefaults.standard.set("\(key) \(value)", forKey: UserService.ACCESS_TOKEN_KEY)
                            UserDefaults.standard.synchronize()
                            
                            self?.output.requestSignIn.send(.success)
                        case .register:
                            UserDefaults.standard.set(user.toDictionary, forKey: UserService.USER_INFO_KEY)
                            self?.output.requestSignIn.send(.register)
                        case .error:
                            self?.output.requestSignIn.send(.error)
                        }
                    } catch {
                        LogUtil.e(error.localizedDescription)
                        self?.output.requestSignIn.send(.error)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                    self?.output.requestSignIn.send(.error)
                }
            }
    }
    //MARK: 로그아웃
    private func requestSignOut() {
        provider.request(.signout) { [weak self] _ in
            UserDefaults.standard.removeObject(forKey: UserService.ACCESS_TOKEN_KEY)
            self?.output.requestSignOut.send(true)
        }
    }
    //MARK: 회원탈퇴
    private func requestWithdrawal() {
        provider.request(.withdrawal) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        let status = try result.map(APIResponse<[String: String]>.self).status
                        
                        if status == .success {
                            UserDefaults.standard.removeObject(forKey: UserService.ACCESS_TOKEN_KEY)
                            self?.output.requestWithdrawal.send(true)
                        } else {
                            self?.output.requestWithdrawal.send(false)
                        }
                    } catch {
                        self?.output.requestWithdrawal.send(false)
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    self?.output.requestWithdrawal.send(false)
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
}
