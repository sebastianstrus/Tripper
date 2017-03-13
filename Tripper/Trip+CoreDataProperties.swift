//
//  Trip+CoreDataProperties.swift
//  Tripper
//
//  Created by Sebastian Strus on 2017-03-11.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip");
    }

    @NSManaged public var title: String?
    @NSManaged public var journeyTime: String?
    @NSManaged public var image: NSData?
    @NSManaged public var tripDescription: String?
    @NSManaged public var expense: String?
    @NSManaged public var placeLatitude: Double
    @NSManaged public var placeLongitude: Double

}
