//
//  BaseViewController.swift
//  Pokedex!
//
//  Created by michaell medina on 18/01/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}
