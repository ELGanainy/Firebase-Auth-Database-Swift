//
//  ROOMS.swift
//  FirebaseProject
//
//  Created by jinn on 29/10/2022.
//

import UIKit
import Firebase

class ROOMS: UIViewController {
 var room = [ROOM]()
    
    @IBOutlet var tableViewRooms: UITableView!{
        didSet{
            tableViewRooms.dataSource = self
            tableViewRooms.delegate = self
            tableViewRooms.register(UINib(nibName: "TableViewCellRooms", bundle: nil), forCellReuseIdentifier: "TableViewCellRooms")
            tableViewRooms.reloadData()
        }
    }
    @IBOutlet var roomsTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser == nil {
          display()
        }
        observe()
    }
    func display(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController")as?ViewController{
            present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func signOutButton(_ sender: UIButton) {
       
        try! Auth.auth().signOut()
       display()
    }
    @IBAction func createRoomsButton(_ sender: UIButton) {
        guard let roomName = roomsTextField.text , roomName.isEmpty == false else {return}
        let ref = Database.database().reference()
        let roo = ref.child("ROOMS").childByAutoId()
        let dataArray : [String:Any] = ["RoomName":roomName]
        roo.setValue(dataArray) { error, reff in
            if error == nil {
                self.roomsTextField.text = ""
            }
        }
    }
    func observe(){
        let ref = Database.database().reference()
        ref.child("ROOMS").observe(.childAdded) { snap in
            if let sn = snap.value as? [String:Any] {
                if let roomNamee = sn["RoomName"] as? String {
                    let roo = ROOM.init(roomName: roomNamee, roomID: snap.key)
                        self.room.append(roo)
                        self.tableViewRooms.reloadData()
                }
            }
                
        }
    }
   

}
extension ROOMS : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableViewRooms.dequeueReusableCell(withIdentifier: "TableViewCellRooms", for: indexPath)as?TableViewCellRooms{
            cell.labelCell.text = room[indexPath.row].roomName
            return cell
        }
       return UITableViewCell()
    }
}
extension ROOMS : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CHAT")as?CHAT{
            vc.roo = room[indexPath.row]
            present(vc, animated: true, completion: nil)
        }
    }
}
