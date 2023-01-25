//
//  TaskInfoViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/31.
//

import Foundation

struct TaskInfoViewModel {
    let title: String
    let period: String
    let repetition: String
    let notification: String

    init(data: TaskViewModel) {
        title = data.title
        self.period = "\(data.startDate) ~ \(data.endDate)"
        switch data.repetitionType {
        case .day:
            repetition = "매일"
        case .week:
            var value = "매주"
            data.repetitionParams.forEach {
                value.append($0)
            }
            repetition = value
        case .month:
            var value = ""
            data.repetitionParams.forEach {
                value.append("\($0)일")
            }
            repetition = value
        case .none:
            repetition = "없음"
        }
        notification = "매일 오전 9시" // TODO: - 0900
    }
}
