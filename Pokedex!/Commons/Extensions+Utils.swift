//
//  Extensions+Utils.swift
//  Pokedex!
//
//  Created by michaell medina on 18/01/24.
//

import UIKit

extension UIImageView {
    func fetchOfficialArtwork(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let artworkImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = artworkImage
                }
            }
        }.resume()
    }
}
