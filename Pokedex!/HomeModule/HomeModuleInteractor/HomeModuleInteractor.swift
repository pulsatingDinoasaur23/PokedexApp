//
//  HomeModuleInteractor.swift
//  Pokedex!
//
//  Created by michaell medina on 18/01/24.
//

import Foundation

class HomeModuleInteractor: HomeModuleInteractorProtocol {
    
    var presenter: HomeModulePresenterOutputProtocol?
    var externalDataManager: HomeExternalDataManagerProtocol?
}
extension HomeModuleInteractor: HomeModuleInteractorInputProtocol {
    func fetchPokemonLists(){
        externalDataManager?.fetchPokemonList()
        
    }
}
extension HomeModuleInteractor: HomeModuleInteractorOutputProtocol {
    
    func onPokemonImageRetrieved(_ pokemonImages: [PokemonCellsDetails], _ pokemonData: [Pokemon]) {
        var imageDataArray: [PokemonCardDetails] = []
        for (index, pokemonDetail) in pokemonImages.enumerated() {
            if let sprites = pokemonDetail.sprites,
               let otherFront = sprites.frontDefault,
               let artworkURLFront = URL(string: otherFront),
               let otherBack = sprites.backDefault,
               let artworkURLBack = URL(string: otherBack) {
                let pokemonURL: String
                if index < pokemonData.count {
                    pokemonURL = pokemonData[index].url
                } else {
                    pokemonURL = ""
                }
                let types = pokemonDetail.types
                let stats = pokemonDetail.stats
                if let dataFront = try? Data(contentsOf: artworkURLFront),
                   let dataRear = try? Data(contentsOf: artworkURLBack) {
                    let pokemonCard = PokemonCardDetails(
                        name: pokemonDetail.name,
                        imageDataFront: dataFront,
                        imageDataBack: dataRear,
                        types: types,
                        stats: stats
                    )
                    imageDataArray.append(pokemonCard)
                }
            }
        }
        self.presenter?.presentViewOfPokemonS(imageDataArray)
    }
}

