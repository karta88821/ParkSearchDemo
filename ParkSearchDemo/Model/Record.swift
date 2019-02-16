//
//  Record.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/16.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import Contacts

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

class Record: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case area = "AREA"
        case name = "NAME"
        case address = "ADDRESS"
        case serviceTime = "SERVICETIME"
        case tw97X = "TW97X"
        case tw97Y = "TW97Y"
    }
    
    @NSManaged var area: String
    @NSManaged var name: String
    @NSManaged var address: String
    @NSManaged var serviceTime: String
    @NSManaged var tw97X: String
    @NSManaged var tw97Y: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
            let context = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Record", in: context) else {
            fatalError("Failed to decode Record")
        }

        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.area = try container.decode(String.self, forKey: .area)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.serviceTime = try container.decode(String.self, forKey: .serviceTime)
        self.tw97X = try container.decode(String.self, forKey: .tw97X)
        self.tw97Y = try container.decode(String.self, forKey: .tw97Y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(area, forKey: .area)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(serviceTime, forKey: .serviceTime)
        try container.encode(tw97X, forKey: .tw97X)
        try container.encode(tw97Y, forKey: .tw97Y)
    }
}

extension Record: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        let tw97XValue = Double(tw97X) ?? 0
        let tw97YValue = Double(tw97Y) ?? 0
        let WGS84 = TWD97Convert.toWGS84(x: tw97XValue, y: tw97YValue)
        return CLLocationCoordinate2D(latitude: WGS84.lat, longitude: WGS84.lng)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return "營業時間：" + serviceTime
    }
    
    func mapItem() -> MKMapItem {
        let nameDict = [CNPostalAddressStreetKey: name]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nameDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

extension Record {
    var cellDisplayedWithTitle: [Item] {
        return [Item(title: "停車場名稱", content: name),
                Item(title: "區域", content: area),
                Item(title: "營業時間", content: serviceTime),
                Item(title: "地址", content: address)]
    }
}
