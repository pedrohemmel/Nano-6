//
//  ControlerDePagsViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 30/07/22.
//

import UIKit

class ControlerDePagsViewController: UITabBarController {
    
    var usuario : UsuarioMD? = nil
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setando a cor padrão dos itens na tabBar
        UITabBar.appearance().tintColor = UIColor(red: 5/255, green: 175/255, blue: 242/255, alpha: 1)

        let vc = self.viewControllers?[0] as! MainViewController
        vc.usuario = self.usuario
        

        // Do any additional setup after loading the view.
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
