////
//  ViewController.swift
//  Match-Que diêm
//
//  Created by NGUYỄN QUỐC ĐẠI LÂM on 2017/06/07.
//  Copyright © 2017 NGUYỄN QUỐC ĐẠI LÂM. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookShare
import FacebookCore
import FacebookLogin

class ViewController: UIViewController, FBSDKSharingDelegate {

    //các que diêm và group của nó
    @IBOutlet weak var a6: UIButton!
    @IBOutlet weak var a5: UIButton!
    @IBOutlet weak var a4: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a0: UIButton!
    var a:[UIButton] = [UIButton]()
    
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b0: UIButton!
    var b:[UIButton] = [UIButton]()
    
    @IBOutlet weak var c6: UIButton!
    @IBOutlet weak var c5: UIButton!
    @IBOutlet weak var c4: UIButton!
    @IBOutlet weak var c3: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c0: UIButton!
    var c:[UIButton] = [UIButton]()
    
    @IBOutlet weak var equal2: UIButton!
    @IBOutlet weak var equal1: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var btnreset: UIButton!
    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var lbltimer: UILabel!
    @IBOutlet weak var lblproblem: UILabel!
    @IBOutlet weak var lblscore: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnLoginFacebook: UIButton!
    
    @IBOutlet weak var avatarBoder: UIImageView!
    @IBOutlet weak var Avatar: UIButton!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblHighScore: UILabel!
    @IBOutlet weak var btnPlayBackground: UIImageView!
    
    @IBOutlet weak var headerBackground: UIImageView!
    let SERVER:String = "http://192.168.0.10/MatchStick-Go/"
    //screen size
    let SCREENSIZE: CGRect = UIScreen.main.bounds
    let MAX_TIME:Int = 100 * 30
    var time:Int = 0
    var isPlaying = false
    //var i:Int = 0
    var numa,numb,numc:[Bool]! //gia tri 1 neu tai do co xuat hien que diem
    var na,nb,nc:Int! //giá trị của 3 số a,b,c hiển thị
    var d:Bool = false //dấu hiển thị
    var d_c:Bool = false
    var selected:UIButton!
    public var answer:String?
    var num_move:Int = 0
    
    var selected_num:String!
    var selected_n:Int!
    var selected_value:Bool!
    
    var isAnswer_effect:Bool = false
    
    var buf:Int = 0
    
    var Score:Int = 0
    var timer:Timer!
    var outTime:Date = Date()
    var isGoOut = false
    var request_timeout = 0
    var sequen:Int = 0
    public static var logout = false
   
    //String variable
    let PROBLEM1:String = NSLocalizedString("problem1", comment: "")
    let PROBLEM2:String = NSLocalizedString("problem2", comment: "")
    let TIME:String = NSLocalizedString("time", comment: "")
    let MOVE:String = NSLocalizedString("move", comment: "")
    let HIGHSCORE:String = NSLocalizedString("highscore", comment: "")
    let SCORE:String = NSLocalizedString("score", comment: "")
    let MSG1:String = NSLocalizedString("msg1", comment: "")
    let ANSWER:String = NSLocalizedString("answer", comment: "")
    
    @IBOutlet weak var btnviewresult: UIButton!
    
