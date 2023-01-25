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
    var completedList = [Int: Bool]()
    private(set) var deatilModel: DetailGoalModel?
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        //Month
        input
            .requestMonth
            .sink { [weak self] dateString in
                self?.requestMonth(dateString: dateString)
            }
            .store(in: &bag)
        //Day
        input
            .requestDay
            .sink { [weak self] dateString in
                self?.requestDay(dateString: dateString)
            }
            .store(in: &bag)
        //Status
        input
            .requestStatus
            .sink { [weak self] id, status in
                self?.requestStatus(id: id, status: status)
            }
            .store(in: &bag)
        //Goals
        input
            .requestGoals
            .sink { [weak self] status in
                self?.requestGoals(completionStatus: status)
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
        //DetailGoals
        input
            .requestDetailGoal
            .sink { [weak self] id in
                self?.requestDetailGoals(id: id)
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
        var requestMonth = PassthroughSubject<String, Never>()
        var requestDay = PassthroughSubject<String, Never>()
        var requestStatus = PassthroughSubject<(Int, Bool), Never>()
        var requestGoals = PassthroughSubject<Bool?, Never>()
        var requestMindsets = PassthroughSubject<Int?, Never>()
        var requestDetailGoal = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var requestMonth = PassthroughSubject<[DayModel], Never>()
        var requestDay = PassthroughSubject<[MainCalendarModel], Never>()
        var requestGoals = PassthroughSubject<[GoalModel], Never>()
        var requestMindsets = PassthroughSubject<[MindSetsModel], Never>()
        var requestDetailGoal = PassthroughSubject<Void?, Never>()
    }
}

//MARK: - Method
extension TodoListViewModel {
    //MARK: MyList(캘린더) 달력 조회
    func requestMonth(dateString: String) {
        let parameters: [String: Any] = [
            "date": dateString
        ]
        
        NetworkManager.shared.provider
            .request(.month(parameters)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[DayModel]>.self).data else {
                            throw APIError.decoding
                        }
                        self?.output.requestMonth.send(model)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: MyList(캘린더/특정일의TODO리스트) 조회
    func requestDay(dateString: String) {
        let parameters: [String: Any] = [
            "date": dateString,
            "page": 0,
            "size": 100
        ]
        
        NetworkManager.shared.provider
            .request(.day(parameters)) { [weak self] response in
                switch response {
                case .success(let result):
                    do {
                        guard let model = try result.map(APIResponse<[MainCalendarModel]>.self).data else {
                            throw APIError.decoding
                        }
                        self?.output.requestDay.send(model)
                    } catch {
                        LogUtil.e(error.localizedDescription)
                    }
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: TODO 완료체크
    func requestStatus(id: Int, status: Bool) {
        let parameters: [String: Any] = [
            "completionStatus": status
        ]
        
        NetworkManager.shared.provider
            .request(.status(id, parameters)) { response in
                switch response {
                case .success:
                    LogUtil.e("TODO 완료체크")
                case .failure(let err):
                    LogUtil.e(err.localizedDescription)
                }
            }
    }
    //MARK: MyList(마인드셋) 조회
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
    //MARK: MyList(목표) 조회
    func requestGoals(completionStatus: Bool? = nil) {
        var parameters: [String: Any] = [
            "date": Date().toString(),
            "size": 100
        ]
        
        if let completionStatus {
            parameters.updateValue(completionStatus, forKey: "completionStatus")
        }
        
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
    //MARK: MyList(목표) 상세 조회
    private func requestDetailGoals(id: Int) {
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
