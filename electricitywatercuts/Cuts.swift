//
//  Cuts.swift
//  electricitywatercuts
//
//  Created by nils on 24.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation

class Cuts {
    var operatorName: String?
    var startDate: String?
    var endDate: String?
    var location: String?
    var reason: String?
    var detail: String?
    var type: String?
    
    init(operatorName: String = "", startDate: String = "", endDate: String = "", location: String = "", reason: String = "", detail: String = "", type: String = "") {
        self.operatorName = operatorName
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.reason = reason
        self.detail = detail
        self.type = type
    }
    
    func toString() -> String {
        var description: String = self.operatorName ?? "" + "\n"
        description.append(self.startDate ?? "" + " - ")
        description.append(self.endDate ?? "" + "\n")
        description.append(self.location ?? "")
        
        return description
    }
    
    func getDetailedText (operatorTitle: String, startEndDateTitle: String, locationTitle: String, reasonTitle: String) -> String {
        var detailedText: String = "<b>" + operatorTitle + "</b> "
        detailedText.append(self.operatorName ?? "" + "<br />")
        detailedText.append("<b>" + startEndDateTitle + "</b> ")
        detailedText.append((self.startDate ?? "") + " - ")
        detailedText.append((self.endDate ?? "") + "<br />")
        detailedText.append("<b>" + locationTitle + "</b> ")
        detailedText.append((self.location ?? "") + "<br />")
        detailedText.append("<b>" + reasonTitle + "</b> " + (self.reason ?? ""))
        
        return detailedText
    }
    
    func getPlainText() -> String {
        let language = "tr"
        var plainText:String = CutsHelper.localizedText(language: language, key: "water_cut_label")
        if ("e" == type) {
            plainText = CutsHelper.localizedText(language: language, key: "electricity_cut_label")
        }
    
        plainText.append(" > " + CutsHelper.localizedText(language: language, key: "operator_title") + " ")
        plainText.append((self.operatorName ?? "") + ", ")
        plainText.append(CutsHelper.localizedText(language: language, key: "start_end_date_title") + " " + (self.startDate ?? ""))
        plainText.append(" - " + (self.endDate ?? "") + ", ")
        plainText.append(CutsHelper.localizedText(language: language, key: "location_title") + " " + (self.location ?? "") + ", ")
        plainText.append(CutsHelper.localizedText(language: language, key: "reason_title") + " " + (self.reason ?? ""))
        
        return plainText;
    }
    
}



