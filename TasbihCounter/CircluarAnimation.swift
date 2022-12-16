//
//  CircluarAnimation.swift
//  TasbihCounter
//
//  Created by Amini on 24/09/22.
//

import SwiftUI

struct CircluarAnimation: View {
    @State var moveCircle = false
    
    @State private var animated = [false, true, true, false]
    @State private var degrees = [-65.0, -45.0, 45.0, 65.0]
    
    var body: some View {
        ZStack {
            Circle()
                .stroke()
                .frame(width: 300, height: 300)
            
            Circle()
                .fill(.green)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    self.moveCircle.toggle()
                    let temp = degrees[3]
                    let tempAn = animated[3]
                    
                    animated.remove(at: 3)
                    animated.insert(tempAn, at: 0)
                    
                    degrees.remove(at: 3)
                    degrees.insert(temp, at: 0)
                    
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                }
            
            Circle()
                .fill(.yellow)
                .overlay(content: {
                    Text("0")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                })
                .offset(y: -150)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(degrees[0]))
                .animation( animated[0] ? .spring() : nil, value: degrees)

            
            Circle()
                .fill(.indigo)
                .overlay(content: {
                    Text("1")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                })
                .offset(y: -150)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(degrees[1]))
                .animation( animated[1] ? .spring() : nil, value: degrees)

            Circle()
                .fill(.mint)
                .overlay(content: {
                    Text("2")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                })

                .offset(y: -150)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(degrees[2]))
                .animation( animated[2] ? .spring() : nil, value: degrees)

            Circle()
                .fill(.orange)
                .overlay(content: {
                    Text("3")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                })
                .offset(y: -150)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(degrees[3]))
                .animation( animated[3] ? .spring() : nil, value: degrees)

            
        }
        .scaleEffect(1.5)
    }
}

struct CircularMove: Animatable, ViewModifier {
    var value: Double
    
    private let target: Double
    private let onEnded: () -> ()
    
    init(rotation degrees: Double, target: Double, onEnded: @escaping () -> Void) {
        self.value = degrees
        self.target = target
        self.onEnded = onEnded
    }
    
    var animatableData: CGFloat {
        get { value }
        set {
            print("value \(value)")
            print("newvalue \(newValue)")
            print("target \(target)")
            
            if value == target {
                value = 295
            }
            
            value = newValue
            
//            let callback = onEnded
//            if newValue == target {
//                DispatchQueue.main.async(execute: callback)
//            }
        }
    }
    
    func body(content: Content) -> some View {
        content.rotationEffect(Angle(degrees: value))
    }
}

struct CircluarAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircluarAnimation()
    }
}
