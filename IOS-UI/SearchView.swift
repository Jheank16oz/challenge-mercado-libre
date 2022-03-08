//
//  ContentView.swift
//  IOS-UI
//
//  Created by jpineros on 5/03/22.
//

import SwiftUI
import ChallengeMercadoLibre

struct SearchView: View {
    @State var search: String = ""
    @State private var selectedItem: ProductItem? = nil
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            Text("Ingresa una busqueda")
                .underline()
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
            TextField("Busqueda", text: $search)
                .foregroundColor(.gray)
                .frame(height: 50)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke())
                .onSubmit {
                    searchViewModel.search(search:$search.wrappedValue)
                }
            if searchViewModel.progress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(height: 50)
                    .scaleEffect(2)
            }
            List($searchViewModel.products){ $product in
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
        }
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
