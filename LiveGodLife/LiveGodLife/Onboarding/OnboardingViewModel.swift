//
//  OnboardingViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/09.
//

import Foundation

struct OnboardingViewModel: OnboardingViewModelType {

    let title: String
    let subtitle: String
    let description: String
    let buttonTitle: String
    var actionHandler: (() -> Void)? = nil
}
