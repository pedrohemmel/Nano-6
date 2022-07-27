//
//  EnderecoTableViewCell.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 26/07/22.
//

import UIKit

class EnderecoTableViewCell: UITableViewCell {

    //Estruturando celula para ser utilizada no arquivo AdicionarEnderecoViewController
    @IBOutlet weak var lblEndereco: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
