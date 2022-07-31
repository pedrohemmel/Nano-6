//
//  ListaDepositosTableViewCell.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 14/07/22.
//

import UIKit

class ListaDepositosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNomeDeposito: UILabel!
    @IBOutlet weak var lblDistanciaDeposito: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
