//
//  ContentView.swift
//  IOS-UI
//
//  Created by jpineros on 5/03/22.
//

import SwiftUI
import ChallengeMercadoLibre

struct SearchView: View {
    @State private var selectedItem: ProductItem? = nil
    @StateObject var searchVM = SearchViewModel()
    
    var body: some View {
        VStack {
            Text("Mercado Libre Argentina (Search)")
                .foregroundColor(.yellow)
                .padding(.horizontal, 16)
            TextField("Busqueda", text: $searchVM.searchQuery)
                .foregroundColor(.gray)
                .frame(height: 50)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke())
                .onSubmit {
                    searchVM.search()
                }
            if searchVM.progress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(height: 50)
                    .scaleEffect(2)
            }
            
            if searchVM.emptyResult{
                Text(searchVM.emptyMessage)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
            }
            List($searchVM.products){ $product in
                NavigationLink(
                    destination: DetailView(detailItem: $product),
                    tag: product,
                    selection: $selectedItem
                ) {
                    Text("""
                         \(product.title)
                         \(product.price.description)
                         """).allowsHitTesting(false)
                }
            }
        }.actionSheet(isPresented: $searchVM.hasError, content: {
            ActionSheet(
                title: Text(searchVM.errorMessage),
                buttons: [
                    .default(Text("Reintentar")) {
                        searchVM.retry()
                    },
                    .cancel(){
                        searchVM.cancelError()
                    }
                ])
        })
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

extension ProductItem: Identifiable, Hashable {
    
    static func == (lhs: ProductItem, rhs: ProductItem) -> Bool {
          lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(price)
    }
}
