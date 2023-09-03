//
//  CustomerMapPin.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import SwiftUI

struct CustomMapPin: View {
    var isHighlighted: Bool = false
    
    var body: some View {
        if isHighlighted {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
        } else {
            Circle()
                .fill(Color.blue)
                .frame(width: 10, height: 10)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}






/*
struct CustomerMapPin_Previews: PreviewProvider {
    static var previews: some View {
        CustomerMapPin()
    }
}
*/
