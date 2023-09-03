//
//  SearchBar.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()

        // Cambiar color de fondo y bordes
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.backgroundColor = UIColor(white: 0.9, alpha: 1) // Gris muy claro
        textFieldInsideUISearchBar?.layer.cornerRadius = 10
        textFieldInsideUISearchBar?.clipsToBounds = true

        // Establecer placeholder
        textFieldInsideUISearchBar?.placeholder = "¿Qué buscas?"

        return searchBar
    }


    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

