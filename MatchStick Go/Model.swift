//
//  Model.swift
//  Match-Que diêm
//
//  Created by NGUYỄN QUỐC ĐẠI LÂM on 2017/07/17.
//  Copyright © 2017 NGUYỄN QUỐC ĐẠI LÂM. All rights reserved.
//

import Foundation

//hàm minus1 trả về số sau khi trừ đi 1 que
func minus1(x:Int)->Int{
    switch x {
    case 0:
        return -1
    case 1:
        return -1
    case 2:
        return -1
    case 3:
        return -1
    case 4:
        return -1
    case 5:
        return -1
    case 6:
        return 5
    case 7:
        return 1
    case 8:
        let  b:Int = Int(arc4random_uniform(3))
        switch(b){
        case 0: return 0
        case 1: return 6
        default: return 9
        }
    default:
        let b:Bool = Int(arc4random_uniform(2)) == 0
        if(b){
            return 3
        }
        else{
            return 5
        }
    }
}
//hàm minus2 khi trừ đi 2 que diêm thì có thể cho ta được số gì
func minus2(x:Int)->Int{
    switch x {
    case 0:
        return -1 //00
    case 1:
        return -1 //00
    case 2:
        return -1//00
    case 3:
        return 7
    case 4:
        return 1
    case 5:
        return -1//00
    case 6:
        return -1
    case 7:
        return -1
    case 8:
        let  b:Int = Int(arc4random_uniform(3))
        switch(b){
        case 0: return 3
        case 1: return 5
        default: return 2
        }
    default:
        return 4
    }
}
//hàm plus khi công thêm 1 que diêm thì có thể cho ta được số gì
func plus1(x:Int)->Int{
    switch x {
    case 0:
        return 8
    case 1:
        return 7
    case 2:
        return -1
    case 3:
        return 9
    case 4:
        return -1
    case 5:
        let b:Bool = Int(arc4random_uniform(2)) == 0
        if(b){
            return 6
        }else{
            return 9
        }
    case 6:
        return 8
    case 7:
        return -1
    case 8:
        return -1
    default:
        return 8
    }
}
func random_operator()->Bool{
    return arc4random_uniform(2) == 0
}

func optimize_plus1(x:Int)->Int{
    switch x {
    case 0:
        return 8
    case 1:
        return 7
    case 2:
        return -1
    case 3:
        return 9
    case 4:
        return -1
    case 5:
        let b:Bool = Int(arc4random_uniform(2)) == 0
        if(b){
            return 6
        }else{
            return 9
        }
    case 6:
        return 8
    case 7:
        return -1
    case 8:
        return -1
    default:
        return 8
    }
}

