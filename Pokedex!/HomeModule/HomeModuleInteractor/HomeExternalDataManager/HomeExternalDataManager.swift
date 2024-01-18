//
//  HomeExternalDataManager.swift
//  Pokedex!
//
//  Created by michaell medina on 18/01/24.
//

import Foundation

class HomeExternalDataManager: HomeExternalDataManagerProtocol {
    
    var interactorOutputProtocol: HomeModuleInteractorOutputProtocol?
    var pokemonList = [PokemonListResponse]()
    var pokemonImages = [PokemonCellsDetails]()
    
    func fetchPokemonList() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode(PokemonListResponse.self, from: data)
                self.pokemonList = [pokemonList]
                
                fetchPokemonDetailsSequentially(pokemonList: pokemonList) { pokemons, pokemonsData in
                    self.pokemonImages = pokemons
                    self.interactorOutputProtocol?.onPokemonImageRetrieved(pokemons, pokemonsData)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    private func fetchPokemonDetailsSequentially(pokemonList: PokemonListResponse, completion: @escaping ([PokemonCellsDetails], [Pokemon]) -> Void) {
        var pokemons: [PokemonCellsDetails] = []
        var pokemonsData: [Pokemon] = []
        
        for pokemon in pokemonList.results {
            guard let url = URL(string: pokemon.url) else {
                continue
            }
            
            if let data = try? Data(contentsOf: url) {
                do {
                    let decoder = JSONDecoder()
                    let pokemonDetails = try decoder.decode(PokemonCellsDetails.self, from: data)
                    pokemons.append(pokemonDetails)
                    pokemonsData.append(Pokemon(name: pokemonDetails.name, url: pokemon.url))
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        
        completion(pokemons, pokemonsData)
    }
}
