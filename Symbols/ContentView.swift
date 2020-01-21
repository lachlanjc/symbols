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

struct Symbol: Identifiable {
    var id = UUID()
    var name: String
}

struct ContentView: View {
    var body: some View {
        let symbols = symbolData.map { Symbol(name: $0) }
        return NavigationView {
            List(symbols) { symbol in
                SymbolRow(name: symbol.name)
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
