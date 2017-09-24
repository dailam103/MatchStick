//
//  listFriendViewController.swift
//  MatchStick Go
//
//  Created by NGUYỄN QUỐC ĐẠI LÂM on 2017/07/31.
//  Copyright © 2017 NGUYỄN QUỐC ĐẠI LÂM. All rights reserved.
//

import UIKit

class listFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableMain: UITableView!
    public static var isInit:Bool = false
    var timer:Timer!
    var name: [String] = ["Horse"]
    var img: [String] = ["e"]
    var score: [Int] = []
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    let SCREENSIZE: CGRect = UIScreen.main.bounds
    
    // don't forget to hook this up from the storyboard
   // @IBOutlet var tableView: UITableView!
    @IBAction func touch_btnLogout(_ sender: UIButton) {
        ViewController.fbLoginmanager.logOut()
        ViewController.logout = true
        name = []
        score = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableMain.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: update(timer:))
        
    }
    func Response_screen(){
        
        tableMain.frame = CGRect(x: 0, y: SCREENSIZE.height / 10, width: SCREENSIZE.width, height: SCREENSIZE.height * 9 / 10)
    }
    func sort(){
        if score.count < 2{
            return
        }
        for var i in 0...(score.count - 2) {
            for var j in (i+1)...(score.count - 1) {
                if score[i] < score[j] {
                    let b = score[i]
                    score[i] = score[j]
                    score[j] = b
                    
                    let c = name[i]
                    name[i] = name[j]
                    name[j] = c
                    
                    let d = img[i]
                    img[i] = img[j]
                    img[j] = d
                    
                }
            }
        }
    }
    func update(timer:Timer){
        if listFriendViewController.isInit {
            
            name = ViewController.namelist
            img = ViewController.imagelist
            score = ViewController.scorelist
            sort()
            tableMain.delegate = self
            tableMain.dataSource = self
            listFriendViewController.isInit = false
            tableMain.reloadData()
        } else {
            
        }
        for var i in 0..<name.count {
            let indexPath = IndexPath(item: i, section: 0)
            tableMain.cellForRow(at: indexPath)?.setNeedsLayout()
        }
        
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.name.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableMain.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        let id = indexPath.row
        cell.textLabel?.text = self.name[id] + " -> " + String(self.score[id])
        cell.imageView?.load_Data(link: img[id])
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
extension UIImageView {
    func load_Data(link:String){
        let url:URL = URL(string: link)!
        let session = URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.sync {
                //self.backgroundImage(for: UIControlState.normal) = UIImage(data: data!)
                self.image = UIImage(data: data!)
            }
        }
        session.resume()
        
    }
}
