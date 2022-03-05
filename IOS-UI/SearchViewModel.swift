//
//  SearchViewModel.swift
//  IOS-UI
//
//  Created by jpineros on 5/03/22.
//

import Foundation
import ChallengeMercadoLibre
import UIKit

final class SearchViewModel:ObservableObject {
    
    @Published var products:[ProductItem] = []
    private let searchProduct:SearchProduct
    
    
    init(){
        let url:URL = URL(string: "https://api.mercadolibre.com/sites/MLA/search")!
        let client = URLSessionHTTPClient()
        searchProduct = SearchProduct(url: url, client: client)
    }
    
    
    func search(search:String){
        let queryItem = URLQueryItem(name: "q", value: search)
        searchProduct.search(query: queryItem) { result in
            switch result {
            case .success(let array):
                self.publishProducts(products: array)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func publishProducts(products:[ProductItem]){
        DispatchQueue.main.async{
            self.products = products
        }
    }
}
