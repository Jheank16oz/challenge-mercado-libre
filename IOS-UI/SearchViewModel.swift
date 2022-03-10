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
    
    // Model
    @Published var searchQuery: String = "" {
        didSet{
            self.emptyResult = false
        }
    }
    @Published var products:[ProductItem] = []
    @Published var progress:Bool = false
    @Published var errorMessage:String = ""
    @Published var hasError = false
    @Published var emptyResult = false
    
    var emptyMessage:String {
        if searchQuery.isEmpty {
            return "Ingrese una busqueda"
        }
        return #"No se encontraron resultados de busqueda para "\#(searchQuery)""#
    }
    
    // End Model
    
    private let searchProduct:SearchProduct
    init(searchProduct:SearchProduct){
        self.searchProduct = searchProduct
    }
    
    
    func search(){
        let queryItem = URLQueryItem(name: "q", value: searchQuery)
        progress(true)
        searchProduct.search(query: queryItem) {[weak self] result in
            
            guard self != nil else {
                return
            }
            
            switch result {
            case .success(let array):
                self?.success(array)
                
            case .failure(let error):
                self?.failure(error)
            }
            
            self?.progress(false)
        }
        
    }
    
    func success(_ array:[ProductItem]){
        publishProducts(products: array)
    }
    
    func failure(_ err: SearchProduct.Error){
        if err == .connectivity {
            error("Error de conexión")
        }else {
            error("Tenemos problemas para obtener la información")
        }
    }
    
    func publishProducts(products:[ProductItem]){
        DispatchQueue.main.async{
            self.products = products
            self.emptyResult = self.products.isEmpty ? true : false
        }
    }
    
    func progress(_ value: Bool) {
        DispatchQueue.main.async {
            self.progress = value
        }
    }
    
    func error(_ value: String) {
        DispatchQueue.main.async {
            self.errorMessage = value
            self.hasError = true
        }
    }
    
    func retry(){
        self.search()
    }
    
    func cancelError(){
        self.hasError = false
        self.errorMessage = ""
    }
}
