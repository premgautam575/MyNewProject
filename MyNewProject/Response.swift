//
//  Response.swift
//  MyNewProject
//
//  Created by prem  on 13/09/23.
//

import Foundation


struct Response:Codable{
    var data : [ResponseData]?
    
}


struct ResponseData: Codable{
    var id : Int?
    var status : String?
    var user_created : String?
    var date_created : String?
    var user_updated : String?
    var date_updated : String?
    var name : String?
    var artist : String?
    var accent : String?
    var cover : String?
    var top_track :Bool?
    var url : String?
   
    
}
