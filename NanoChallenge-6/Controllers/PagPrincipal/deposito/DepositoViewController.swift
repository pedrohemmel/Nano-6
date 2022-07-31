//
//  DepositoViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 29/07/22.
//

import UIKit
import MapKit
import CoreLocation

class DepositoViewController: UIViewController {
    
    var deposito : DepositoMD? = nil
    var usuario : UsuarioMD? = nil
    var distancia : Double? = nil

    @IBOutlet weak var mapaPagDeposito: MKMapView!
    @IBOutlet weak var lblDistancia: UILabel!
    @IBOutlet weak var lblNomeFantasia: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pre setando o valor das variáveis do storyboard
        lblNomeFantasia.text = deposito?.nomeFantasia
        lblEndereco.text = deposito?.endereco
        lblDistancia.text = String(format: "%.2f Km", distancia ?? 0.0)
        
        //Adicionando borda customizada ao mapa principal
        mapaPagDeposito.layer.cornerRadius = 10
        
        buscandoEAdicionandoDeposito()

    }
    
    func buscandoEAdicionandoDeposito() {
 
        LocationManager.shared.acharLocalizacao(with: deposito?.endereco ?? "") { [weak self] localizacoes in
            
            //Chamando a função que adiciona os pins no mapa
            self?.adicionarPinDepositos(didSelectLocationWith: localizacoes[0].coordenadas, titulo: self?.deposito?.nomeFantasia ?? "")
            
        }
    }
    
    //Falta setar a regiao e aproximacao que o pin vai aparecer
    func adicionarPinDepositos(didSelectLocationWith coordinate: CLLocationCoordinate2D?, titulo: String) {
        
        guard let coordinate = coordinate else {
            return
        }

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = titulo
        pin.subtitle = "Depósito"
        
        mapaPagDeposito.addAnnotation(pin)
        mapaPagDeposito.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)), animated: true)
    }
    
    @IBAction func voltarPagPrincipal(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
