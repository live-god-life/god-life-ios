//
//  DetailViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/26.
//

import UIKit
import Combine

//MARK: DetailGoalViewModel
final class DetailViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    private(set) var deatilModel: DetailGoalModel?
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input
            .requestDetailGoal
            .sink { [weak self] id in
                self?.requestDetailGoals(id: id)
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension DetailViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestDetailGoal = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var requestDetailGoal = PassthroughSubject<Void?, Never>()
    }
}

//MARK: - Method
extension DetailViewModel {
    func requestDetailGoals(id: Int) {
        NetworkManager.shared.provider
            .request(.deatilGoals(id)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<DetailGoalModel>.self).data else {
                            throw APIError.decoding
                        }
                        self?.deatilModel = model
                        self?.output.requestDetailGoal.send(nil)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
}
