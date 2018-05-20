//
//  CutsHelper.swift
//  electricitywatercuts
//
//  Created by nils on 25.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation

class CutsHelper {
    
    static func convertToTurkishChars(str: String) -> String {
        var ret: String = str;
        for i in 0..<CutsConstants.turkishChars.count {
            ret = ret.replacingOccurrences(of: String(CutsConstants.englishChars[i]),
                                           with: String(CutsConstants.turkishChars[i]))
        }
        return ret;
    }
    
    static func convertContentToTurkish(context: String) -> String {
        var convertedContext: String = context;
        convertedContext = convertedContext.replacingOccurrences(of: "&#304;", with: "İ");
        convertedContext = convertedContext.replacingOccurrences(of: "&#305;", with: "ı");
        convertedContext = convertedContext.replacingOccurrences(of: "&#214;", with: "Ö");
        convertedContext = convertedContext.replacingOccurrences(of: "&#246;", with: "ö");
        convertedContext = convertedContext.replacingOccurrences(of: "&#220;", with: "Ü");
        convertedContext = convertedContext.replacingOccurrences(of: "&#252;", with: "ü");
        convertedContext = convertedContext.replacingOccurrences(of: "&#199;", with: "Ç");
        convertedContext = convertedContext.replacingOccurrences(of: "&#231;", with: "ç");
        convertedContext = convertedContext.replacingOccurrences(of: "&#286;", with: "Ğ");
        convertedContext = convertedContext.replacingOccurrences(of: "&#287;", with: "ğ");
        convertedContext = convertedContext.replacingOccurrences(of: "&#350;", with: "Ş");
        convertedContext = convertedContext.replacingOccurrences(of: "&#351;", with: "ş");
        return convertedContext;
    }
    
    static func compareCutsStr(str1: String, str2: String) -> Bool {
        let lowerCaseStr1: String = str1.lowercased(with: Locale(identifier: "tr-TR"))
        let lowerCaseStr2: String = str2.lowercased(with: Locale(identifier: "tr-TR"))
    
        let normalizedStr1: String = lowerCaseStr1.folding(options: .diacriticInsensitive, locale: Locale(identifier: "tr-TR"))
        let normalizedStr2: String = lowerCaseStr2.folding(options: .diacriticInsensitive, locale: Locale(identifier: "tr-TR"))
    
        if (normalizedStr1.lowercased().range(of: normalizedStr2.lowercased()) != nil) {
            return true;
        }
        return false;
    }
    
    static func formatDate(dateStr: String, inputFormat: String, outputFormat: String) -> String {
        let locale: Locale = Locale(identifier: "tr-TR")
        let formatter: DateFormatter = DateFormatter()
        let inputDateFormat = DateFormatter.dateFormat(fromTemplate: inputFormat, options: 0, locale: Locale(identifier: "tr-TR"))
        formatter.dateFormat = inputDateFormat
        formatter.locale = locale
        if let formattedTime = formatter.date(from: dateStr) {
            let outputFormat = DateFormatter.dateFormat(fromTemplate: outputFormat, options: 0, locale: Locale(identifier: "tr-TR"))
            formatter.dateFormat = outputFormat
            return formatter.string(from: formattedTime)
        }
        return dateStr
    }
    
    static func formatDateForDatabaseInsert(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = CutsConstants.ddMMyyyyHHmm
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = CutsConstants.yyyyMMddTHHmmssZ
            return dateFormatter.string(from: date)
        }
        return dateStr
    }
    
    static func localizedText(language: String, key: String) ->String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        let localizedText = bundle?.localizedString(forKey: key, value: nil, table: nil)
        
        return localizedText ?? key
    }
    
    static func getLocaleForApp() -> String {
        return UserDefaults.standard.string(forKey: CutsConstants.SETTING_LANG) ?? "tr"
    }
    
    static func getSelectedRangeChoice() -> String {
        return UserDefaults.standard.string(forKey: CutsConstants.SETTING_RANGE) ?? "0"
    }
    
    static func getSelectedOrderCriteriaChoice() -> String {
        return UserDefaults.standard.string(forKey: CutsConstants.SETTING_ORDER_CRITERIA) ?? "end"
    }
    
    static func getSelectedOrderChoice() -> String {
        return UserDefaults.standard.string(forKey: CutsConstants.SETTING_ORDER) ?? "desc"
    }
    
    static func getSelectedFrequencyChoice() -> String {
        return UserDefaults.standard.string(forKey: CutsConstants.SETTING_FREQ) ?? "1"
    }
    
    static func getSavedSearchString() -> String {
        return UserDefaults.standard.string(forKey: CutsConstants.SETTING_SEARCH_STR_OPTION) ?? ""
    }
}
