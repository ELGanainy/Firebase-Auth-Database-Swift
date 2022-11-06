//
//  CHAT.swift
//  FirebaseProject
//
//  Created by jinn on 30/10/2022.
//

import UIKit
import Firebase


class CHAT: UIViewController {
    var roo : ROOM?
    var me = [MESSAGE]()
    var ee : MESSAGE?
    @IBOutlet var tableViewChat: UITableView!{
        didSet{
            tableViewChat.dataSource = self
            tableViewChat.delegate = self
            tableViewChat.register(UINib(nibName: "TableViewCellChat", bundle: nil), forCellReuseIdentifier: "TableViewCellChat")
            tableViewChat.reloadData()
        }
    }
    @IBOutlet var chatTextView: UITextView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var labelChat: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChat.separatorStyle = .none
        tableViewChat.allowsSelection = false
        title = roo?.roomName

       observeMessage()
    }
    func observeMessage(){
        guard let roomId = roo?.roomID , let userId = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference()
        ref.child("ROOMS").child(roomId).child("Message").observe(.childAdded) { snap in
            if let dataArray = snap.value as? [String:Any] {
                guard let senderName = dataArray["Sender Name"] as?String , let text = dataArray["Text"]as?String  else {return}
                let message = MESSAGE.init(messageKey: snap.key, messageText: text, senderName: senderName, userID: userId)
                    self.me.append(message)
                    self.tableViewChat.reloadData()
            }
        }
    }
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func sendChatButton(_ sender: UIButton) {
        guard let chatText = chatTextView.text , chatText.isEmpty == false , let userID = Auth.auth().currentUser?.uid  else {return}
        let ref = Database.database().reference()
        let user = ref.child("USERS").child(userID)
        user.child("User Name").observeSingleEvent(of: .value) { snap in
            if let userName = snap.value as? String{
                if let roomId = self.roo?.roomID{
                    let dataArray : [String: Any] = ["Sender Name":userName , "Text":chatText]
                    let room = ref.child("ROOMS").child(roomId)
                    room.child("Message").childByAutoId().setValue(dataArray) { error, datare in
                        if error == nil {
                            self.tableViewChat.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
extension CHAT : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return me.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meCell = me[indexPath.row]
        if let cell = tableViewChat.dequeueReusableCell(withIdentifier: "TableViewCellChat", for: indexPath)as?TableViewCellChat{
            cell.setMessage(array: meCell)
            if ee?.userID == Auth.auth().currentUser?.uid {
                cell.setType(type: .outgoing)
            }else{
                cell.setType(type: .incoming)
            }
            return cell
        }
        return UITableViewCell()
    }
}
extension CHAT : UITableViewDelegate{
    
}
