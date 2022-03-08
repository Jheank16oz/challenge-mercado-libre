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
    @Published var progress:Bool = false
    private let searchProduct:SearchProduct
    
    
    init(){
        let url:URL = URL(string: "https://api.mercadolibre.com/sites/MLA/search")!
        let client = URLSessionHTTPClient()
        searchProduct = SearchProduct(url: url, client: client)
    }
    
    
    func search(search:String){
        let queryItem = URLQueryItem(name: "q", value: search)
        setProgress(true)
        searchProduct.search(query: queryItem) { result in
            switch result {
            case .success(let array):
                self.publishProducts(products: array)
                self.setProgress(false)
            case .failure(let error):
                print(error)
                self.setProgress(false)
            }
        }
        
    }
    
    
    func publishProducts(products:[ProductItem]){
        DispatchQueue.main.async{
            self.products = products
        }
    }
    
    func setProgress(_ value: Bool) {
        DispatchQueue.main.async {
            self.progress = value
        }
    }
}
