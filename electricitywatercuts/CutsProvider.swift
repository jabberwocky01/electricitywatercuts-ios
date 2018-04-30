//
//  CutsProvider.swift
//  electricitywatercuts
//
//  Created by nils on 30.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation
import SQLite3

class CutsProvider {
    
    weak var delegate: CutsDelegate?
    
    // Column Names
    enum CutsRecord: Int {
        case _id = 1
        case operator_name
        case start_date
        case end_date
        case location
        case reason
        case detail
        case type
        case search_text
        case order_start_date
        case order_end_date
        case insert_date
        case is_current
    }
    
    // Table Query Conditions
    enum CutsQueryCondition {
        case CUTS_ID
        case SEARCH
    }
    
    private var dbFileURL: URL
    private var db: OpaquePointer?
    private var insertStmt: OpaquePointer?
    
    private var CUTS_DATABASE_CREATE: String
    private var CUTS_DATABASE_INSERT: String
    
    init() {
        CUTS_DATABASE_CREATE = "CREATE TABLE IF NOT EXISTS "
        CUTS_DATABASE_CREATE.append(CutsConstants.CUTS_TABLE + " (")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord._id) + " INTEGER PRIMARY KEY AUTOINCREMENT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.operator_name) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.start_date) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.end_date) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.location) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.reason) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.detail) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.type) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.search_text) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.order_start_date) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.order_end_date) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.insert_date) + " TEXT, ")
        CUTS_DATABASE_CREATE.append(String(describing: CutsRecord.is_current) + " TEXT);")
        
        dbFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(CutsConstants.DATABASE_NAME)
        
