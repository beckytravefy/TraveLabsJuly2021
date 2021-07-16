//
//  TripTempModel.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/16/21.
//

import Foundation
import SwiftUI

class TripReportTemp: Codable, Equatable, Identifiable, ObservableObject {
    init(id: Int64, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }

    enum TripReportCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageUrl = "imageUrl"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TripReportCodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TripReportCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageUrl, forKey: .imageUrl)
    }

    static func == (lhs: TripReportTemp, rhs: TripReportTemp) -> Bool {
        lhs.id == rhs.id
    }

    @Published var id: Int64
    @Published var name: String
    @Published var imageUrl: String
}

extension TripReportTemp {
    var previewData: PreviewData {
        return PreviewData(title: name,
                        subtitle: nil,
                        badgeBackgroundColor: nil,
                        badgeText: nil,
                        badgeImageUrl: imageUrl)
    }
}

