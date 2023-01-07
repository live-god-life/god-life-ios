//
//  TodoListViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import Moya
import UIKit
import Combine

//MARK: TodoListViewModel
final class TodoListViewModel {
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
        //Goals
        input
            .requestGoals
            .sink { [weak self] size in
                guard let size else {
                    self?.requestGoals()
                    return
                }
                self?.requestGoals(size: size)
            }
            .store(in: &bag)
        //Mindsets
        input
            .requestMindsets
            .sink { [weak self] size in
                guard let size else {
                    self?.requestMindsets()
                    return
                }
                self?.requestMindsets(size: size)
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension TodoListViewModel {
    enum Section {
        case main
    }
    
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestGoals = PassthroughSubject<Int?, Never>()
        var requestMindsets = PassthroughSubject<Int?, Never>()
    }
    
    struct Output {
        var requestGoals = PassthroughSubject<[GoalModel], Never>()
        var requestMindsets = PassthroughSubject<[MindSetsModel], Never>()
    }
}

//MARK: - Method
extension TodoListViewModel {
    func requestMindsets(size: Int = 100) {
        let parameters: [String: Any] = [
            "date": Date().toString(),
            "size": size,
            "completionStatus": "false",
        ]
        
        NetworkManager.shared.provider
            .request(.mindsets(parameters)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[MindSetsModel]>.self).data else {
                            throw APIError.decoding
                        }
                        self?.output.requestMindsets.send(model)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    
    func requestGoals(size: Int = 100) {
        let parameters: [String: Any] = [
            "date": Date().toString(),
            "size": size,
            "completionStatus": "false",
        ]
        
        NetworkManager.shared.provider
            .request(.goals(parameters)) { [weak self] response in
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
