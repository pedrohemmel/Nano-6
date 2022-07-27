//
//  ViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 13/07/22.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    
    //Conectando as view no storyboard dentro do código para futuras manipulações
    @IBOutlet weak var tbViewListDepositos: UITableView!
    @IBOutlet weak var viewIptPrincipal: UIView!
    @IBOutlet weak var viewBtnSearch: UIView!
    @IBOutlet weak var mapViewPagPrincipal: MKMapView!
    @IBOutlet weak var viewBtnFiltrarPesquisa: UIButton!
    

    //Criando a variável que vai guardar o usuário que fez o login
    var usuario : UsuarioMD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Manipulando as views que representarão o input
        mapViewPagPrincipal.layer.cornerRadius = 10
        
        viewIptPrincipal.layer.cornerRadius = 10
        viewBtnSearch.layer.cornerRadius = 10
        
        viewBtnFiltrarPesquisa.layer.cornerRadius = 10
        
        //Ajustando para que só o lado esquerdo da viewBtnSearch estejam com o cornerRadius aplicado
        viewBtnSearch.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        //Referenciando o delegate e dataSource dos objetos à classe ViewController
        tbViewListDepositos.delegate = self
        tbViewListDepositos.dataSource = self
        
        adicionandoFuncoesKeyBoard()
    }
    
    //FUNÇÕES AQUI//
    
    func adicionandoFuncoesKeyBoard() {
        //Chamando funções de quando o usuário ativa o keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard)))
    }
    @objc func escondeKeyBoard() {
        self.view.endEditing(true)
    }


}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    
    //Setando a quantidade de celulas que terá na tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //Adicionando valor aos objetos dentro da célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbViewListDepositos.dequeueReusableCell(withIdentifier: "ListaDepositosTableViewCell") as! ListaDepositosTableViewCell
        cell.lblNomeDeposito.text = "Depósito do seu zé"
        cell.lblDistanciaDeposito.text = "12.0" + " Km"
        return cell
    }
    
    
}

