//
//  YoutubeSearchModel.swift
//  cinematiq
//
//  Created by Юрий on 01.08.2023.
//

import UIKit

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementId
}

struct VideoElementId: Codable {
    let kind:  String
    let videoId: String
}

