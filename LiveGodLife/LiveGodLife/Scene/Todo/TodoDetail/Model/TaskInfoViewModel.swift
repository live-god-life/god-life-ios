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
    let completedCount: Int?
    let totalCount: Int?

    init(data: TaskViewModel) {
        title = data.title
        self.period = "\(data.startDate.yyyyMMdd?.yyMd ?? "") ~ \(data.endDate.yyyyMMdd?.yyMd ?? "")"
        switch data.repetitionType {
        case .day:
            repetition = "매일 "
        case .week:
            var value = "매주 "
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
        notification = data.notification.HHmm2?.ahmm ?? ""
        self.completedCount = data.completedCount
        self.totalCount = data.totalCount
    }
}
