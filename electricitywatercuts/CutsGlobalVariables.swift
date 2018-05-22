//
//  CutsDelegate.swift
//  electricitywatercuts
//
//  Created by nils on 21.05.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation

class CutsGlobalVariables {
    // These are the properties you can store in your singleton
    var refreshAfterSettingChange: Bool = false
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: CutsGlobalVariables {
        struct Static {
            static let instance = CutsGlobalVariables()
        }
        return Static.instance
    }
}
