//
//  ConfiguracoesViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 31/07/22.
//

import UIKit

class ConfiguracoesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func fazerLogOut(_ sender: Any) {
        
                UserDefaults.standard.setValue(nil, forKey: "usuario")
                UserDefaults.standard.setValue(nil, forKey: "logado")
        
        let entry = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        entry.modalPresentationStyle = .fullScreen
        present(entry, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