    @IBOutlet weak var lblnummove: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealViewController = self.revealViewController()
        Avatar.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = CGFloat(Width(percent: 75))
        Init()
    }
        //ham khoi tao
    func Init(){
        //tạo mảng các que diêm của mỗi số
        self.a = [self.a0,self.a1,self.a2,self.a3,self.a4,self.a5,self.a6]
        self.b = [self.b0,self.b1,self.b2,self.b3,self.b4,self.b5,self.b6]
        self.c = [self.c0,self.c1,self.c2,self.c3,self.c4,self.c5,self.c6]
        selected = self.equal1
        time = self.MAX_TIME
        lblproblem.text = PROBLEM1
        lblnummove.text = MOVE + String(describing: num_move)
        lbltimer.text = TIME + String(time / 100) + "." + String((time % 100) / 10) + String(time % 10)
        let SC:String = Score > 9 ? "" : "0"
        lblscore.text =  SCORE + SC + String(Score)
        let HC:String = userInfo.highscore > 9 ? "" : "0"
        lblHighScore.text = HIGHSCORE + HC + String(describing: userInfo.highscore)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: update(timer:))
        if(FBSDKAccessToken.current() != nil){
            let DEFAULTS = UserDefaults.standard
            if let name = DEFAULTS.string(forKey: CacheKey.NAME) {
                userInfo.name = name
                //update app status
                AppStatus.isLoadName = true
            }
            if let fname = DEFAULTS.string(forKey: CacheKey.FIRST_NAME) {
                self.lblname.text = fname
                //update app status
                AppStatus.isLoadName = true
            }
            if let link = DEFAULTS.string(forKey: CacheKey.AVATAR_LINK) {
                Avatar.load_Data(link: link)
            }
            if let facebookid = DEFAULTS.string(forKey: CacheKey.FACEBOOK_ID) {
                userInfo.facebookid = facebookid
            }
            if let email = DEFAULTS.string(forKey: CacheKey.EMAIL) {
               userInfo.email = email
            }
            if let highscore = DEFAULTS.string(forKey: CacheKey.HIGH_SCORE) {
                userInfo.highscore = Int(highscore)!
                let HC = Int(highscore)! > 9 ? "" : "0"
                lblHighScore.text = HIGHSCORE + HC + highscore
            }
            getFriendList()
        }
        response_screen()
        showPlayButton()
        
        
    }
    //app go out, go in
    func app_out(){
        isGoOut = true
        outTime = Date()
    }
    func app_in(){
        if isGoOut == true {
            isGoOut = false
            let NOWTIME = Date()
            let D = NOWTIME.timeIntervalSince1970 - outTime.timeIntervalSince1970
            time -= Int(D * 100)
        }
        else{
            
        }
        
    }
    func set_matchstick_size(width:Int, height:Int, start_x:Int, start_y:Int){
        var match_width, match_height, match_width_h:Int
        let MARGIN_ROP:Int = start_y + 3 * height / 100
        let A_MARGIN_LEFT = start_x + 3 * width / 100
        let SPACE = 2 * width / 100
        match_width = 4 * width / 100
        match_height = 40 * height / 100
        match_width_h = 15 * width / 100
        let B_MARGIN_LEFT = A_MARGIN_LEFT + 2 * match_width + 2 * match_width_h + 2 * SPACE
        let C_MARGIN_LEFT = B_MARGIN_LEFT + 2 * match_width + 2 * match_width_h + 2 * SPACE
        
        minus.frame = CGRect(x: B_MARGIN_LEFT - SPACE - match_width_h, y: MARGIN_ROP + match_height - match_width/2, width: match_width_h , height: match_width)
        plus.frame = CGRect(x: B_MARGIN_LEFT - SPACE - match_width_h / 2 - match_width/2, y: MARGIN_ROP + match_height - match_width_h/2, width: match_width , height: match_width_h)
        equal1.frame = CGRect(x: C_MARGIN_LEFT - SPACE - match_width_h, y: MARGIN_ROP + match_height - match_width_h/2, width: match_width_h , height: match_width)
        equal2.frame = CGRect(x: C_MARGIN_LEFT - SPACE - match_width_h, y: MARGIN_ROP + match_height - match_width_h/2 + match_width_h - match_width, width: match_width_h , height: match_width)
        for i in 0...6{
            if(i == 2 || i == 5 || i == 6){
                var h:Int = match_width
                var l:Int = 2
                if i == 5{
                    h = 0
                    l = 0
                }
                
                if i == 6{
                    h = match_width / 2
                    l = 1
                }
                a[i].frame = CGRect(x: A_MARGIN_LEFT + match_width ,y: MARGIN_ROP + l * match_height - h, width: match_width_h , height: match_width)
                b[i].frame = CGRect(x: B_MARGIN_LEFT + match_width ,y: MARGIN_ROP + l * match_height - h, width: match_width_h , height: match_width)
                c[i].frame = CGRect(x: C_MARGIN_LEFT + match_width ,y: MARGIN_ROP + l * match_height - h, width: match_width_h , height: match_width)
                
            }
            else{
                if(i == 3 || i == 4){
                    var l : Int = 4
                    if(i==3){
                        l = 5
                    }
                    a[i].frame = CGRect(x: A_MARGIN_LEFT + match_width_h + match_width  ,y: MARGIN_ROP + Int(l/5) * match_height, width: match_width, height: match_height)
                    b[i].frame = CGRect(x: B_MARGIN_LEFT + match_width_h + match_width  ,y: MARGIN_ROP + Int(l/5) * match_height, width: match_width, height: match_height)
                    c[i].frame = CGRect(x: C_MARGIN_LEFT + match_width_h + match_width  ,y: MARGIN_ROP + Int(l/5) * match_height, width: match_width, height: match_height)
                }
                else{
                    
                    a[i].frame = CGRect(x: A_MARGIN_LEFT ,y: MARGIN_ROP +  i * match_height , width: match_width, height: match_height)
                    b[i].frame = CGRect(x: B_MARGIN_LEFT ,y: MARGIN_ROP +  i * match_height , width: match_width, height: match_height)
                    c[i].frame = CGRect(x: C_MARGIN_LEFT ,y: MARGIN_ROP +  i * match_height , width: match_width, height: match_height)
                }
                
            }
            
        }
        
    }
    func backgroundAnimation(){
        sequen += 1
        let patten = sequen/9 % 24 + 1
        let im = UIImage(named: "Layer " + String(patten), in: Bundle(for: type(of: self)), compatibleWith: nil)!
        background.image = im
    }
    //ham xu ly game
    func update(timer:Timer){
        backgroundAnimation()
        if(ViewController.logout){
            lblname.text = "Guest"
            lblHighScore.text = HIGHSCORE + "00"
            response_screen()
            ViewController.logout = false
        }
        
        if(!isPlaying){
            return
        }
        if(!isAnswer_effect){
            lbltimer.text = TIME + String(time / 100) + "." + String((time % 100) / 10) + String(time % 10)
        }
        let sc:String = Score > 9 ? "" : "0"
        lblscore.text =  SCORE + sc + String(Score)
        if(time <= 0){
            //game over
            isPlaying = false
            gameOver()
        }else{
            time -= 1
            if(isAnswer_effect){
                if(time <= 0){
                    problem()
                    lblnummove.text = MOVE + String(check_num_move())
                    time = self.MAX_TIME
                    isAnswer_effect = false
                    let im = UIImage(named: "firework0" , in: Bundle(for: type(of: self)), compatibleWith: nil)!
                    image_view.image = im
                    buf = 0
                }
                else{
                    buf += 1
                    let patten = buf/9 % 22
                    let im = UIImage(named: "firework" + String(patten), in: Bundle(for: type(of: self)), compatibleWith: nil)!
                    image_view.image = im
                    
                }
            }
        }
        
        if(plus == selected && d){
            
            plus.backgroundColor=UIColor.orange
        }
        else{
            plus.backgroundColor = nil
        }
        for i:Int in 0...6{
            if(a[i]==selected){
                if(!numa[i]){
                    continue
                }
                a[i].backgroundColor=UIColor.orange
            }
            else{
                a[i].backgroundColor = nil
            }
            
            if(b[i]==selected){
                if(!numb[i]){
                    continue
                }
                b[i].backgroundColor=UIColor.orange
            }
            else{
                b[i].backgroundColor = nil
            }
            
            if(c[i]==selected){
                if(!numc[i]){
                    continue
                }
                c[i].backgroundColor=UIColor.orange
            }
            else{
                c[i].backgroundColor = nil
            }
        }
        set_a(n:na)
        set_b(n:nb)
        set_c(n:nc)
        set_operator(d1:d_c)
    }
    func gameOver(){
        lblproblem.text = ANSWER + answer!
        showPlayButton()
    }
    func showPlayButton(){
        if isPlaying {
            //hide
            btnPlay.frame = CGRect(x: -Width(percent: 50) , y: -Height(percent: 50) , width: 1, height: 1)
            btnPlayBackground.frame = CGRect(x: -Width(percent: 50) , y: -Height(percent: 50) , width: 1, height: 1)
        } else {
            let button_height:Int = Height(percent: 11)
            btnPlay.frame = CGRect(x: Width(percent: 50) -  button_height * 3 / 4, y: Height(percent: 50) - button_height / 2, width: button_height * 3 / 2, height: button_height)
            btnPlayBackground.frame = CGRect(x: 0, y: 0, width: Width(percent: 100), height: Height(percent: 100))
        }
        
        
    }
    //check answer
    func isanswer()->Bool{
        
        var i:Int = 0
        var A,B,C:Int!
        while i < 10{
            var AA:[Bool] = get_number(n: i)
            var j:Int = 0
            while( j < 7 ){
                if(AA[j] != numa[j]){
                    break
                }
                j += 1
            }
            if(j == 7){
                break
            }
            i += 1
        }
        if(i == 10){
            return false
        }
        A = i
        i = 0
        
        while i < 10{
            var BB:[Bool] = get_number(n: i)
            var j:Int = 0
            while( j < 7 ){
                if(BB[j] != numb[j]){
                    break
                }
                j += 1
            }
            if(j == 7){
                break
            }
            i += 1
        }
        if(i == 10){
            return false
        }
        B = i
        i = 0
        
        
        while i < 10{
            var CC:[Bool] = get_number(n: i)
            var j:Int = 0
            while( j < 7 ){
                if(CC[j] != numc[j]){
                    break
                }
                j += 1
            }
            if(j == 7){
                break
            }
            i += 1
        }
        if(i == 10){
            return false
        }
        C = i
        
        var dau:Int
        if(d_c) {
            dau = 1
        }else{
            dau = -1
        }
        if(C == A + dau * B){
            return true
        }
        else{
            return false
        }
    }
    func Width(percent: Int)->Int{
        let width = Int(SCREENSIZE.width)
        return percent * width / 100
    }
    func Height(percent: Int)->Int{
        let height = Int(SCREENSIZE.height)
        return percent * height / 100
    }
    //set respon
    func response_screen(){
        let left:Int = 21 * Width(percent: 100) / 1024 + Width(percent: 1)
        let down:Int = 36 * Height(percent: 100)/1366 + Width(percent: 1)
        let avatarSize:Int = Height(percent: 13)
        
        background.frame = CGRect(x: 0, y: 0, width: Width(percent: 100) , height: Height(percent: 100))
        headerBackground.frame = CGRect(x: 0, y: -Height(percent: 17), width: Width(percent: 100) , height: Height(percent: 17) * 2 + down)
        image_view.frame = CGRect(x: 0, y: Height(percent: 0), width: Width(percent: 100), height: Height(percent: 100))
        var b = Width(percent: 100) - avatarSize - (2 * left)
        lblproblem.frame = CGRect(x: avatarSize + left , y: down , width: b, height: Height(percent: 5))
        
        let tab = Width(percent: 20)
        b = Width(percent: 97) - (2 * left) - avatarSize - tab
        var maxcount:Int = 16
        var sumcount:Int = 28
        let langid:String = Locale.current.languageCode!
        switch langid {
        case "ja":
            maxcount = 8
            sumcount = 15
            break
        case "vi":
            maxcount = 16
            sumcount = 28
            break
        default:
            maxcount = 14
            sumcount = 23
            break
        }
        let BASEWIDTH = maxcount * b / sumcount
        var count:Int = (lblHighScore.text?.characters.count)!
        lblHighScore.frame =   CGRect(x: avatarSize + tab + left, y: Height(percent: 5) + down, width: BASEWIDTH * count / maxcount , height: Height(percent: 5))
        
        count = (lblscore.text?.characters.count)!
        lblscore.frame =   CGRect(x: avatarSize + tab + left + Width(percent: 3) + maxcount * b / sumcount, y: Height(percent: 5) + down, width: BASEWIDTH * count / maxcount , height: Height(percent: 5))
        
        count = (lbltimer.text?.characters.count)!
        lbltimer.frame = CGRect(x: avatarSize + left + tab, y: Height(percent: 10) + down, width: BASEWIDTH * count / maxcount, height: Height(percent: 6))
        
        count = (lblnummove.text?.characters.count)!
        lblnummove.frame = CGRect(x: avatarSize + tab + left + Width(percent: 3) + maxcount * b / sumcount, y: Height(percent: 10) + down, width: BASEWIDTH * count / maxcount, height: Height(percent: 6))
        
        
        
 
        
        let c = (lblname.text?.characters.count)! + 1
        b = BASEWIDTH * c / 16
        if b > avatarSize {
            b = avatarSize
        } else {
            
        }
        lblname.frame = CGRect(x: left +  Int(avatarSize/2 - b / 2), y: Height(percent: 10) + down, width: b, height: Height(percent: 6))
        
        set_matchstick_size(width: Width(percent: 85), height: Height(percent: 40), start_x: Width(percent: 3), start_y: Height(percent: 21))
        
        
        
        let button_height:Int = Height(percent: 11)
        btnreset.frame = CGRect(x: Width(percent: 50) -  button_height * 3 / 4, y:  Height(percent: 67), width: button_height * 3 / 2, height: button_height)
        
        Avatar.frame = CGRect(x: left + Height(percent: 2), y: Height(percent: 2) + down, width: Height(percent: 9), height: Height(percent: 9))
        avatarBoder.frame = CGRect(x: left + Height(percent: 2) - Height(percent: 1) * 1 / 2 , y: down + Height(percent:2) - Height(percent: 1) * 1 / 2, width: Height(percent: 10), height: Height(percent: 10))
        
        //other
        lblproblem.adjustsFontSizeToFitWidth = true
        lblname.adjustsFontSizeToFitWidth = true
        lblnummove.adjustsFontSizeToFitWidth = true
        lbltimer.adjustsFontSizeToFitWidth = true
        lblscore.adjustsFontSizeToFitWidth = true
        lblHighScore.adjustsFontSizeToFitWidth = true
  
        btnLoginFacebook.layer.cornerRadius = 10
        btnLoginFacebook.clipsToBounds = true
        Avatar.layer.cornerRadius = CGFloat(Height(percent: 9)/2)
        Avatar.clipsToBounds = true
        avatarBoder.layer.cornerRadius = CGFloat(Height(percent: 10)/2)
        avatarBoder.clipsToBounds = true
        Logout_response()
        
    }
    
    func Logout_response(){
        let left:Int = 21 * Width(percent: 100) / 1024 + Width(percent: 1)
        let down:Int = 36 * Height(percent: 100)/1366 + Width(percent: 1)
        
        if FBSDKAccessToken.current() != nil {
            btnLoginFacebook.frame = CGRect(x: Width(percent: 102), y: Height(percent: 10), width: 4, height: Height(percent: 40))
        }
        else{
            btnLoginFacebook.frame = CGRect(x: left, y: Height(percent: 96) - down , width: Height(percent: 16), height: Height(percent: 4))
            Avatar.setBackgroundImage(#imageLiteral(resourceName: "avatardefault.jpg"), for: .normal)
            
        }
    }
        
    //Kiểm tra người chơi đã di chuyển bao nhiêu que rồi
    func check_num_move()->Int{
        var aa:[Bool] = get_number(n: na)
        var bb:[Bool] = get_number(n: nb)
        var cc:[Bool] = get_number(n: nc)
        var c:Int = 0
        for i:Int in 0...6 {
            if(aa[i] != numa[i]){
                c += 1
            }
            if(bb[i] != numb[i]){
                c += 1
            }
            if(cc[i] != numc[i]){
                c += 1
            }
        }
        return c / 2
    }
    //event touch
    @IBAction func touch_v(_ sender: UIButton) { //touch_viewresult
        if(isPlaying){
            
        }
        else{
            Facebook_share()
        }
    }

    @IBAction func touch_a0(_ sender: UIButton) {
        
        touch_common(btn: sender,num: "a", n: 0)
    }
    @IBAction func touch_a1(_ sender: UIButton) {
        touch_common(btn: sender,num: "a", n: 1)
    }
    @IBAction func touch_a2(_ sender: UIButton) {
        touch_common(btn: sender,num: "a", n: 2)
    }
    @IBAction func touch_a3(_ sender: UIButton) {
        touch_common(btn: sender,num: "a", n: 3)
    }
    @IBAction func touch_a4(_ sender: UIButton) {
        touch_common(btn: sender,num: "a", n: 4)
    }
    @IBAction func touch_a5(_ sender: UIButton) {
        touch_common(btn: sender,num: "a", n: 5)
    }
    @IBAction func touch_a6(_ sender: UIButton) {
        touch_common(btn: sender,num: "a", n: 6)
    }
    @IBAction func touch_b0(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 0)
    }
    @IBAction func touch_b1(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 1)
    }
    @IBAction func touch_b2(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 2)
    }
    @IBAction func touch_b3(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 3)
    }
    @IBAction func touch_b4(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 4)
    }
    @IBAction func touch_b5(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 5)
    }
    @IBAction func touch_b6(_ sender: UIButton) {
        touch_common(btn: sender,num: "b", n: 6)
    }
    @IBAction func touch_c0(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 0)
    }
    @IBAction func touch_c1(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 1)
    }
    @IBAction func touch_c2(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 2)
    }
    @IBAction func touch_c3(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 3)
    }
    @IBAction func touch_c4(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 4)
    }
    @IBAction func touch_c5(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 5)
    }
    @IBAction func touch_c6(_ sender: UIButton) {
        touch_common(btn: sender,num: "c", n: 6)
    }
    @IBAction func touch_equal1(_ sender: UIButton) {
        //touch_common(btn: sender,num: "e", n: 0)
    }
    @IBAction func touch_equal2(_ sender: UIButton) {
        //touch_common(btn: sender,num: "e", n: 1)
    }
    @IBAction func touch_minus(_ sender: UIButton) {
        //touch_common(btn: sender,num: "m", n: 0)
    }
    @IBAction func touch_plus(_ sender: UIButton) {
        touch_common(btn: sender,num: "p", n: 7)
    }
    @IBAction func touch_btnPlay(_ sender: UIButton) {
        problem()
        isPlaying = true
        //sender.isEnabled = false
        Score = 0
        time = self.MAX_TIME
        showPlayButton()
    }
    @IBAction func btnreset(_ sender: UIButton) {
        numc = get_number(n: nc)
        numa = get_number(n: na)
        numb = get_number(n: nb)
        set_a(n:na)
        set_b(n:nb)
        set_c(n:nc)
        d_c = d
        selected = equal2
    }
    //Facebook
    @IBAction func touch_btnLoginFacebook(_ sender: UIButton) {
        Login()
    }
    
    @IBAction func touch_btnAvatar(_ sender: UIButton) {
    }
  
    
    func GetScreenShot()->UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        //Save it to the camera roll
       // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func msgbox(message:String, title:String, button_value:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: button_value, style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func get_Button_value(num:String, n:Int)->Bool{
        switch num {
        case "a":
            return numa[n]
        case "b":
            return numb[n]
        case "c":
            return numc[n]
        case "p":
            return d_c
        default:
            return false
        }
    }
    //touch_common
    func touch_common(btn:UIButton, num:String, n:Int){
        if(!isPlaying){
            return
        }
        if(selected == minus || selected == equal1 || selected == equal2 || get_Button_value(num: num, n: n) || !get_Button_value(num: selected_num, n: selected_n)){
            selected = btn
            selected_n = n
            selected_num = num
            
        }
        else{
            //change matchstick
            set_value(array_name: num, i: n, value: true)
            set_value(array_name: selected_num, i: selected_n, value: false)
            //remove selected
            selected = equal2
            
            //check isanswer
            if(isanswer() && check_num_move() <= num_move){
                isAnswer_effect = true
                Score += 1
                time = 200
            }
            else{
                lblnummove.text = MOVE + String(check_num_move())
            }
        }
    }
    func set_value(array_name:String!, i:Int, value:Bool){
        switch array_name {
        case "a":
            numa[i] = value
            break
        case "b":
            numb[i] = value
            break
        case "c":
            numc[i] = value
            break
        case "p":
            d_c = !d_c
            break
        default:
            break
        }
    }
    func problem(){
        var randomNumber = arc4random()
        na = Int(randomNumber)%10
        randomNumber = arc4random()
        nb = Int(randomNumber)%10
        
        d = random_operator()
        if(d){
            if(na + nb > 9){
                nc = max(na,nb)
                nb = nc - na
            }
            else{
                nc = na + nb
            }
        }
        else{
            if(na>nb){
                
            }
            else{
                swap(&na,&nb)
            }
            nc = na - nb
        }
        //luu lai dap an 6 2 8
        var dau = "+"
        if(!d){
            dau = "-"
        }
        answer = "" + String(na) + " " + dau + " " + String(nb) + " = " + String(nc)
        //chon so lon nhat de tru 2 que
        num_move = 0
        //print(answer)
        if(minus2(x: nc) != -1 ){
            if(plus1(x: na) != -1 && plus1(x: nb) != -1){
                nc = minus2(x: nc)
                na = plus1(x:na)
                nb = plus1(x:nb)
                num_move = 2
            }else{//c-2
                if(plus2(x:na) != -1){//c-2 a+2
                    nc = minus2(x: nc)
                    na = plus2(x:na)
                    num_move = 2
                }else{
                    if(plus2(x: nb) != -1){
                        nc = minus2(x: nc)
                        nb = plus2(x:nb)
                        num_move = 2
                    }else{
                        //tao lai bai khac
                        problem()
                        return
                    }
                }
            }
        }
        else{
            if(minus2(x: na) != -1){
                if(plus1(x: nb) != -1 && plus1(x: nc) != -1){
                    na = minus2(x: na)
                    nc = plus1(x:nc)
                    nb = plus1(x:nb)
                    num_move = 2
                }else{
                    if(plus2(x:nb) != -1){
                        na = minus2(x: na)
                        nb = plus2(x:nb)
                        num_move = 2
                    }else{
                        if(plus2(x: nc) != -1){
                            na = minus2(x: na)
                            nc = plus2(x:nc)
                            num_move = 2
                        }else{
                            //tao lai bai khac
                            problem()
                            return
                        }
                    }
                }
            }else
            {
                if(minus2(x: nb) != -1){
                    if(plus1(x: na) != -1 && plus1(x: nc) != -1){
                        nb = minus2(x: nb)
                        nc = plus1(x:nc)
                        na = plus1(x:na)
                        num_move = 2
                    }else{
                        if(plus2(x:na) != -1){
                            nb = minus2(x: nb)
                            na = plus2(x:na)
                            num_move = 2
                        }else{
                            if(plus2(x: nc) != -1){
                                nb = minus2(x: nb)
                                nc = plus2(x:nc)
                                num_move = 2
                            }else{
                                //tao lai bai khac
                                problem()
                                return
                            }
                        }
                    }
                }else{
                    if(minus1(x: nc) != -1 && plus1(x:na) != -1 || minus1(x: nc) != -1 && plus1(x: nb) != -1){
                        if(plus1(x: na) != -1){//chua ngau nhien, can sua lai
                            nc = minus1(x: nc)
                            na = plus1(x: na)
                            num_move = 1
                        }else{
                            nc = minus1(x: nc)
                            nb = plus1(x: nb)
                            num_move = 1
                        }
                    }else{
                        if(minus1(x: na) != -1 && plus1(x:nc) != -1 || minus1(x: na) != -1 && plus1(x: nb) != -1){
                            if(plus1(x: nc) != -1){//chua ngau nhien, can sua lai
                                na = minus1(x: na)
                                nc = plus1(x: nc)
                                num_move = 1
                            }else{
                                na = minus1(x: na)
                                nb = plus1(x: nb)
                                num_move = 1
                            }
                        }else{
                            if(minus1(x: nb) != -1 && plus1(x:nc) != -1 || minus1(x: nb) != -1 && plus1(x: na) != -1){
                                if(plus1(x: nc) != -1){//chua ngau nhien, can sua lai
                                    nb = minus1(x: nb)
                                    nc = plus1(x: nc)
                                    num_move = 1
                                }else{
                                    nb = minus1(x: nb)
                                    na = plus1(x: na)
                                    num_move = 1
                                }
                            }else{
                                //tao lai bai khac
                                problem()
                                return
                            }
                        }
                    }
                }
            }
        }
        
        d_c = d
        numc = get_number(n: nc)
        numa = get_number(n: na)
        numb = get_number(n: nb)
        selected = equal2
        if(OptimizeMove()){
            num_move = 1
        }
        if num_move == 1{
            lblproblem.text = PROBLEM1
        } else {
            lblproblem.text = PROBLEM2
        }
        
        print(answer!)
    }
    //Nếu đề yêu cầu di chuyển 2 que, thì tối ưu xem di chuyển 1 que có giải quyết được không
    func OptimizeMove()->Bool{
        //Trường hợp trừ số a 1 que
        var dau:Int = -1
        var dauS:String = "-"
        if(d){
            dau = 1
            dauS = "+"
        }
        //check tru so a 1 que
        if(na > 5){
            var a = minus1(x: na)
            if(plus1(x: nb) != -1){
                var b,c:Int
                b = plus1(x: nb)
                c = nc
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
                if(nb == 5){
                    b = 6
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    b = 9
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                }
            }
            if(plus1(x: nc) != -1){
                var b,c:Int
                c = plus1(x: nc)
                b = nb
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
                if(nc == 5){
                    c = 6
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    c = 9
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                }
            }
            if(!d){
                if(a + nb == nc){
                    answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                    return true
                }
            }
            if(na == 8){
                a = 0
                if(plus1(x: nb) != -1){
                    var b,c:Int
                    b = plus1(x: nb)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var b,c:Int
                    c = plus1(x: nc)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(a + nb == nc){
                        answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
                
                a = 6
                if(plus1(x: nb) != -1){
                    var b,c:Int
                    b = plus1(x: nb)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var b,c:Int
                    c = plus1(x: nc)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(a + nb == nc){
                        answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
                
                a = 9
                if(plus1(x: nb) != -1){
                    var b,c:Int
                    b = plus1(x: nb)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var b,c:Int
                    c = plus1(x: nc)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(a + nb == nc){
                        answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
            }
            if(na == 9){
                a = 3
                if(plus1(x: nb) != -1){
                    var b,c:Int
                    b = plus1(x: nb)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var b,c:Int
                    c = plus1(x: nc)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(a + nb == nc){
                        answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
                
                a = 5
                if(plus1(x: nb) != -1){
                    var b,c:Int
                    b = plus1(x: nb)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var b,c:Int
                    c = plus1(x: nc)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(a + nb == nc){
                        answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
            }

        }
        /*if(minus1(x: na) != -1){
            let a = minus1(x: na)
            if(plus1(x: nb) != -1){
                var b,c:Int
                b = plus1(x: nb)
                c = nc
                if ( a + dau * b == c){
                     answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
            }
            if(plus1(x: nc) != -1){
                var b,c:Int
                c = plus1(x: nc)
                b = nb
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
            }
            if(!d){
                if(a + nb == nc){
                    answer = "" + String(a) + " + " + String(nb) + " = " + String(nc)
                    return true
                }
            }
        }*/
        
        //check tru so b 1 que
        if(nb > 5){
            var b = minus1(x: nb)
            if(plus1(x: na) != -1){
                var a,c:Int
                a = plus1(x: na)
                c = nc
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
                if(na == 5){
                    a = 6
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    a = 9
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                }
            }
            if(plus1(x: nc) != -1){
                var a,c:Int
                c = plus1(x: nc)
                a = na
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
                if(nc == 5){
                    c = 6
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    c = 9
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                }
            }
            if(!d){
                if(na + b == nc){
                    answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                    return true
                }
            }
            if(nb == 8){
                
                b = 0
                if(plus1(x: na) != -1){
                    var a,c:Int
                    a = plus1(x: na)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var a,c:Int
                    c = plus1(x: nc)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + b == nc){
                        answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                        return true
                    }
                }
                b = 6
                if(plus1(x: na) != -1){
                    var a,c:Int
                    a = plus1(x: na)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var a,c:Int
                    c = plus1(x: nc)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + b == nc){
                        answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                        return true
                    }
                }
                b = 9
                if(plus1(x: na) != -1){
                    var a,c:Int
                    a = plus1(x: na)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var a,c:Int
                    c = plus1(x: nc)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + b == nc){
                        answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                        return true
                    }
                }
            }
            if(nb == 9){
                b = 3
                if(plus1(x: na) != -1){
                    var a,c:Int
                    a = plus1(x: na)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var a,c:Int
                    c = plus1(x: nc)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + b == nc){
                        answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                        return true
                    }
                }
                b = 5
                if(plus1(x: na) != -1){
                    var a,c:Int
                    a = plus1(x: na)
                    c = nc
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: nc) != -1){
                    var a,c:Int
                    c = plus1(x: nc)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nc == 5){
                        c = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        c = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + b == nc){
                        answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                        return true
                    }
                }
            }
            
            
        }
        
        //check b - 1
        /*if(minus1(x: nb) != -1){
            let b = minus1(x: nb)
            if(plus1(x: na) != -1){
                var a,c:Int
                a = plus1(x: na)
                c = nc
               if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
            }
            if(plus1(x: nc) != -1){
                var a,c:Int
                c = plus1(x: nc)
                a = na
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
            }
            if(!d){
                 if(na + b == nc){
                    answer = "" + String(na) + " + " + String(b) + " = " + String(nc)
                    return true
                }
            }
        }*/
        
        
        if(nc > 5){
            var c = minus1(x: nc)
            if(plus1(x: nb) != -1){
                var b,a:Int
                b = plus1(x: nb)
                a = na
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
                if(nb == 5){
                    b = 6
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    b = 9
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                }
            }
            if(plus1(x: na) != -1){
                var b,a:Int
                a = plus1(x: na)
                b = nb
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
                if(na == 5){
                    a = 6
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    a = 9
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                }
            }
            if(!d){
                if(na + nb == c){
                    answer = "" + String(na) + " + " + String(nb) + " = " + String(c)
                    return true
                }
            }
            if(nc == 8){
                c = 0
                if(plus1(x: nb) != -1){
                    var b,a:Int
                    b = plus1(x: nb)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: na) != -1){
                    var b,a:Int
                    a = plus1(x: na)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + nb == c){
                        answer = "" + String(na) + " + " + String(nb) + " = " + String(c)
                        return true
                    }
                }
                c = 6
                if(plus1(x: nb) != -1){
                    var b,a:Int
                    b = plus1(x: nb)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: na) != -1){
                    var b,a:Int
                    a = plus1(x: na)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + nb == c){
                        answer = "" + String(na) + " + " + String(nb) + " = " + String(c)
                        return true
                    }
                }
                c = 9
                if(plus1(x: nb) != -1){
                    var b,a:Int
                    b = plus1(x: nb)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: na) != -1){
                    var b,a:Int
                    a = plus1(x: na)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + nb == c){
                        answer = "" + String(na) + " + " + String(nb) + " = " + String(c)
                        return true
                    }
                }
            }
            if(nc == 9){
                c = 3
                if(plus1(x: nb) != -1){
                    var b,a:Int
                    b = plus1(x: nb)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: na) != -1){
                    var b,a:Int
                    a = plus1(x: na)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + nb == c){
                        answer = "" + String(na) + " + " + String(nb) + " = " + String(c)
                        return true
                    }
                }
                c = 5
                if(plus1(x: nb) != -1){
                    var b,a:Int
                    b = plus1(x: nb)
                    a = na
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(nb == 5){
                        b = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        b = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(plus1(x: na) != -1){
                    var b,a:Int
                    a = plus1(x: na)
                    b = nb
                    if ( a + dau * b == c){
                        answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                        return true
                    }
                    if(na == 5){
                        a = 6
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                        a = 9
                        if ( a + dau * b == c){
                            answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                            return true
                        }
                    }
                }
                if(!d){
                    if(na + nb == c){
                        answer = "" + String(describing: a) + " + " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
            }
            
        }
        
        
        //check c - 1
        /*if(minus1(x: nc) != -1){
            let c = minus1(x: nc)
            if(plus1(x: nb) != -1){
                var a,b:Int
                b = plus1(x: nb)
                a = na
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
            }
            if(plus1(x: na) != -1){
                var a,b:Int
                a = plus1(x: na)
                b = nb
                if ( a + dau * b == c){
                    answer = "" + String(a) + " " + dauS + " " + String(b) + " = " + String(c)
                    return true
                }
            }
            if(!d){
                if(na + nb == c){
                    answer = "" + String(na) + " + " + String(nb) + " = " + String(c)
                    return true
                }
            }
        }*/
        
        if(d){
            //check a + 1
            if(plus1(x: na) != -1){
                var a:Int
                if(na == 5){
                    a = 6
                    if(a - nb == nc){
                        answer = "" + String(a) + " - " + String(nb) + " = " + String(nc)
                        return true
                    }
                    a = 9
                    if(a - nb == nc){
                        answer = "" + String(a) + " - " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
                else{
                    a = plus1(x: na)
                    if(a - nb == nc){
                        answer = "" + String(a) + " - " + String(nb) + " = " + String(nc)
                        return true
                    }
                }
                
            }
            if(plus1(x: nb) != -1){
                var b:Int
                if(na == 5){
                    b = 6
                    if(na - b == nc){
                        answer = "" + String(na) + " - " + String(b) + " = " + String(nc)
                        return true
                    }
                    b = 9
                    if(na - b == nc){
                        answer = "" + String(na) + " - " + String(b) + " = " + String(nc)
                        return true
                    }
                }
                else{
                    b = plus1(x: nb)
                    if(na - b == nc){
                        answer = "" + String(na) + " - " + String(b) + " = " + String(nc)
                        return true
                    }
                }
                
            }
            
            if(plus1(x: nc) != -1){
                var c:Int
                if(nc == 5){
                    c = 6
                    if(na - nb == c){
                        answer = "" + String(na) + " - " + String(nb) + " = " + String(c)
                        return true
                    }
                    c = 9
                    if(na - nb == c){
                        answer = "" + String(na) + " - " + String(nb) + " = " + String(c)
                        return true
                    }
                }
                else{
                    c = plus1(x: nc)
                    if(na - nb == c){
                        answer = "" + String(na) + " - " + String(nb) + " = " + String(c)
                        return true
                    }
                }
                
            }
        }
        //tu chuyen 1 que trong so
        //so a
        var ia,ib,ic:Int
        ic = nc
        ib = nb
        switch (na) {
        case 0:
            ia = 6
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ia = 9
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 1:
            break
        case 2:
            ia = 3
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
            
        case 3:
            ia = 2
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ia = 5
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
            
        case 4:
            break
        case 5:
            ia = 3
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 6:
            ia = 9
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ia = 0
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 7:
            break
        case 8:
            break
        case 9:
            ia = 6
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ia = 0
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        default: break
        }
        //so b
        ia = na
        ic = nc
        switch (nb) {
        case 0:
            ib = 6
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ib = 9
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 1:
            break
        case 2:
            ib = 3
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
            
        case 3:
            ib = 2
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ib = 5
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
            
        case 4:
            break
        case 5:
            ib = 3
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 6:
            ib = 9
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ib = 0
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 7:
            break
        case 8:
            break
        case 9:
            ib = 6
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ib = 0
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        default: break
        }
        //so c
        ia = na
        ib = nb
        switch (nc) {
        case 0:
            ic = 6
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ic = 9
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 1:
            break
        case 2:
            ic = 3
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
            
        case 3:
            ic = 2
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ic = 5
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
            
        case 4:
            break
        case 5:
            ic = 3
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 6:
            ic = 9
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ic = 0
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
        case 7:
            break
        case 8:
            break
        case 9:
            ic = 6
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            ic = 0
            if(ia + dau * ib == ic){
                answer = "" + String(ia) + " " + dauS + " " + String(ib) + " = " + String(ic)
                return true
            }
            break
         default: break
        }
        return false
    }
    //hàm plus2 khi công thêm 2 que diêm thì có thể cho ta được số gì
    func plus2(x:Int)->Int{
        switch x {
        case 0:
            return -1
        case 1:
            return -1
        case 2:
            return 8
        case 3:
            return 8
        case 4:
            return 9
        case 5:
            return 8
        case 6:
            return -1
        case 7:
            return 3
        case 8:
            return -1
        default:
            return -1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //hinh dang cua cac so tu 0 -> 9
    func get_number(n:Int)->[Bool]{
        var c:[Bool] = []
        switch n {
        case 0:
            c=[true,true,true,true,true,true,false]
            break
        case 1:
            c=[false,false,false,true,true,false,false]
            break
        case 2:
            c=[false,true,true,false,true,true,true]
            break
        case 3:
            c=[false,false,true,true,true,true,true]
            break
        case 4:
            c=[true,false,false,true,true,false,true]
            break
        case 5:
            c=[true,false,true,true,false,true,true]
            break
        case 6:
            c=[true,true,true,true,false,true,true]
            break
        case 7:
            c=[false,false,false,true,true,true,false]
            break
        case 8:
            c=[true,true,true,true,true,true,true]
            break
        default:
            c=[true,false,true,true,true,true,true]
            break
        }
        return c
    }
    //chon anh cho vi tri
    func get_image(n:Int, value:Bool)->UIImage{
        var i:UIImage
        let match_v = UIImage(named: "Match_v", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let match_v_hide = UIImage(named: "Match_v_hide", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let match_h = UIImage(named: "Match_h", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let match_h_hide = UIImage(named: "Match_h_hide", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        if(n == 7){
            if (value){
                i = match_v
            }else{
                i = match_v_hide
            }
        }
        if(n == 2 || n == 5 || n == 6){
            if(value){
                i = match_h
            }else{
                i = match_h_hide
            }
        }
        else
        {
            if (value){
                i = match_v
            }else{
                i = match_v_hide
            }
        }
        return i
    }
    func set_a(n:Int){
        for i:Int in 0...6{
            a[i].setBackgroundImage( get_image(n: i, value: numa[i]), for: UIControlState.normal)
        }
    }
    func set_b(n:Int){
        for i:Int in 0...6{
            b[i].setBackgroundImage( get_image(n: i, value: numb[i]), for: UIControlState.normal)

        }

    }
    func set_c(n:Int){
        for i:Int in 0...6{
            c[i].setBackgroundImage( get_image(n: i, value: numc[i]), for: UIControlState.normal)
        }

    }
    func set_operator(d1:Bool){
        let match_v = UIImage(named: "Match_v", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let match_v_hide = UIImage(named: "Match_v_hide", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        if(d1){
            plus.setBackgroundImage(match_v, for: UIControlState.normal)
        }
        else{
            plus.setBackgroundImage(match_v_hide, for: UIControlState.normal)
        }
    }
    //Facebook
    public static let fbLoginmanager:FBSDKLoginManager = FBSDKLoginManager()
    func Facebook_share(){
        let image = GetScreenShot()
        let photo = FBSDKSharePhoto(image: image, userGenerated: true)
        let content = FBSDKSharePhotoContent()
        content.photos = [photo as Any]
        let sharedialog:FBSDKShareDialog = FBSDKShareDialog()
        sharedialog.shareContent = content
        sharedialog.fromViewController = self
        sharedialog.mode = FBSDKShareDialogMode.shareSheet
        sharedialog.delegate = self
        sharedialog.show()
    }
    
    func Login(){
        
        ViewController.fbLoginmanager.logIn(withReadPermissions: ["email","user_friends"], from: self) { (result, err) in
            if(err == nil){
                let fbloginresult:FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil{
                    self.getdataFB()
                }
            }
        }
    }
    var userInfo:Profile = Profile()
    func getdataFB(){
        if FBSDKAccessToken.current() != nil{
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email,first_name"]).start(completionHandler: { (connect, result, err) in
                if err == nil{
                    let dict = result as! Dictionary<String,Any>
                    //set Player information
                    self.userInfo.facebookid = dict["id"] as! String
                    self.userInfo.name = dict["name"] as! String
                    self.userInfo.email = dict["email"] as! String
                    self.lblname.text = dict["first_name"] as? String
                    self.Avatar.load_Data(link: "https://graph.facebook.com/\(self.userInfo.facebookid)/picture")
                    self.getServerData()
                    //response size
                    self.response_screen()
                    //Save data to cache
                    let CACHE = UserDefaults.standard
                    CACHE.set(self.userInfo.facebookid, forKey: CacheKey.FACEBOOK_ID)
                    CACHE.set(self.userInfo.email, forKey: CacheKey.EMAIL)
                    CACHE.set(self.userInfo.name, forKey: CacheKey.NAME)
                    CACHE.set(dict["first_name"] as! String, forKey: CacheKey.FIRST_NAME)
                }
            })

        }
    }
    public static var namelist:[String] = []
    public static var imagelist:[String] = []
    public static var scorelist:[Int] = []
    
    func getFriendList(){
        _ = FBSDKGraphRequest(graphPath: "/me/friends", parameters: [ "fields" : "id,name,picture{url},birthday" ]).start(completionHandler: {(connect, result, err ) in
            if err == nil {
                let dict = result as! Dictionary<String,Any>
                //print("friend list")
                let a:[Dictionary] = dict["data"] as! [Dictionary <String, Any>]
                ViewController.namelist = []
                ViewController.imagelist = []
                ViewController.scorelist = []
                if a.count > 0 {
                    var jsonString = "{"
                    jsonString += "\"0\":\"\(String(describing: a[0]["id"]!))\""
                    for var i in 0..<a.count {
                        if i > 0 {
                            jsonString += ", \"\(i)\":\"\(String(describing: a[i]["id"]!))\""
                        }
                        let picture = a[i]["picture"] as! Dictionary<String,Any>
                        let picture_data = picture["data"] as! Dictionary<String,String>
                        let link = picture_data["url"]!
                        ViewController.imagelist.append(link)
                    }
                    jsonString += "}"
                    //post to server
                    let url = URL(string: self.SERVER + "friend.php")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    //let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    request.httpBody = jsonString.data(using: .utf8, allowLossyConversion: true)
                    let session = URLSession.shared
                    session.dataTask(with: request) { (data, response, error) in
                        if let data = data {
                            let jsonResult = String(data: data, encoding: .utf8)!
                            //print(jsonResult)
                            do{
                                let d = try JSONSerialization.jsonObject(with: jsonResult.data(using: .utf8)!, options: []) as! NSDictionary
                                let resultdt = d["friend"] as! [Dictionary<String,String>]
                                print(resultdt)
                                for var i in 0..<resultdt.count {
                                    ViewController.scorelist.append(Int(resultdt[i]["highscore"]! as String)!)
                                    ViewController.namelist.append(resultdt[i]["name"]! as String)
                                }
                                print(ViewController.namelist)
                                listFriendViewController.isInit = true
                            } catch {
                                
                            }
                        }
                        }.resume()
                }
                
            }else{
                print(err)
            }
            
        })

    }
    
   // public static var returnData = Profile()
    
    func getServerData(){
        let parameters = ["facebookid": userInfo.facebookid,"name": userInfo.name,"email": userInfo.email,"score": String(Score)]
        let url = URL(string: SERVER)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = httpBody!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let jsonResult = String(data: data, encoding: .utf8)!
                do{
                    let d = try JSONSerialization.jsonObject(with: jsonResult.data(using: .utf8)!, options: []) as! NSDictionary
                    self.userInfo.highscore = Int(d["highscore"] as! String)!
                    let HC = self.userInfo.highscore > 9 ? "" : "0"
                    self.lblHighScore.text = self.HIGHSCORE + HC + String(self.userInfo.highscore)
                    print("----------update high score----------")
                    print(self.userInfo.highscore)
                    print("----------save high score to cache-----------")
                    let defaults = UserDefaults.standard
                    defaults.set(self.userInfo.highscore, forKey: CacheKey.HIGH_SCORE)
                    let linkImage = d["picture"] as! String
                    self.Avatar.load_Data(link: linkImage)
                    self.getFriendList()
                } catch {
                }
                
            }
        }.resume()
    }
    
    func sharer(_ sharer: FBSDKSharing, didCompleteWithResults results: [AnyHashable: Any]) {
        msgbox(message: "Thank you for shared!", title: "Notification", button_value: "Close")
        self.lblproblem.text = ("            " + self.answer! + "                 " )
    }
    
    func sharer(_ sharer: FBSDKSharing, didFailWithError error: Error?) {

    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing) {
        self.lblproblem.text = MSG1
    }
}

extension UIButton {
    func load_Data(link:String){
        let url:URL = URL(string: link)!
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: CacheKey.AVATAR_IMAGE){
            let img = UIImage(data: data)
            self.setBackgroundImage(img, for: UIControlState.normal)
        } else {
            let session = URLSession.shared.dataTask(with: url) { (data, response, err) in
                DispatchQueue.main.sync {
                    //self.backg roundImage(for: UIControlState.normal) = UIImage(data: data!)
                    let img = UIImage(data: data!)
                    self.setBackgroundImage(img, for: UIControlState.normal)
                    defaults.set(data, forKey: CacheKey.AVATAR_IMAGE)
                    defaults.set(link, forKey: CacheKey.AVATAR_LINK)
                }
            }
            session.resume()
        }
        AppStatus.isLoadAvatar = true
    }
}

//Save cache key class
public class CacheKey{
    public static let NAME:String = "name"
    public static let AVATAR_LINK:String = "avatarLink"
    public static let AVATAR_IMAGE:String = "AvatarImage"
    public static let HIGH_SCORE:String = "highScore"
    public static let FACEBOOK_ID:String = "facebookid"
    public static let EMAIL:String = "email"
    public static let FIRST_NAME:String = "firstname"
    public static func RemoveAll(){
        let d = UserDefaults.standard
        d.removeObject(forKey: NAME)
        d.removeObject(forKey: AVATAR_LINK)
        d.removeObject(forKey: AVATAR_IMAGE)
        d.removeObject(forKey: HIGH_SCORE)
        d.removeObject(forKey: FACEBOOK_ID)
        d.removeObject(forKey: EMAIL)
        d.removeObject(forKey: FIRST_NAME)
    }
}
