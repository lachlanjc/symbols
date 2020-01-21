//
//  ContentView.swift
//  Symbols
//
//  Created by Lachlan Campbell on 1/20/20.
//  Copyright © 2020 Lachlan Campbell. All rights reserved.
//

import SwiftUI

struct SymbolRow: View {
    var name: String
    var body: some View {
        HStack {
            Image(systemName: name).font(.system(size: 32)).padding()
            Text(name)
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
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct ContentView: View {
    @State var searchText = ""
    var body: some View {
        let symbols = searchText.count > 0 ?
            symbolData.filter { $0.contains(searchText) }
            : symbolData
        return NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List(symbols, id: \.self) { name in
                    SymbolRow(name: name)
                        .onTapGesture {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = name
                        }
                }
            }
            .navigationBarTitle(Text("Symbols"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
