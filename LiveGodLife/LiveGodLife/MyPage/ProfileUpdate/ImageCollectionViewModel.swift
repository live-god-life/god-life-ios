//
//  ImageCollectionViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import Foundation

struct ImageAsset {
    let name: String
}

struct ImageCollectionViewModel {

    var data: [ImageAsset] = []
    var selectedImage: String = ""
}
