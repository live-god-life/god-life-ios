//
//  GoalsViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import Moya
import UIKit
import Combine

//MARK: GoalsListViewModel
final class GoalsViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input
            .requestGoals
            .sink { [weak self] size in
                guard let size else {
                    self?.request()
                    return
                }
                self?.request(size: size)
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension GoalsViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestGoals = PassthroughSubject<Int?, Never>()
    }
    
    struct Output {
        var requestGoals = PassthroughSubject<[GoalModel], Never>()
    }
}

//MARK: - Method
extension GoalsViewModel {
    func request(size: Int = 100) {
        let parameter: [String: Any] = [
            "date": Date().toString(),
            "size": size,
            "completionStatus": "false",
        ]
        
        NetworkManager.shared.provider
            .request(.goals(parameter)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[GoalModel]>.self).data else {
                            throw APIError.decoding
                        }
                        self?.output.requestGoals.send(model)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
}
