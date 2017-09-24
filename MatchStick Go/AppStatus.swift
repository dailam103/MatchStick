//
//  AppStatuc.swift
//  MatchStick Go
//
//  Created by NGUYỄN QUỐC ĐẠI LÂM on 2017/08/01.
//  Copyright © 2017 NGUYỄN QUỐC ĐẠI LÂM. All rights reserved.
//

import Foundation
public class AppStatus{
    public static var isLoadName:Bool = false
    public static var isLoadHighScore:Bool = false
    public static var isLoadAvatar:Bool = false
    public static var isLoadFriendList:Bool = false
//    public static var isLoad
//    public static var isLoad
//    public static var isLoad
//    public static var isLoad
//    public static var isLoad
//    public static var isLoad
    public static func reset(){
        isLoadName = false
        isLoadHighScore = false
        isLoadAvatar = false
        isLoadFriendList = false
    }
    public static func checkAll() -> Bool{
        print("Load name       ->" + statusString(p: isLoadName))
        print("Load high score ->" + statusString(p: isLoadHighScore))
        print("Load avatar     ->" + statusString(p: isLoadAvatar))
        print("Load friend list->" + statusString(p: isLoadFriendList))
        return isLoadName && isLoadFriendList && isLoadAvatar && isLoadFriendList
    }
    static func statusString(p:Bool)->String{
        return p ? "OK" : "NOT"
    }
}
