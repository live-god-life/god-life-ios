//
//  GoalsListViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import Moya
import UIKit
import Combine

//MARK: GoalsListViewModel
final class GoalsListViewModel {
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
extension GoalsListViewModel {
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
extension GoalsListViewModel {
    func request(size: Int = 100) {
        let parameter: [String: Any] = [
            "date": Date().toString(),
            "size": size,
            "completionStatus": "false",
        ] as [String : Any]
        
        NetworkManager.shared.provider
//            .requestPublisher(<#T##Target#>, callbackQueue: <#T##DispatchQueue?#>)
            
//            .request(.goals(parameter)) { response in
//                switch response {
//                case .success(let result):
//                    do {
//                        let json = try
//                        let jsonData = json as? [String:Any] ?? [:]
//                        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData["data"] as Any, options: .prettyPrinted),
//                           let model = try? JSONDecoder().decode([GoalModel].self, from: jsonData) {
//                            print(model)
//                        }
//                    } catch(let err) {
//                        print(err.localizedDescription)
//                    }
//                case .failure(let err):
//                    print(err.localizedDescription)
//                }
//            }
    }
}
