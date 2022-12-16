//
//  ContentView.swift
//  TasbihCounter
//
//  Created by Amini on 22/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                HalfCircle()
                    .stroke(.black, lineWidth: 2)
                    .frame(width: 150, height: 300)
//                    .background(.mint)
                    .onTapGesture {
                        withAnimation(.linear(duration: 1)) {
                            
                        }
                    }
                
            }
            .padding()
            
            Circle()
                .fill(.red)
                .frame(width: 20, height: 20)
                .position(CGPoint(x: 20, y: 20))
                .modifier(Moving(time: 1,
                                 path: HalfCircle().path(in: CGRect(x: 50,
                                                                    y: 50,
                                                                    width: 100,
                                                                    height: 300)),
                                 start: CGPoint(x: 0, y: 0)))
                .animation(.linear(duration: 2), value: 0)

            PathAnimatingView(path: HalfCircle().path(in: CGRect(x: 50,
                                                                 y: 50,
                                                                 width: 150,
                                                                 height: 300))) {
                Circle()
                    .fill(.yellow)
                    .frame(width: 20, height: 20)
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HalfCircle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
//        path.move(to: CGPoint(x: 0, y: 0.75*rect.height))
//        path.addLine(to: CGPoint(x: rect.width, y: 0.5*rect.height))
        
        path.addArc(center: CGPoint(x: rect.width, y: 0.75*rect.height),
                    radius: rect.width,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        return path
    }
}

struct Moving: AnimatableModifier {
    var time: CGFloat
    let path: Path
    let start: CGPoint
    
    var animatableData: CGFloat {
        get { time }
        set { time = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .position(
                path.trimmedPath(from: 0, to: time).currentPoint ?? start
            )
    }
    
}

func redCircleAnimation() {
    let startingPoint = CGPoint(x: 0.0, y: UIScreen.main.bounds.midY)
    
    //red view
    
    
    
    // the path
    let bezierPath = UIBezierPath()
    bezierPath.move(to: startingPoint)
    
    // Options
    // Curve
    bezierPath.addCurve(to: CGPoint(x: UIScreen.main.bounds.width,
                                    y: UIScreen.main.bounds.midY),
                        controlPoint1: CGPoint(x: UIScreen.main.bounds.midX,
                                               y: UIScreen.main.bounds.midY + 50.0),
                        controlPoint2: CGPoint(x: UIScreen.main.bounds.midX,
                                               y: UIScreen.main.bounds.midY - 50.0))
    
    bezierPath.addLine(to: CGPoint(x: UIScreen.main.bounds.width,
                                   y: 0.0))
    bezierPath.addLine(to: CGPoint(x: 0.0, y: 0.0))
    bezierPath.addLine(to: startingPoint)
    
    // the animation
    let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
    animation.path = bezierPath.cgPath
    animation.calculationMode = CAAnimationCalculationMode.paced
    animation.repeatCount = HUGE
    animation.duration = 5.0
    
    // The Layer
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = bezierPath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 1.0
    
}

struct PathAnimatingView<Content>: UIViewRepresentable where Content: View {
    
    let path: Path
    let content: () -> Content
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 2.0

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
            animation.duration = CFTimeInterval(3)
            animation.repeatCount = 3
            animation.path = path.cgPath
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: .linear)

        let sub = UIHostingController(rootView: content())
            sub.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(sub.view)
        sub.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sub.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.layer.add(animation, forKey: "someAnimationName")
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<PathAnimatingView>) {
        
    }
    
    typealias UIViewType = UIView
}
