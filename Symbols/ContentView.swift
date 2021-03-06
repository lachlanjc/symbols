//
//  ContentView.swift
//  Symbols
//
//  Created by Lachlan Campbell on 1/20/20.
//  Copyright © 2020 Lachlan Campbell. All rights reserved.
//

import SwiftUI
import Combine

struct SymbolRow: View {
    var name: String
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Image(systemName: name).font(.system(size: 32)).padding()
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            searchBar.showsCancelButton = true
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.endEditing(true)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search symbols"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct ContentView: View {
    @State var searchText = ""
    
    @ObservedObject var searchManager = SearchManager()
    
    var body: some View {
        return NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchManager.searchQuery)
                List(searchManager.data, id: \.self) { name in
                    SymbolRow(name: name)
                        .onTapGesture {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = name
                        }
                }.id(UUID())
            }
            .navigationBarTitle(Text("Symbols"))
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class SearchManager: ObservableObject {
    var searchQuery : String = "" {
        didSet {
            data = searchQuery.count > 0 ?
                symbolData.filter { $0.lowercased().contains(searchQuery.lowercased()) }
                : symbolData
        }
    }
    
    @Published var data = symbolData
    
    init() {
        
    }
}