        CUTS_DATABASE_INSERT  = "INSERT INTO " + CutsConstants.CUTS_TABLE
        CUTS_DATABASE_CREATE.append(" (" + String(describing: CutsRecord.operator_name))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.start_date))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.end_date))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.reason))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.location))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.detail))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.type))
        CUTS_DATABASE_CREATE.append(", "  + String(describing: CutsRecord.search_text))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.order_start_date))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.order_end_date))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.insert_date))
        CUTS_DATABASE_CREATE.append(", " + String(describing: CutsRecord.is_current))
        CUTS_DATABASE_CREATE.append(") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);")
    }
    
    /*
    func createDatabase() {
        dbFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(CutsConstants.DATABASE_NAME)
    }
    */
    
    func createTable() {
        // opening the database
        if sqlite3_open(dbFileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return
        }
        
        if sqlite3_exec(db, CUTS_DATABASE_CREATE, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return
        }
        
        sqlite3_finalize(db)
        
        delegate?.createTable()
    }
    
    func insert(cutsList: [Cuts]) {
        //preparing the query
        if sqlite3_prepare(db, CUTS_DATABASE_INSERT, -1, &insertStmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        let locale: Locale = Locale(identifier: "tr-TR")
        let formatter: DateFormatter = DateFormatter()
        let dateFormat = DateFormatter.dateFormat(fromTemplate: CutsConstants.ddMMyyyyHHmmss, options: 0, locale: Locale(identifier: "tr-TR"))
        formatter.dateFormat = dateFormat
        formatter.locale = locale
        
        for cut in cutsList {
            bind(order: CutsRecord.operator_name.rawValue, value: (cut.operatorName ?? ""))
            bind(order: CutsRecord.start_date.rawValue, value: (cut.startDate ?? ""))
            bind(order: CutsRecord.end_date.rawValue, value: (cut.endDate ?? ""))
            bind(order: CutsRecord.location.rawValue, value: (cut.location ?? ""))
            bind(order: CutsRecord.reason.rawValue, value: (cut.reason ?? ""))
            bind(order: CutsRecord.detail.rawValue, value: (cut.detail ?? ""))
            bind(order: CutsRecord.type.rawValue, value: (cut.type ?? ""))
            var searchText = (cut.operatorName ?? "")
            searchText.append(" " + (cut.location ?? ""))
            searchText.append(" " + (cut.reason ?? ""))
            bind(order: CutsRecord.search_text.rawValue, value: searchText)
            let orderStartDate = CutsHelper.formatDate(dateStr: (cut.startDate ?? ""),
                                                       inputFormat: CutsConstants.ddMMyyyyHHmm, outputFormat: CutsConstants.yyyyMMddHHmmss);
            bind(order: CutsRecord.order_start_date.rawValue, value: orderStartDate)
            let orderEndDate = CutsHelper.formatDate(dateStr: (cut.endDate ?? ""),
                                                        inputFormat:CutsConstants.ddMMyyyyHHmm, outputFormat: CutsConstants.yyyyMMddHHmmss);
            bind(order: CutsRecord.order_end_date.rawValue, value: orderEndDate)
            let insertDate = formatter.string(from: Date())
            bind(order: CutsRecord.insert_date.rawValue, value: insertDate)
            bind(order: CutsRecord.is_current.rawValue, value: "T")
        }
        
        //executing the query to insert values
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting cuts: \(errmsg)")
            return
        }
        
        sqlite3_finalize(insertStmt)
    }
    
    private func bind(order: Int, value: String) {
        //binding the parameters
        if sqlite3_bind_text(insertStmt, Int32(order), value, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding: \(errmsg)")
            return
        }
    }
    
    func query(condition: CutsQueryCondition, value: String, sort: String) -> [Cuts]{
        var cutsList = [Cuts]()
        
        var queryStmtString = "SELECT * FROM " + CutsConstants.CUTS_TABLE
        switch condition {
            case CutsQueryCondition.CUTS_ID:
                queryStmtString.append(CutsConstants.KEY_ID + "=" + value)
            case CutsQueryCondition.SEARCH:
                queryStmtString.append(CutsConstants.KEY_DETAIL + " LIKE \"%" + value + "%\"")
            default:
                return cutsList
            
        }
        
        // If no sort order is specified, sort by date / time
        var orderBy: String
        if sort.isEmpty {
            orderBy = String(describing: CutsRecord.order_end_date);
        } else {
            orderBy = sort;
        }
        queryStmtString.append(" ORDER BY" + orderBy)
        
        var queryStmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryStmtString, -1, &queryStmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return cutsList
        }
        
        while(sqlite3_step(queryStmt) == SQLITE_ROW){
            let operatorName = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.operator_name.rawValue)))
            let startDate = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.start_date.rawValue)))
            let endDate = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.end_date.rawValue)))
            let location = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.location.rawValue)))
            let reason = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.reason.rawValue)))
            let detail = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.detail.rawValue)))
            let type = String(cString: sqlite3_column_text(queryStmt, Int32(CutsRecord.type.rawValue)))
            
            cutsList.append(Cuts.init(operatorName: operatorName, startDate: startDate, endDate: endDate, location: location, reason: reason, detail: detail, type: type))
        }
        
        sqlite3_finalize(queryStmt)
        return cutsList
    }
    
    func delete(condition: CutsQueryCondition, conditionArgs: String) -> Int {
        var deleteStmtString = "DELETE FROM " + CutsConstants.CUTS_TABLE + " WHERE "
        
        switch condition {
            case CutsQueryCondition.CUTS_ID:
                deleteStmtString.append(CutsConstants.KEY_ID + "=" + conditionArgs)
            case CutsQueryCondition.SEARCH: //TODO: NilS
                deleteStmtString.append(conditionArgs)
            default:
                return -1
        }
        
        var deleteStmt: OpaquePointer?
        
        if sqlite3_prepare(db, deleteStmtString, -1, &deleteStmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: \(errmsg)")
            return -1
        }
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting cuts: \(errmsg)")
            return -1
        }
        
        sqlite3_finalize(deleteStmt)
        return 0
    }
    
    func update(condition: CutsQueryCondition, value: String, conditionArgs: String) -> Int {
        var updateStmtString = "UPDATE " + CutsConstants.CUTS_TABLE + " SET "
        
        if value.isEmpty {
            updateStmtString.append(value);
        }
        
        switch condition {
            case CutsQueryCondition.CUTS_ID:
                updateStmtString.append(" WHERE" + CutsConstants.KEY_ID + "=" + conditionArgs)
            case CutsQueryCondition.SEARCH: //TODO: NilS
                updateStmtString.append(" WHERE" + conditionArgs)
            default:
                return -1
        }
        
        
        var updateStmt: OpaquePointer?
        
        if sqlite3_prepare(db, updateStmtString, -1, &updateStmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
            return -1
        }
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating cuts: \(errmsg)")
            return -1
        }
        
        sqlite3_finalize(updateStmt)
        return 0
    }
    
    func upgradeTable() {
        let upgradeStmtString = "DROP TABLE IF EXISTS " + CutsConstants.CUTS_TABLE
        
        var upgradeStmt: OpaquePointer?
        
        if sqlite3_prepare(db, upgradeStmtString, -1, &upgradeStmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing upgrade: \(errmsg)")
        }
        
        if sqlite3_step(upgradeStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure upgrading db: \(errmsg)")
        }
        
        sqlite3_finalize(upgradeStmt)
        createTable()
    }
    
}
