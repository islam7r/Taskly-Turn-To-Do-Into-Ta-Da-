//
//  UserInfo.swift
//  Taskly
//
//  Created by Islam Rzayev on 08.12.24.
//

import Foundation
import SwiftUI


struct UserInfo: Codable{
    let id: String
    let name: String
    let email: String
   
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
}

extension UserInfo{
    static var mockUser = UserInfo(id: NSUUID().uuidString, name: "Islam Rzayev", email: "islamrzayev1124@gmail.com")
}
