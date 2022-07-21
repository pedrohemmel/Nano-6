//
//  ViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 13/07/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    
    //Conectando as view no storyboard dentro do código para futuras manipulações
    @IBOutlet weak var tbViewListDepositos: UITableView!
    @IBOutlet weak var viewIptPrincipal: UIView!
    @IBOutlet weak var viewBtnSearch: UIView!
    @IBOutlet weak var mapViewPagPrincipal: MKMapView!
    @IBOutlet weak var viewBtnFiltrarPesquisa: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Manipulando as views que representarão o input
        viewIptPrincipal.layer.cornerRadius = 10
        mapViewPagPrincipal.layer.cornerRadius = 10
        viewBtnFiltrarPesquisa.layer.cornerRadius = 10
        viewBtnSearch.layer.cornerRadius = 10
        //Ajustando para que só o lado esquerdo da viewBtnSearch estejam com o cornerRadius aplicado
        viewBtnSearch.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
       
        tbViewListDepositos.delegate = self
        tbViewListDepositos.dataSource = self
    }


}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbViewListDepositos.dequeueReusableCell(withIdentifier: "ListaDepositosTableViewCell") as! ListaDepositosTableViewCell
        cell.lblNomeDeposito.text = "Depósito do seu zé"
        cell.lblAvaliacaoDeposito.text = "4.7"
        cell.lblDistanciaDeposito.text = "12.0" + " Km"
        return cell
    }
    
    
}

