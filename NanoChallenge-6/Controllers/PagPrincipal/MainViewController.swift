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
    @IBOutlet weak var lblEnderecoEscolhido: UILabel!
    @IBOutlet weak var txtFieldProcurar: UITextField!
    
    //Criando a variável que vai guardar o usuário que fez o login
    var usuario : UsuarioMD? = nil
    var usuarios = [UsuarioMD]()
    let usuarioViewModel = UsuarioViewModel()

    //Criando variável que vai armazenar os depósitos disponíveis no sistema
    var depositos = [DepositoMD]()
    var depositoViewModel = DepositoViewModel()
    
    //Criando variável auxiliar de busca dos depósitos
    var filtroDepositos = [DepositoMD]()
    
    var localizacaoDeposito = CLLocation(latitude: 00.0000, longitude: 00.0000)
    
    //Booleano que vai ser a condição para verificar se o usuário está logado ou não
    var verificaUsuario : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verificaUsuarioLogado()
        
        //Fazendo a requisição do endereço
        LocationManager.shared.acharLocalizacao(with: usuario?.endereco ?? "") { [weak self] localizacoes in
            self?.lblEnderecoEscolhido.text = localizacoes[0].titulo
            self?.adicionarPin(didSelectLocationWith: localizacoes[0].coordenadas)
        }
        
        
        //buscando depositos do sistema e adicionando no mapa
        buscandoEAdicionandoDepositos()

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
        mapViewPagPrincipal.delegate = self
        txtFieldProcurar.delegate = self
        
        adicionandoFuncoesKeyBoard()
    }
    
    //FUNÇÕES AQUI//
    
    func buscandoEAdicionandoDepositos() {
        Task {
            do {
                //Buscando os depositos do banco de dados
                try await self.depositoViewModel.buscarDepositos()
                self.depositos = depositoViewModel.depositos
                
                for deposito in self.depositos {
                    
                    LocationManager.shared.acharLocalizacao(with: deposito.endereco) { [weak self] localizacoes in
                        
                        //Chamando a função que adiciona os pins no mapa
                        self?.adicionarPinDepositos(didSelectLocationWith: localizacoes[0].coordenadas, titulo: deposito.nomeFantasia)
                        
                        //Atualizando os dados da tabela
                        DispatchQueue.main.async {
                            self?.tbViewListDepositos.reloadData()
                        }
                        
                    }
                    
                }
            } catch {
                print("Erro: \(error)")
            }
        }
    }
    
    func verificaUsuarioLogado() {
        //Lógica para verificar se o usuário está logado
        Task {
            do {
                try await usuarioViewModel.buscaUsuarios()
                usuarios = usuarioViewModel.usuarios
            } catch {
                print("Erro: \(error)")
            }
        }
        
        for usuario in usuarios {
            if(usuario.nomeUsu == self.usuario?.nomeUsu) {
                verificaUsuario = true
            }
        }
        
        if(verificaUsuario == false) {
            let entry = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            entry.modalPresentationStyle = .fullScreen
            present(entry, animated: true)
        }
    }
    
    //Função que atualiza dados da tabela
    func atualizaTabela() {
        DispatchQueue.main.async {
            self.tbViewListDepositos.reloadData()
        }
    }
    
    //Função que atualiza a array dos depósitos
    func atualizaListaDepositos() {
        Task {
            do {
                //Buscando os depositos do banco de dados
                try await self.depositoViewModel.buscarDepositos()
                self.depositos = depositoViewModel.depositos
                
            } catch {
                print("Erro: \(error)")
            }
        }
    }
    
    //Função que direciona o usuário para outra página que mostre o mapa de forma mais ampla
    @IBAction func verGeograficamente(_ sender: Any) {
    }
    
    func adicionandoFuncoesKeyBoard() {
        
        var toque = UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard))
        
        toque.cancelsTouchesInView = false
        
        //Chamando funções de quando o usuário ativa o keyboard
        self.view.addGestureRecognizer(toque)
    }
    @objc func escondeKeyBoard() {
        self.view.endEditing(true)
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
        mapViewPagPrincipal.addAnnotation(pin)
        mapViewPagPrincipal.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
    }
    
    func adicionarPinDepositos(didSelectLocationWith coordinate: CLLocationCoordinate2D?, titulo: String) {
        
        guard let coordinate = coordinate else {
            return
        }

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = titulo
        pin.subtitle = "Depósito"
        
        mapViewPagPrincipal.addAnnotation(pin)
    }
    
    //Funções para achar distancia entre pontos
    func distanciaEntrePontos(_ priLocalizacao: CLLocation, comSegLocalizacao segLocalizacao: CLLocation) -> Double {
        let distanciaEmMetros : CLLocationDistance = priLocalizacao.distance(from: segLocalizacao)
        
        return Double(distanciaEmMetros)
    }
    
    func localizaDeposito(endereco: String) {
        
        LocationManager.shared.acharLocalizacao(with: endereco) { [weak self] localizacoes in
            self?.localizacaoDeposito = CLLocation(latitude: localizacoes[0].coordenadas.latitude, longitude: localizacoes[0].coordenadas.longitude)
            return
        }
    }
    
    //Função que faz a lógica de pesquisa dos depósitos {
    func pesquisaFiltrada() {
        //Verificando se o tetxo não está vazio
        if let texto = txtFieldProcurar.text, !texto.isEmpty {
            
            let txt = texto.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if(txt != "") {
                for deposito in depositos {
                    if deposito.nomeFantasia.contains(txt) {
                        filtroDepositos.append(deposito)
                    }
                }
                
                self.depositos = filtroDepositos
                
                filtroDepositos = [DepositoMD]()
                
                atualizaTabela()
                
                atualizaListaDepositos()
            } else {
                atualizaListaDepositos()
                
                atualizaTabela()
            }
        }
    }
    
    
    @IBAction func pesquisaDeposito(_ sender: Any) {
        pesquisaFiltrada()
    }
        
    


}

