//
//  CutsUpdateService.swift
//  electricitywatercuts
//
//  Created by nils on 25.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation
import SwiftSoup

class CutsUpdateService {
    
    weak var delegate: CutsDelegate?
    
    var cutsForNotification: [Cuts]?
    
    init() {
        self.cutsForNotification = [Cuts]()
    }
    
    func refreshCuts(notificationFlag: Bool) {
        let urls: [String] = CutsConstants.CUTS_LINK_LIST
        
        // updateCutsAsPrevious();
        
        var cutsList = [Cuts]()
        for i in 0..<urls.count {
            var temp = [Cuts]()
            if (urls[i].range(of: "bedas") != nil) {
                temp = getEuropeElectricityData(link: urls[i])
            } else if (urls[i].range(of: "ayedas") != nil) {
                // temp = getAnatoliaElectricityData(urls[i]);
            } else if (urls[i].range(of: "iski") != nil) {
                // temp = getWaterData(urls[i]);
            }
            
            for j in 0..<temp.count {
                cutsList.append(temp[j])
            }
        }
    
        // addNewCuts(cutsList);
        
        if (notificationFlag) {
            // Trigger a notification.
            // broadcastNotification();
        }
        
        cutsForNotification = cutsList
        
        delegate?.didReceiveRefreshCuts(notificationFlag: notificationFlag)
        
        // return cutsList
    
    }

    func getEuropeElectricityData(link: String) -> [Cuts] {
        var electricalCuts = [Cuts]()
        
        let locale: Locale = Locale(identifier: "tr-TR")
        let formatter: DateFormatter = DateFormatter()
        let paramDateFormat = DateFormatter.dateFormat(fromTemplate: CutsConstants.yyyyMMdd, options: 0, locale: Locale(identifier: "tr-TR"))
        formatter.dateFormat = paramDateFormat
        formatter.locale = locale
        
        let cutDateFormat = DateFormatter.dateFormat(fromTemplate: CutsConstants.ddMMyyyy, options: 0, locale: Locale(identifier: "tr-TR"))
        
        var types = [String]() 
        types.append(CutsConstants.BEDAS_CUT_TYPE_PLANNED)
        types.append(CutsConstants.BEDAS_CUT_TYPE_INSTANTANEOUS)
        
        var date = Date()
        // look up for 5 days
        for _ in 0..<5 {
            for type in types {
                let formattedDate = formatter.string(from: date)
                let formattedUrl : String = String(format: link, "0", type, formattedDate)
                let url = URL(string: formattedUrl)
                
                do {
                    let htmlContent = try String(contentsOf: url!, encoding: .utf8)
                    
                    //do{
                        let jsonData = htmlContent.data(using: .utf8)! as Data
                        do {
                            let dataJson = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                            let resultArray = dataJson as? [[String:Any]]
                            for eCut in resultArray! {
                                let location = eCut["metin"] as? String
                                let startHour = eCut["saat1"] as? String
                                let endHour = eCut["saat2"] as? String
                                let reason = eCut["nedeni"] as? String
                                
                                let cut = Cuts()
                                cut.type = CutsConstants.CUT_TYPE_ELECTRICITY
                                cut.location = location
                                
                                formatter.dateFormat = cutDateFormat
                                let formattedDate = formatter.string(from: date)
                                
                                let cutStartDate: String = formattedDate + " " + (startHour ?? "")
                                cut.startDate = cutStartDate
                                
                                let cutEndDate: String = formattedDate + " " + (endHour ?? "")
                                cut.endDate = cutEndDate
                                
                                cut.reason = reason
                                cut.location = location
                                
                                var operatorName = String()
                                if let range = location?.range(of: "\\((.*?)İlçesi\\)", options: .regularExpression) {
                                    operatorName = String(location![range])
                                    if let index = operatorName.range(of: " İlçesi") {
                                        operatorName = String(operatorName[..<index.lowerBound])
                                        if let index = operatorName.range(of: "(") {
                                            operatorName = String(operatorName[index.upperBound...])
                                        }
                                    }
                                } else {
                                    if let index = location?.range(of: "İlçesi") {
                                        operatorName = String(location![..<index.lowerBound])
                                    }
                                }
                                cut.operatorName = operatorName
                                
                                cut.detail = (cut.operatorName ?? "") + " "
                                cut.detail?.append((cut.startDate ?? "") + "-")
                                cut.detail?.append((cut.endDate ?? "") + " ")
                                cut.detail?.append((cut.location ?? "") + " ")
                                cut.detail?.append((cut.reason ?? ""))
                                
                                electricalCuts.append(cut)
                            }
                        } catch {
                            print("error getting xml string: \(error)")
                        }
                   /* } catch {
                        print("could not unwrap data object for html content")
                    } */


                } catch {
                    print("could not unwrap data object for html content")
                }
                
                date = NSCalendar.current.date(byAdding: .day, //Here you can add year, month, hour, etc.
                    value: 1,  //Here you can add number of units
                    to: date)!
            }
                
        }
        
        return electricalCuts
    }

    
}
