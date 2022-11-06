//
//  TableViewCellChat.swift
//  FirebaseProject
//
//  Created by jinn on 30/10/2022.
//

import UIKit
import Firebase

class TableViewCellChat: UITableViewCell {
    enum typee{
        case incoming
        case outgoing
    }
    @IBOutlet var stackViewChat: UIStackView!
    @IBOutlet var textViewCellChat: UITextView!{
        didSet{
            layer.cornerRadius = 10
            
        }
    }
    @IBOutlet var labelNameChat: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setMessage(array : MESSAGE) {
       labelNameChat.text = array.senderName
       textViewCellChat.text = array.messageText
        
    }
    func setType(type:typee){
        if type == .incoming{
            stackViewChat.alignment = .leading
            textViewCellChat.backgroundColor = .gray
            textViewCellChat.textColor = .white
        }else if type == .outgoing{
            stackViewChat.alignment = .trailing
            textViewCellChat.backgroundColor = .green
            textViewCellChat.textColor = .black
        }
    }
}
