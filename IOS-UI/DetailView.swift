//
//  DetailView.swift
//  IOS-UI
//
//  Created by jpineros on 5/03/22.
//

import SwiftUI
import ChallengeMercadoLibre

struct DetailView: View {
    @Binding var detailItem: ProductItem
    
    var body: some View {
        VStack {
            Text(detailItem.title)
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
            Text(detailItem.price.description)
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
         
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailItem: .constant(ProductItem(id: "", title: "", price: 0)))
    }
}