//Extensão voltada para o textField

extension MainViewController: UITextFieldDelegate {
    //Quando clicar no return do teclado essa função será ativada
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        pesquisaFiltrada()
        
        return true
    }
    
    //Para cada letra digitada, será feita a busca
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        pesquisaFiltrada()
        return true
    }
}


extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        //Identificando os pins dentro do mapa principal
        var annotationView = mapViewPagPrincipal.dequeueReusableAnnotationView(withIdentifier: "pinCustomizado")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pinCustomizado")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation.subtitle == "Depósito" {
            annotationView?.image = UIImage(named: "ToolBox")
        } else {
            annotationView?.image = UIImage(named: "locationPin")
        }
        
                
        return annotationView
    }
}

//Extensões voltadas para tabela principal

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    
    //Setando a quantidade de celulas que terá na tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositos.count
    }
    
    //Adicionando valor aos objetos dentro da célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Identificando e setando os valores das
        let cell = self.tbViewListDepositos.dequeueReusableCell(withIdentifier: "ListaDepositosTableViewCell") as! ListaDepositosTableViewCell
        cell.lblNomeDeposito.text = self.depositos[indexPath.row].nomeFantasia
        
        LocationManager.shared.acharLocalizacao(with: usuario?.endereco ?? "") { [weak self] localizacoes in
            //Buscando as localizações do usuario e do depósito para pegar a distancia
            let localizacaoUsuario = CLLocation(latitude: localizacoes[0].coordenadas.latitude, longitude: localizacoes[0].coordenadas.longitude)
            self?.localizaDeposito(endereco: self?.depositos[indexPath.row].endereco ?? "")
            let distancia = self?.distanciaEntrePontos(localizacaoUsuario, comSegLocalizacao: self!.localizacaoDeposito)
            cell.lblDistanciaDeposito.text = " \(String(format: "%.01f Km", distancia!/1000))"
        }
        
        
        return cell
    }
    
    
}

