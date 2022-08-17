//
//  SurveyItemModel.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 18..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import Foundation

class SurveyItemModel: NSObject, NSCoding {
    
    var uuid: String!
    var name: String!
    var lat: Double!
    var lng: Double!
    var address: String!
    var phone: String!
    var mobile: String!
    var rtNo: Int!
    var finishedInvestigatorDate: Date!
    var photoCount: Int!
    
    override init() {
        super.init()
    }
    
    init(fromDictionary dictionary: [String: Any]) {
        uuid = dictionary["uuid"] as? String
        name = dictionary["name"] as? String
        lat = dictionary["lat"] as? Double
        lng = dictionary["lng"] as? Double
        address = dictionary["address"] as? String
        phone = dictionary["phone"] as? String
        mobile = dictionary["mobile"] as? String
        rtNo = dictionary["rtNo"] as? Int
        finishedInvestigatorDate = dictionary["finishedInvestigatorDate"] as? Date
        photoCount = dictionary["photoCount"] as? Int
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if uuid != nil {
            dictionary["uuid"] = uuid
        }
        if name != nil {
            dictionary["name"] = name
        }
        if lat != nil {
            dictionary["lat"] = lat
        }
        if lng != nil {
            dictionary["lng"] = lng
        }
        if address != nil {
            dictionary["address"] = address
        }
        if phone != nil {
            dictionary["phone"] = phone
        }
        if mobile != nil {
            dictionary["mobile"] = mobile
        }
        if rtNo != nil {
            dictionary["rtNo"] = rtNo
        }
        if finishedInvestigatorDate != nil {
            dictionary["finishedInvestigatorDate"] = finishedInvestigatorDate
        }
        if photoCount != nil {
            dictionary["photoCount"] = photoCount
        }
        
        return dictionary
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? Double
        lng = aDecoder.decodeObject(forKey: "lng") as? Double
        address = aDecoder.decodeObject(forKey: "address") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        rtNo = aDecoder.decodeObject(forKey: "rtNo") as? Int
        finishedInvestigatorDate = aDecoder.decodeObject(forKey: "finishedInvestigatorDate") as? Date
        photoCount = aDecoder.decodeObject(forKey: "photoCount") as? Int
    }
    
    @objc func encode(with aCoder: NSCoder) {
        if uuid != nil {
            aCoder.encode(uuid, forKey: "uuid")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if lat != nil {
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil {
            aCoder.encode(lng, forKey: "lng")
        }
        if address != nil {
            aCoder.encode(address, forKey: "address")
        }
        if phone != nil {
            aCoder.encode(phone, forKey: "phone")
        }
        if mobile != nil {
            aCoder.encode(mobile, forKey: "mobile")
        }
        if rtNo != nil {
            aCoder.encode(rtNo, forKey: "rtNo")
        }
        if finishedInvestigatorDate != nil {
            aCoder.encode(finishedInvestigatorDate, forKey: "finishedInvestigatorDate")
        }
        if photoCount != nil {
            aCoder.encode(photoCount, forKey: "photoCount")
        }
    }
    
    static func == (lhs: SurveyItemModel, rhs: SurveyItemModel) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.name == rhs.name && lhs.lat == rhs.lat && lhs.lng == rhs.lng && lhs.address == rhs.address && lhs.phone == rhs.phone && lhs.mobile == rhs.mobile && lhs.rtNo == rhs.rtNo && lhs.finishedInvestigatorDate == rhs.finishedInvestigatorDate && lhs.photoCount == rhs.photoCount
    }
    
}
