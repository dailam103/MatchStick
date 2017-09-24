//
//  Profile.swift
//  MatchStick Go
//
//  Created by NGUYỄN QUỐC ĐẠI LÂM on 2017/07/29.
//  Copyright © 2017 NGUYỄN QUỐC ĐẠI LÂM. All rights reserved.
//

import Foundation

public class Profile{
    public var facebookid = ""
    public var name = ""
    public var highscore: Int = 0
    public var email = ""
    public func reset(){
        self.facebookid = ""
        self.name = ""
        self.highscore = 0
        self.email = ""
    }
    init(){
    
    }
    init(facebookid : String, name : String, highscore : Int, email : String){
        self.facebookid = facebookid
        self.name = name
        self.highscore = highscore
        self.email = email
    }
    public func ToJSON() -> String{
        var a = "{\"facebookid\":\"" + self.facebookid + "\""
        a = a + ", \"name\":\"" + self.name + "\""
        a = a + ", \"highscore\":\"" + String(self.highscore) + "\""
        a = a + ", \"email\":\"" + self.email + "\"}"
        return a
    }
}
