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
    
    // weak var delegate: CutsDelegate?
    
    // Column Names
    enum CutsRecord: Int {
        case _id = 0
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
    // private var db: OpaquePointer?
    // private var insertStmt: OpaquePointer?
    
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
        CUTS_DATABASE_INSERT.append(" (" + String(describing: CutsRecord.operator_name))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.start_date))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.end_date))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.reason))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.location))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.detail))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.type))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.search_text))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.order_start_date))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.order_end_date))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.insert_date))
        CUTS_DATABASE_INSERT.append(", " + String(describing: CutsRecord.is_current))
        CUTS_DATABASE_INSERT.append(") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);")
    }
    
    /*
    func createDatabase() {
        dbFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(CutsConstants.DATABASE_NAME)
    }
    */
    
    func openDatabase() -> OpaquePointer? {
        // opening the database
        var db: OpaquePointer? = nil
        if sqlite3_open(dbFileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        return db
    }
    
    func createTable() {
        let db = openDatabase()
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, CUTS_DATABASE_CREATE, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) != SQLITE_DONE {
                print("error creating table")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
        
        /*
        if sqlite3_exec(db, CUTS_DATABASE_CREATE, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
         */
    }
    
    func insert(cutsList: [Cuts]) {
        let db = openDatabase()
        //preparing the query
        var insertStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, CUTS_DATABASE_INSERT, -1, &insertStatement, nil) != SQLITE_OK {
            print("INSERT statement could not be prepared.")
            return
        }
        
        let locale: Locale = Locale(identifier: "tr-TR")
        let formatter: DateFormatter = DateFormatter()
        let dateFormat = DateFormatter.dateFormat(fromTemplate: CutsConstants.ddMMyyyyHHmmss, options: 0, locale: Locale(identifier: "tr-TR"))
        formatter.dateFormat = dateFormat
        formatter.locale = locale
        
        for cut in cutsList {
            // If the cut is new, insert it into the provider.
            var existingCuts : [Cuts]
            // Construct a where clause to make sure we don't already have this cut in the provider.
            if !((cut.detail?.isEmpty)!) {
                existingCuts = query(condition: CutsQueryCondition.SEARCH, value: cut.detail!, sort: "")
                if !existingCuts.isEmpty {
                    // set previously inserted but still current cuts is_current = 'T', update as "current"
                    let value = String(describing: CutsProvider.CutsRecord.is_current) + "='T' "
                    update(condition: CutsProvider.CutsQueryCondition.CUTS_ID, value: value, conditionArgs: String(existingCuts[0].id ?? 0))
                    continue
                }
            }
            
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.operator_name.rawValue), (cut.operatorName ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.start_date.rawValue), (cut.startDate ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.end_date.rawValue), (cut.endDate ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.location.rawValue), (cut.location ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.reason.rawValue), (cut.reason ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.detail.rawValue), (cut.detail ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.type.rawValue), (cut.type ?? ""), -1, nil)
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.search_text.rawValue), cut.getSearchString(), -1, nil)

            /* var searchText = (cut.operatorName ?? "")
            searchText.append(" " + (cut.location ?? ""))
            searchText.append(" " + (cut.reason ?? ""))
            bind(order: CutsRecord.search_text.rawValue, value: searchText) */
            
            let orderStartDate = CutsHelper.formatDate(dateStr: (cut.startDate ?? ""),
                                                       inputFormat: CutsConstants.ddMMyyyyHHmm, outputFormat: CutsConstants.yyyyMMddHHmmss);
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.order_start_date.rawValue), orderStartDate, -1, nil)

            let orderEndDate = CutsHelper.formatDate(dateStr: (cut.endDate ?? ""),
                                                        inputFormat:CutsConstants.ddMMyyyyHHmm, outputFormat: CutsConstants.yyyyMMddHHmmss);
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.order_end_date.rawValue), orderEndDate, -1, nil)

            let insertDate = formatter.string(from: Date())
            sqlite3_bind_text(insertStatement, Int32(CutsRecord.insert_date.rawValue), insertDate, -1, nil)

            sqlite3_bind_text(insertStatement, Int32(CutsRecord.is_current.rawValue), "T", -1, nil)
            
            //executing the query to insert values
            if sqlite3_step(insertStatement) != SQLITE_DONE {
                print("failure inserting cuts")
                return
            }
            sqlite3_reset(insertStatement)
        }
        sqlite3_finalize(insertStatement)
    }
    
    /*
    private func bind(order: Int, value: String) {
        //binding the parameters
        if sqlite3_bind_text(insertStmt, Int32(order), value, -1, nil) != SQLITE_OK{
            print("failure binding")
            return
        }
    }
 */
    
    func query(condition: CutsQueryCondition, value: String, sort: String) -> [Cuts] {
        let db = openDatabase()
        var cutsList = [Cuts]()
        
        var queryStatementString = "SELECT * FROM " + CutsConstants.CUTS_TABLE
        switch condition {
            case CutsQueryCondition.CUTS_ID:
                queryStatementString.append(" WHERE " + String(describing: CutsRecord._id) + "=" + value)
            case CutsQueryCondition.SEARCH:
                queryStatementString.append(" WHERE " + String(describing: CutsRecord.detail) + " LIKE '%" + value + "%'")
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
        queryStatementString.append(" ORDER BY " + orderBy)
        
        
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) != SQLITE_OK {
            print("error preparing insert")
            return cutsList
        }
        
        while(sqlite3_step(queryStatement) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(queryStatement, Int32(CutsRecord._id.rawValue)))
            let operatorName = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.operator_name.rawValue)))
            let startDate = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.start_date.rawValue)))
            let endDate = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.end_date.rawValue)))
            let location = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.location.rawValue)))
            let reason = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.reason.rawValue)))
            let detail = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.detail.rawValue)))
            let type = String(cString: sqlite3_column_text(queryStatement, Int32(CutsRecord.type.rawValue)))
            
            cutsList.append(Cuts.init(id: id, operatorName: operatorName, startDate: startDate, endDate: endDate, location: location, reason: reason, detail: detail, type: type))
        }
        
        sqlite3_finalize(queryStatement)
        return cutsList
    }
    
    func delete(condition: CutsQueryCondition, conditionArgs: String) -> Int {
        let db = openDatabase()
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
        let db = openDatabase()
        var updateStatementString = "UPDATE " + CutsConstants.CUTS_TABLE + " SET "
        
        if !value.isEmpty {
            updateStatementString.append(value);
        }
        
        switch condition {
            case CutsQueryCondition.CUTS_ID:
                updateStatementString.append(" WHERE " + String(describing: CutsRecord._id) + "=" + conditionArgs)
            case CutsQueryCondition.SEARCH: //TODO: NilS
                updateStatementString.append(" WHERE " + conditionArgs)
            default:
                return -1
        }
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) != SQLITE_OK {
            print("error preparing update")
            return -1
        }
        
        if sqlite3_step(updateStatement) != SQLITE_DONE {
            print("failure updating cuts")
            return -1
        }
        
        sqlite3_finalize(updateStatement)
        return 0
    }
    
    func upgradeTable() {
        let db = openDatabase()
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
