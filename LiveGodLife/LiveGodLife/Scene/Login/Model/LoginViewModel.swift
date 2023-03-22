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
    var plugin = MoyaPlugin()
    lazy var provider = MoyaProvider<UserService>(plugins: [plugin])
    
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
                case .terms(let term):
                    self.requestTerms(type: term)
                case .token:
                    self.requestToken()
                case .nickname(let name):
                    self.requestNickname(name: name)
                case .signup(let user):
                    self.requestSignup(user: user)
                case .signin(let user):
                    self.requestSignin(user: user)
                case .withdrawal:
                    self.requestWithdrawal()
                case .user:
                    self.requestUser()
                case .heart:
                    self.requestHeart()
                case .bookmark(let id, let status):
                    self.requestBookmark(id: id, status: status)
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
        let requestProfileImage = PassthroughSubject<[ProfileImage], Never>()
        let requestTerms = PassthroughSubject<Term, Never>()
        let requestToken = PassthroughSubject<String?, Never>()
        let requestNickname = PassthroughSubject<Bool, Never>()
        let requestSignUp = PassthroughSubject<Bool, Never>()
        let requestSignIn = PassthroughSubject<SignIn, Never>()
        let requestWithdrawal = PassthroughSubject<Bool, Never>()
        let requestUser = PassthroughSubject<UserModel?, Never>()
        let requestHeart = PassthroughSubject<[Feed], Never>()
        let requestBookmark = PassthroughSubject<Bool, Never>()
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
                        guard let model = try result.map(APIResponse<[ProfileImage]>.self).data else {
                            throw APIError.decoding
                        }
                        self?.output.requestProfileImage.send(model)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                        self?.output.requestProfileImage.send([])
                    }
                case .failure:
                    self?.output.requestProfileImage.send([])
                }
            }
    }
    //MARK: 약관 조회
    func requestTerms(type term: Term.TermType) {
        provider.request(.terms(term)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<Term>.self).data else {
                            throw APIError.decoding
                        }
                        
                        self?.output.requestTerms.send(model)
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
                        let model = try result.map(APIResponse<UserToken>.self)
                        guard let token = model.data else { throw APIError.decoding }
                        
                        UserDefaults.standard.set("Bearer \(token.authorization ?? "")",
                                                  forKey: UserService.ACCESS_TOKEN_KEY)
                        UserDefaults.standard.synchronize()
                        
                        self?.output.requestToken.send(model.message)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                        self?.output.requestToken.send("\(error.localizedDescription)")
                    }
                case .failure(let err):
                    self?.output.requestToken.send("\(err.localizedDescription)")
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
                case .failure:
                    self?.output.requestNickname.send(false)
                }
            }
    }
    //MARK: 회원가입
    func requestSignup(user: UserModel) {
        provider.request(.signup(user)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        let model = try result.map(APIResponse<UserToken>.self)
                        guard let token = model.data else { throw APIError.decoding }
                        
                        UserDefaults.standard.set("Bearer \(token.authorization ?? "")",
                                                  forKey: UserService.ACCESS_TOKEN_KEY)
                        UserDefaults.standard.synchronize()
                        
                        self?.output.requestSignUp.send(true)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                        self?.output.requestSignUp.send(false)
                    }
                case .failure:
                    self?.output.requestSignUp.send(false)
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
                        let model = try result.map(APIResponse<UserToken>.self)
                        
                        var status: SignIn = .error
                        if model.status == .success {
                            status = .success
                        } else if let code = model.code {
                            status = SignIn(rawValue: code) ?? .error
                        } else {
                            status = .error
                        }
                        
                        switch status {
                        case .success:
                            guard let token = model.data else { throw APIError.decoding }
                            
                            UserDefaults.standard.set(user.toDictionary, forKey: UserService.USER_INFO_KEY)
                            UserDefaults.standard.synchronize()
                            
                            UserDefaults.standard.set("Bearer \(token.authorization ?? "")",
                                                      forKey: UserService.ACCESS_TOKEN_KEY)
                            UserDefaults.standard.synchronize()
                            
                            self?.output.requestSignIn.send(.success)
                        case .register:
                            UserDefaults.standard.set(user.toDictionary, forKey: UserService.USER_INFO_KEY)
                            UserDefaults.standard.synchronize()
                            self?.output.requestSignIn.send(.register)
                        case .error:
                            self?.output.requestSignIn.send(.error)
                        }
                    } catch {
                        LogUtil.e(error.localizedDescription)
                        self?.output.requestSignIn.send(.error)
                    }
                case .failure:
                    self?.output.requestSignIn.send(.error)
                }
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
                            UserDefaults.standard.removeObject(forKey: UserService.USER_INFO_KEY)
                            UserDefaults.standard.synchronize()
                            
                            UserDefaults.standard.removeObject(forKey: UserService.ACCESS_TOKEN_KEY)
                            UserDefaults.standard.synchronize()
                            
                            self?.output.requestWithdrawal.send(true)
                        } else {
                            self?.output.requestWithdrawal.send(false)
                        }
                    } catch {
                        self?.output.requestWithdrawal.send(false)
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure:
                    self?.output.requestWithdrawal.send(false)
                }
            }
    }
    //MARK: 유저 정보 조회
    private func requestUser() {
        provider.request(.user) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    guard let model = try result.map(APIResponse<UserModel?>.self).data else {
                        self?.output.requestUser.send(nil)
                        throw APIError.decoding
                    }
                    self?.output.requestUser.send(model)
                } catch {
                    LogUtil.e(error.localizedDescription)
                    self?.output.requestUser.send(nil)
                }
            case .failure:
                self?.output.requestUser.send(nil)
            }
        }
    }
    //MARK: 찜한 글 조회
    private func requestHeart() {
        provider.request(.heart) { [weak self] response in
            switch response {
            case .success(let result):
                do {
                    guard let models = try result.map(APIResponse<[Feed]>.self).data else {
                        self?.output.requestHeart.send([])
                        throw APIError.decoding
                    }
                    self?.output.requestHeart.send(models)
                } catch {
                    LogUtil.e(error.localizedDescription)
                    self?.output.requestHeart.send([])
                }
            case .failure:
                self?.output.requestHeart.send([])
            }
        }
    }
    //MARK: 북마크
    private func requestBookmark(id: Int, status: String) {
        provider.request(.bookmark(id, status)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        let status = try result.map(APIResponse<[String: String]>.self).status
                        self?.output.requestBookmark.send(status == .success)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                        self?.output.requestBookmark.send(false)
                    }
                case .failure:
                    self?.output.requestBookmark.send(false)
                }
            }
    }
}
