//
//  FiltroViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 28/07/22.
//

import UIKit

class FiltroViewController: UIViewController {
    
    var deopsitos : [DepositoMD]? = nil
    
    var listaDep : [ListaDeposito]? = nil
    
    var ordenaPorDistancia : (() -> Void)?
    var ordenaPorOrdAlfabetica : (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func voltarPagPrincipal(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func filtrarPorOrdAlfabetica(_ sender: Any) {
        self.ordenaPorOrdAlfabetica?()
        
        dismiss(animated: true)
    }
    @IBAction func filtrarPorDistancia(_ sender: Any) {
        self.ordenaPorDistancia?()
        
        dismiss(animated: true)
    }
    
    
}
