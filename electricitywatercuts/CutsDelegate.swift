//
//  CutsDelegate.swift
//  electricitywatercuts
//
//  Created by nils on 28.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation

protocol CutsDelegate: class {
    
    func didReceiveRefreshCuts(notificationFlag: Bool)
    func createTable()
}
