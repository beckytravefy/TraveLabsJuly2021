//
//  Contact+CoreDataProperties.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/12/21.
//
//

import Foundation
import CoreData
import SwiftUI

extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var colorData: Data?
    @NSManaged public var contactDescription: String?
    @NSManaged public var contactId: Int64
    @NSManaged public var name: String?
    @NSManaged public var contactAttributes: NSSet?

    var wrappedName: String {
        get {
            name ?? "No Name"
        }
        set {
            name = newValue
        }
    }

    var wrappedDescription: String {
        get {
            contactDescription ?? ""
        }
        set {
            contactDescription = newValue
        }
    }

    var attributes: [ContactAttribute] {
        let set = contactAttributes as? Set<ContactAttribute> ?? []
        return set.sorted {
            $0.contactAttributeId < $1.contactAttributeId
        }
    }

    var primaryEmail: String? {
        let attribute = attributes.first { attribute in
            attribute.wrappedType == .email
        }
        return attribute?.value
    }

    var primaryPhone: String? {
        let attribute = attributes.first { attribute in
            attribute.wrappedType == .phone
        }
        return attribute?.value
    }

    private struct ColorData: Codable {
        var r: Double
        var g: Double
        var b: Double
        var a: Double
    }

    var color: Color {
        get {
            guard let data = colorData, let decoded = try? JSONDecoder().decode(ColorData.self, from: data) else { return .black }
            return Color(.sRGB, red: decoded.r, green: decoded.g, blue: decoded.b, opacity: decoded.a)
        }
        set(newColor) {
            #if os(iOS)
            let nativeColor = UIColor(newColor)
            #elseif os(macOS)
            let nativeColor = NSColor(newColor)
            #endif

            var (r, g, b, a) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
            nativeColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            if let encoded = try? JSONEncoder().encode(ColorData(r: Double(r), g: Double(g), b: Double(b), a: Double(a))) {
                colorData = encoded
            }
        }
    }
}

// MARK: Generated accessors for contactAttributes
extension Contact {

    @objc(addContactAttributesObject:)
    @NSManaged public func addToContactAttributes(_ value: ContactAttribute)

    @objc(removeContactAttributesObject:)
    @NSManaged public func removeFromContactAttributes(_ value: ContactAttribute)

    @objc(addContactAttributes:)
    @NSManaged public func addToContactAttributes(_ values: NSSet)

    @objc(removeContactAttributes:)
    @NSManaged public func removeFromContactAttributes(_ values: NSSet)

}

extension Contact : Identifiable {

}

extension Contact {
    var previewData: PreviewData {
        return PreviewData(title: wrappedName,
                        subtitle: primaryEmail ?? primaryPhone ?? "",
                        badgeBackgroundColor: color,
                        badgeText: wrappedName.initials(),
                        badgeImageUrl: nil)
    }
}

