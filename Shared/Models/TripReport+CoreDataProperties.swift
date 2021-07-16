//
//  TripReport+CoreDataProperties.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/15/21.
//
//

import Foundation
import CoreData


extension TripReport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripReport> {
        return NSFetchRequest<TripReport>(entityName: "TripReport")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?

}

extension TripReport : Identifiable {

}

extension TripReport {
    var previewData: PreviewData {
        return PreviewData(title: name!,
                        subtitle: nil,
                        badgeBackgroundColor: nil,
                        badgeText: nil,
                        badgeImageUrl: imageUrl)
    }
}
