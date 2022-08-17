//
//  DataSource.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import Foundation

class NDataSource: NSObject {

    var surveyModel: SurveyItemModel = SurveyItemModel()
    var markerModels: Array<NMarkerModel> = Array<NMarkerModel>()
    
    override init() {
        super.init()
    }
    
    init(_ model: SurveyItemModel) {
        surveyModel = model
        
        super.init()
    }
    
    func refreshPositions(_ array: Array<NMarkerModel>) {
        markerModels.removeAll()
        
        for i in 0..<array.count {
            let markerModel: NMarkerModel = NMarkerModel.init(array[i].surveyModel)
            markerModels.append(markerModel)
        }
    }

}
