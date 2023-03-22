//
//  ImageCollectionViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import Foundation

struct ImageAsset: Decodable {
    let url: String?
}

final class ImageCollectionViewModel {
    private var viewModel = UserViewModel()
    @Published var data: [ImageAsset] = []
    var selectedImage: String = ""
    
    init() {
        bind()
    }
    
    private func bind() {
        viewModel
            .output
            .requestProfileImage
            .sink { [weak self] images in
                self?.data = images.map { ImageAsset(url: $0.url) }
            }
            .store(in: &viewModel.bag)
        
        viewModel.input.request.send(.profileImage)
    }
}
