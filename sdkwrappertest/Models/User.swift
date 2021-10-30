//
//  User.swift
//  sdkwrappertest
//
//  Created by Ruben Mimoun on 16/10/2021.
//

import Foundation
import FirebaseWrapperSPM


struct User : FirebaseCodable{
    var age : Int
    var name : String
    var city : String
    var food : String
    var gender : String
    var date : String
    var pets : [Pet]?
    //var lastUpdated : String?
}
