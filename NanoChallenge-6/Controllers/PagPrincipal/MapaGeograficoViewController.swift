//
//  MapaGeograficoViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 28/07/22.
//

import UIKit
import MapKit
import CoreLocation

class MapaGeograficoViewController: UIViewController {
    
    @IBOutlet weak var mapaPrincipal: MKMapView!
    
    var usuario : UsuarioMD? = nil
    
    var depositos : [DepositoMD]? = nil
    let depositoViewModel = DepositoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fazendo a requisição do endereço
        LocationManager.shared.acharLocalizacao(with: usuario?.endereco ?? "") { [weak self] localizacoes in
            self?.adicionarPin(didSelectLocationWith: localizacoes[0].coordenadas)
        }
        
        buscandoEAdicionandoDepositos()
        
        //delegate nos objetos
        mapaPrincipal.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //FUNÇÕES AQUI//
    @IBAction func voltarPagPrincipal(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func buscandoEAdicionandoDepositos() {
        Task {
            do {
                //Buscando os depositos do banco de dados
                try await self.depositoViewModel.buscarDepositos()
                self.depositos = depositoViewModel.depositos
                
                for deposito in self.depositos! {
                    
                    LocationManager.shared.acharLocalizacao(with: deposito.endereco) { [weak self] localizacoes in
                        
                        //Chamando a função que adiciona os pins no mapa
                        self?.adicionarPinDepositos(didSelectLocationWith: localizacoes[0].coordenadas, titulo: deposito.nomeFantasia)
                        
                    }
                    
                }
            } catch {
                print("Erro: \(error)")
            }
        }
    }
    
    //Funções que adicionam pins no mapa
    
    //Função que adiciona a localização do usuário no mapa
    func adicionarPin(didSelectLocationWith coordinate: CLLocationCoordinate2D?) {
        
        guard let coordinate = coordinate else {
            return
        }

        //Criando um pin e adicionando uma coordenada a ele
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Seu endereço"
        
        //Adicionando o pin ao mapa e setando a regiao em que vai mostrar a marcação
        mapaPrincipal.addAnnotation(pin)
        mapaPrincipal.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
    }
    func adicionarPinDepositos(didSelectLocationWith coordinate: CLLocationCoordinate2D?, titulo: String) {
        
        guard let coordinate = coordinate else {
            return
        }

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = titulo
        pin.subtitle = "Depósito"
        
        mapaPrincipal.addAnnotation(pin)
    }

}

extension MapaGeograficoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        //Identificando os pins dentro do mapa principal
        var annotationView = mapaPrincipal.dequeueReusableAnnotationView(withIdentifier: "pinCustomizado")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pinCustomizado")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation.subtitle == "Depósito" {
            annotationView?.image = UIImage(named: "ToolBox")
        } else {
            annotationView?.image = UIImage(named: "LocationPin")
        }
        
                
        return annotationView
    }
}
