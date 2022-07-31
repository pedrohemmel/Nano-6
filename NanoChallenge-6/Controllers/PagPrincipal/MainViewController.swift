//
//  ViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 13/07/22.
//

import UIKit
import MapKit
import CoreLocation

public struct ListaDeposito {
    var nomeFantasia : String
    var distancia : Double
}

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
    
    //Variável que vai ser auxiliar em popular as listas
    var listaDep = [ListaDeposito]()
    
    var localizacaoDeposito = CLLocation(latitude: 00.0000, longitude: 00.0000)
    var distanciaDepEUsu : Double?
    
    //Booleano que vai ser a condição para verificar se o usuário está logado ou não
    var verificaUsuario : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        verificaStatusUsuario()
        
        verificaUsuarioLogado()
        
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
        
        //Fazendo a requisição do endereço
        LocationManager.shared.acharLocalizacao(with: usuario?.endereco ?? "") { [weak self] localizacoes in
            print("\n\n\n Esse veio do nada \n\n\n")
            
            //Aplicando string endereco a label de endereco
            self?.lblEnderecoEscolhido.text = self?.usuario?.endereco
            self?.adicionarPin(didSelectLocationWith: localizacoes[0].coordenadas)
        }
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
                
                //Fazendo a verificação para ver se o usuário existe no sistema
                for usuario in usuarios {
                    if(usuario.nomeUsu == self.usuario?.nomeUsu) {
                        verificaUsuario = true
                    }
                }

                //Verificando o retorno de autenticação do usuário e caso não tiver encontrado a tela é redirecionada para login
                if(verificaUsuario == false) {
                    let entry = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    entry.modalPresentationStyle = .fullScreen
                    present(entry, animated: true)
                }
                
            } catch {
                print("Erro: \(error)")
            }
        }
    }
    
    func verificaStatusUsuario() {
        
        //Verificando se há um usuário pré-setado, isso significa que acabou de logar ou cadastrar
        if usuario == nil {
    
            //Criando as variáveis que vão armazenar os valores contidos no UserDefaults
            var log = false
            var nomeUsu = ""
            
            //Guardando os dados do UserDefaults nas variáveis
            if let logado = UserDefaults.standard.value(forKey: "logado") as? Bool {
                log = logado
            }
            if let nomeDUsuario = UserDefaults.standard.value(forKey: "nomeDUsuario") as? String {
                nomeUsu = nomeDUsuario
            }
            
            //Fazendo a estrura condicional para checar se o usuario ja está no sistema
            if log {
                if nomeUsu != "" && nomeUsu != nil {
                    print(nomeUsu)
                    
                    buscarUsuario()
                    
                    for usuario in self.usuarios {
                        if nomeUsu == usuario.nomeUsu {
                            self.usuario = usuario
                        }
                    }
                } else {
                    voltarPagLogin()
                }
            } else {
                voltarPagLogin()
            }
            
        }
    }
    
    //Função que retorna para a página de login
    func voltarPagLogin() {
        let entry = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        entry.modalPresentationStyle = .fullScreen
        present(entry, animated: true)
    }
    
    func buscarUsuario() {
        Task {
            do {
                try await usuarioViewModel.buscaUsuarios()
                self.usuarios = usuarioViewModel.usuarios
                
            } catch {
                print("Erro: \(error)")
            }
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
    
    
    @IBAction func direcionarPagFiltrar(_ sender: Any) {
        
    
        
        //Setando cada deposito e sua distancia na array de ListaDeposito
        for deposito in self.depositos {
            self.distanciaEntreUsuEDep(deposito: deposito)
            self.listaDep.append(ListaDeposito(nomeFantasia: deposito.nomeFantasia, distancia: (distanciaDepEUsu ?? 0.0)/1000))
        }

        
        //Instanciando o ViewController de filtro
        let entry = storyboard?.instantiateViewController(withIdentifier: "FiltroViewController") as! FiltroViewController
        entry.sheetPresentationController?.detents = [.medium()]
        
        entry.listaDep = self.listaDep
        
        //Função que ordena os depositos por distancia entre o mesmo e o usuário
        entry.ordenaPorDistancia = {
            var newlistDepositos = [DepositoMD]()
            
            self.listaDep = self.listaDep.sorted(by: { $0.distancia < $1.distancia })

            for dep in self.listaDep {
                for deposito in self.depositos {
                    if dep.nomeFantasia == deposito.nomeFantasia {
                        newlistDepositos.append(deposito)
                    }
                }
            }
            

            self.depositos = newlistDepositos
            
            //Reiniciando as variáveis necessárias
            self.listaDep = [ListaDeposito]()
            newlistDepositos = [DepositoMD]()
            
            self.atualizaTabela()
        }
        
        //Função que ordena os depositos por ordem alfabetica
        entry.ordenaPorOrdAlfabetica = {
            DispatchQueue.main.async {
                self.depositos = self.depositos.sorted(by: { $0.nomeFantasia < $1.nomeFantasia })
                self.tbViewListDepositos.reloadData()
            }
            
            
            
        }
        
        
        present(entry, animated: true)
        
    }
    //Função que direciona o usuário para outra página que mostre o mapa de forma mais ampla
    @IBAction func verGeograficamente(_ sender: Any) {
        let entry = storyboard?.instantiateViewController(withIdentifier: "MapaGeograficoViewController") as! MapaGeograficoViewController
        
        entry.usuario = self.usuario
        entry.depositos = self.depositos
        
        entry.modalPresentationStyle = .fullScreen
        present(entry, animated: true)
        
    }
    
    func adicionandoFuncoesKeyBoard() {
        
        let toque = UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard))
        
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
        
        //Utilizando função que pega duas localizações e retorna a distancia entre as duas
        let distanciaEmMetros : CLLocationDistance = priLocalizacao.distance(from: segLocalizacao)
        
        return Double(distanciaEmMetros)
    }
    func localizaDeposito(endereco: String) {
        
        LocationManager.shared.acharLocalizacao(with: endereco) { [weak self] localizacoes in
            //Criando a variável do tipo localização e atribuindo latitude e longitude do deposito na mesma
            self?.localizacaoDeposito = CLLocation(latitude: localizacoes[0].coordenadas.latitude, longitude: localizacoes[0].coordenadas.longitude)
            return
        }
    }
    //Função que ve a distancia entre o usuário e o deposito
    func distanciaEntreUsuEDep(deposito: DepositoMD) {
        LocationManager.shared.acharLocalizacao(with: usuario?.endereco ?? "") { [weak self] localizacoes in
            //Buscando as localizações do usuario e do depósito para pegar a distancia
            let localizacaoUsuario = CLLocation(latitude: localizacoes[0].coordenadas.latitude, longitude: localizacoes[0].coordenadas.longitude)
            self?.localizaDeposito(endereco: deposito.endereco)
            self?.distanciaDepEUsu = self?.distanciaEntrePontos(localizacaoUsuario, comSegLocalizacao: self!.localizacaoDeposito)
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

//Extansão voltada para customização dos pins no mapa

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
            annotationView?.image = UIImage(named: "LocationPin")
        }
        
                
        return annotationView
    }
}

//Extensões voltadas para tabela principal

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Instanciando a viewController que mostrará o depósito escolhido em si
        let entry = storyboard?.instantiateViewController(withIdentifier: "DepositoViewController") as! DepositoViewController
        
        entry.deposito = self.depositos[indexPath.row]
        entry.usuario = self.usuario
        
        //Chamando função para saber qual é a distancia entre o usuário e o deposito clicado
        self.distanciaEntreUsuEDep(deposito: self.depositos[indexPath.row])
        entry.distancia = (distanciaDepEUsu ?? 0.0)/1000

        //Determinando que a ViewController será mostrado como sheetPresentation
        entry.sheetPresentationController?.detents = [.large()]
        present(entry, animated: true)
        
        //Tirando a seleção marcadana celula da tabela
        self.tbViewListDepositos.deselectRow(at: indexPath, animated: true)
    }
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
        
        distanciaEntreUsuEDep(deposito: self.depositos[indexPath.row])
        
        cell.lblDistanciaDeposito.text = "\(String(format: "%.2f Km", (distanciaDepEUsu ?? 0.0)/1000))"
        
        //Adicionando os valores da celula em uma variável estruturada para futuros processos
        
        
    
        
        return cell
    }
    
    
}

