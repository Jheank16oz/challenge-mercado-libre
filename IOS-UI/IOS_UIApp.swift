//
//  IOS_UIApp.swift
//  IOS-UI
//
//  Created by jpineros on 5/03/22.
//

import SwiftUI
import ChallengeMercadoLibre

@main
struct IOS_UIApp: App {
    
    let searchProduct: SearchProduct;
    
    
    init(){
        // initializing dependencies
        let url:URL = URL(string: "https://api.mercadolibre.com/sites/MLA/search")!
        let client = URLSessionHTTPClient()
        searchProduct = SearchProduct(url: url, client: client)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                SearchView(searchVM: makeSearchViewModel())
            }
        }
    }
    
    func makeSearchViewModel() -> StateObject<SearchViewModel>{
        let searchViewModel = SearchViewModel(searchProduct: searchProduct)
       
        return StateObject(wrappedValue: searchViewModel)
    }
}
