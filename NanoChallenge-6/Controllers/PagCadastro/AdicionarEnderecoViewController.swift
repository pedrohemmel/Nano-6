//
//  AdicionarEnderecoViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 25/07/22.
//

import UIKit
import MapKit
import CoreLocation

class AdicionarEnderecoViewController: UIViewController {

    @IBOutlet weak var mapaPrincipal: MKMapView!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var txtFieldProcurarEndereco: UITextField!
    @IBOutlet weak var tbViewPrincipal: UITableView!
    @IBOutlet weak var btnConfirmarEndereco: UIButton!
    
    //Criando variaveis que receberam valor da primeira página de cadastro
    var nome : String? = nil
    var nomeUsuario : String? = nil
    var email : String? = nil
    var senha : String? = nil
    var endereco : String? = nil
    
    //Criando a variavel array que armazenará as localizações
    var localizacoes = [Localizacao]()
    
    //Criando variável que vai auxiliar quando o keyboard for aparacer e esconder alguns textFields
    var escondeuTxtField : Bool = true
    var equilibraPosicaoView : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //setando borda customizada à alguns objetos
        panelView.layer.cornerRadius = 10
        btnConfirmarEndereco.layer.cornerRadius = 10
        
        //Setando cor default do botão de confirmar enquanto não tiver escolhido o endereco
        btnConfirmarEndereco.backgroundColor = .lightGray


        //Referenciando o delegate e dataSource dos objetos à classe ViewController
        txtFieldProcurarEndereco.delegate = self
        tbViewPrincipal.delegate = self
        tbViewPrincipal.dataSource = self
        
        adicionandoFuncoesKeyBoard()
    }
    
    //FUNÇÕES AQUI//
    
    //FUNÇÕES DO KEYBOARD
    
    func adicionandoFuncoesKeyBoard() {
        //Chamando funções de quando o usuário ativa o keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard)))
        NotificationCenter.default.addObserver(self, selector: #selector(apareceKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(desapareceKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func escondeKeyBoard() {
        self.view.endEditing(true)
    }
    @objc func apareceKeyBoard(notification: NSNotification) {
        if self.escondeuTxtField == true {
            if(self.equilibraPosicaoView == 0) {
                self.view.frame = self.view.frame.offsetBy(dx: CGFloat(0), dy: CGFloat(-90))
                self.escondeuTxtField = false
                self.equilibraPosicaoView = -50
            }
        }
    }
    @objc func desapareceKeyBoard() {
        if self.escondeuTxtField == false {
            if(self.equilibraPosicaoView != 0) {
                self.view.frame = self.view.frame.offsetBy(dx: CGFloat(0), dy: CGFloat(90))
                self.escondeuTxtField = true
                self.equilibraPosicaoView = 0
            }
            
        }
    }
    
    
    @IBAction func adicionarNovoUsuario(_ sender: Any) {
        //Verificando se o botão está disponível para ser clicado
        if(btnConfirmarEndereco.backgroundColor == UIColor(red: 5/255, green: 175/255, blue: 242/255, alpha: 1)) {
            
            //Estruturando um novo usuário para enviar ao banco de dados
            let usuario = UsuarioMD(email: self.email!, id: nil, nomeUsu: self.nomeUsuario!, nome: self.nome!, endereco: self.endereco!, senha: self.senha!)
            
            let adicionarUsu = AtualizaOuAdicionaUsuarioViewModel(usuarioAtual: usuario)
            
            adicionarUsu.atualizaOuAdicionaUsuario()

            let entry = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            entry.modalPresentationStyle = .fullScreen
            present(entry, animated: true)
            
            
            
        }
    }
    
    func adicionarPin(didSelectLocationWith coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else {
            return
        }

        //Criando um pin e adicionando uma coordenada a ele
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        
        //Adicionando o pin ao mapa e setando a regiao em que vai mostrar a marcação
        mapaPrincipal.addAnnotation(pin)
        mapaPrincipal.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)), animated: true)
    }

}

extension AdicionarEnderecoViewController: UITextFieldDelegate {
    
    //Quando clicar no return do teclado essa função será ativada
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Verificando se o tetxo não está vazio
        if let texto = txtFieldProcurarEndereco.text, !texto.isEmpty {
            
            //Fazendo a requisição do endereço
            LocationManager.shared.acharLocalizacao(with: texto) { [weak self] localizacoes in
                DispatchQueue.main.async {
                    self?.localizacoes = localizacoes
                    self?.tbViewPrincipal.reloadData()
                }
            }
        }
        
        return true
    }
    
    //Para cada letra digitada, será feita a busca
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Verificando se o tetxo não está vazio
        if let texto = txtFieldProcurarEndereco.text, !texto.isEmpty {
            
            //Fazendo a requisição do endereço
            LocationManager.shared.acharLocalizacao(with: texto) { [weak self] localizacoes in
                DispatchQueue.main.async {
                    self?.localizacoes = localizacoes
                    self?.tbViewPrincipal.reloadData()
                }
            }
        }
        
        self.btnConfirmarEndereco.backgroundColor = .lightGray
        
        return true
    }
}

extension AdicionarEnderecoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.adicionarPin(didSelectLocationWith: localizacoes[indexPath.row].coordenadas)
        
        self.btnConfirmarEndereco.backgroundColor = UIColor(red: 5/255, green: 175/255, blue: 242/255, alpha: 1)
        
        //Guardando a latitude e longitude na variável endereço que é o que vai ser guardado no banco de dados
        self.endereco = String(localizacoes[indexPath.row].coordenadas.latitude) + " " + String(localizacoes[indexPath.row].coordenadas.longitude)
        
        tbViewPrincipal.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AdicionarEnderecoViewController: UITableViewDataSource {
    
    
    //Função que determina a quantidades de celulas que terá na tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localizacoes.count
    }
    
    //Função que determina os valores contidos dentro de cada célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbViewPrincipal.dequeueReusableCell(withIdentifier: "EnderecoTableViewCell") as! EnderecoTableViewCell
        
        cell.lblEndereco.text = localizacoes[indexPath.row].titulo
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}



