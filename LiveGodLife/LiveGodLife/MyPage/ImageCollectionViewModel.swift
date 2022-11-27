//
//  ImageCollectionViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import Foundation

struct ImageCollectionViewModel {

    struct ImageAsset {
        let name: String
    }

    let data: [ImageAsset] = [ImageAsset(name: "frog"),
                              ImageAsset(name: "frog"),
                              ImageAsset(name: "frog"),
                              ImageAsset(name: "frog"),
                              ImageAsset(name: "frog"),
                              ImageAsset(name: "frog"),
    ]
}
