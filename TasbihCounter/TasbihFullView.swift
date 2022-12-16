//
//  TasbihFullView.swift
//  TasbihCounter
//
//  Created by Amini on 24/09/22.
//

import SwiftUI

struct TasbihFullView: View {
    
    @StateObject var tm = TasbeehModel()
    
    var body: some View {
        VStack(spacing: 40) {
            
            SliderPicker(tm: tm)
                .padding()
                .padding(.bottom, 60)
            
            HStack(spacing: 30){
                Button {
                    tm.selectedDesignType = .half
                } label: {
                    Circle()
                        .trim(from: 0.0, to: 0.50)
                        .stroke(tm.selectedDesignType == .half ? .white : .cyan, lineWidth: 3)
                        .frame(width: 24, height: 24)
                        .rotationEffect(Angle(degrees: 180))
                        .background {
                            Circle()
                                .fill( tm.selectedDesignType == .half ? .cyan : .clear)
                                .scaleEffect(1.5)
                        }
                }
                
                Button {
                    tm.selectedDesignType = .circle
                } label: {
                    Image(systemName: "circle.hexagonpath")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(tm.selectedDesignType == .circle ? .white : .cyan)
                        .frame(width: 24, height: 24)
                        .background {
                            Circle()
                                .fill( tm.selectedDesignType == .circle ? .cyan : .clear)
                                .scaleEffect(1.5)
                        }

                }
                
                Button {
                    tm.selectedDesignType = .progress
                } label: {
                    Image(systemName: "123.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(tm.selectedDesignType == .progress ? .white : .cyan)
                        .frame(width: 24, height: 24)
                        .background {
                            Circle()
                                .fill( tm.selectedDesignType == .progress ? .cyan : .clear)
                                .scaleEffect(1.5)
                        }

                }
                Spacer()
                Button {
                    reset()
                } label: {
                    Text("reset")
                }
            }
            .padding()
            
            switch tm.selectedDesignType {
            case .half:
                TasbeehHalfCircle()
                TasbeehDesignPicker()
            case .circle:
                TasbeehFullCircle()
                TasbeehDesignPicker()
            case .progress:
                TasbeehCircleProgress()
            }
                        
        }
    }
    
    @ViewBuilder
    func TasbeehCircleProgress() -> some View {
        ZStack {
            Circle()
                .fill(.mint)
                .frame(width: 360, height: 360)
            
            Circle()
                .trim(from: 0.0,
                      to: progress())
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
            
            Text("\(tm.counter)/\(tm.selectedTasbeehType.count)")
        }
        .onTapGesture {
            counting()
        }
    }
    
    @ViewBuilder
    func TasbeehFullCircle() -> some View {
        ZStack {
            Circle()
                .stroke()
                .frame(width: tm.tasbeehRadius,
                       height: tm.tasbeehRadius)
            
            Text("\(tm.counter)/\(tm.selectedTasbeehType.count)")
                .font(.largeTitle.bold())
                .background {
                    Circle()
                        .fill(.cyan)
                        .frame(width: tm.tasbeehRadius/2,
                               height: tm.tasbeehRadius/2)
                }
                .onTapGesture {
                    withAnimation {
                        
                        tm.tasbeeh = tm.tasbeeh.enumerated().map {
                            (index, tasbee_) in
                            var tabsee = tasbee_
                            
                            if index == tm.tasbeeh.count - (tm.currentBallIndex+1) {
                                tabsee.degrees = tabsee.degrees + 50
                            } else {
                                tabsee.degrees = tabsee.degrees + tm.degreeOfBall()
                            }
                        
                            return tabsee
                        }
                        
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        
                        counting()
                    }
                }

            if tm.tasbeeh.count > 0 {
                ForEach(0..<tm.numberOfBiji(), id: \.self) { index in
                    Image("\(tm.tasbeeh[index].image)")
                        .resizable()
                        .frame(width:tm.radiusOfBall(),
                               height: tm.heightOfBall(index))
                    
                        .aspectRatio(contentMode: .fit)
                        .offset(y: tm.offestOfBall(index))
                        .rotationEffect(.degrees(Double(tm.tasbeeh[index].degrees)))
                        .animation(.spring(), value: tm.tasbeeh)

                }
            }
        }


    }
    
    @ViewBuilder
    func TasbeehHalfCircle() -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke()
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: 180))
            
            Circle()
                .fill(.green)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    guard let temp: Double = tm.degrees.last,
                          let tempAn: Bool = tm.animated.last //[tm.degrees.count - 1]
                    else { return }
                    
                    tm.animated.removeLast()
                    tm.animated.insert(tempAn, at: 0)
                    
                    tm.degrees.removeLast()
                    tm.degrees.insert(temp, at: 0)
                    
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    counting()
                }
            
            ForEach(tm.degrees.indices, id: \.self) { index in
                Image(tm.selectedDesign.ball)
                    .resizable()
                    .offset(y: -150)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(tm.degrees[index]))
                    .animation(tm.animated[index] ? .spring() : nil, value: tm.degrees)
            }
            
        }
        .scaleEffect(1.5)
    }
    
    @ViewBuilder
    func TasbeehDesignPicker() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(ListOfTasbeehDesign, id: \.self) { design in
                    Image(design.ball)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            tm.selectedDesign = design
                        }
                }
            }
        }
        .frame(height: 100)
        .padding(.top, 50)
    }
    
    func counting() {
        if !tm.isCounterDone {
            if tm.tasbeeh[(tm.numberOfBiji()-1) - tm.currentBallIndex].isball {
                tm.counter += 1
            }
            tm.currentBallIndex += 1
        }
    }
    
    func reset() {
        tm.counter = 0
        tm.isCounterDone = false
        tm.generateTasbee()
        tm.currentBallIndex = 0
    }
    
    func progress() -> CGFloat {
        if tm.counter <= 0 {
            return 0.001
        }
        let progress: CGFloat = CGFloat(tm.counter) / CGFloat(tm.selectedTasbeehType.count)
        return progress
    }
}

struct SliderPicker: View {
    @State var offset: CGFloat = 0
    @ObservedObject var tm: TasbeehModel
    let selectorSize: CGFloat = 30
    
    @ViewBuilder
    func SelectorKnob(type: TasbeeType) -> some View {
        VStack {
            
            if type == .custom {
                TextField("", text: $tm.textInputCustom)
                    .textFieldStyle(.plain)
                    .font(.caption)
                    .multilineTextAlignment(TextAlignment.center)
                    .offset(y: 4)
                    .disabled(tm.selectedTasbeehType != .custom)
                    .keyboardType(.numberPad)
                
                Rectangle()
                    .frame(height: 1)
                    .offset(y: -4)
                
            } else {
                Text("\(type.count)")
                    .font(.caption)
            }
            
        }
        .offset(y: 30)
        .background {
            Circle()
                .fill(tm.selectedTasbeehType == type ? .cyan.opacity(1) : .cyan.opacity(0.2))
                .frame(width: selectorSize,
                       height: selectorSize)
        }
        .frame(width: selectorSize)
        .onTapGesture {
            
            tm.selectedTasbeehType = type
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            
            if let selectors = tm.spacingOfSelectors(width: geo.size.width, frame: selectorSize) {
                
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                    Capsule()
                        .fill(Color.black.opacity(0.2))
                        .frame(height: 20)
                    
                    HStack (spacing: selectors){
                        ForEach(TasbeeType.allCases, id: \.self) { type in
                            SelectorKnob(type: type)
                        }
                    }

                }
                .padding(.top, 33)
            } else {
                Text("I'm Sorry there is an error while generating tasbeeh")
            }
            
        }
    }
}

enum TasbeeType: CaseIterable {
    case seven
    case eleven
    case thirythree
    case nintynine
    case hundred
    case custom
    
    var count: Int {
        switch self {
        case .thirythree:
            return 33
        case .nintynine:
            return 99
        case .hundred:
            return 100
        case .eleven:
            return 11
        case .seven:
            return 7
        case .custom:
            return 0
        }
    }
    
    var separators: [Int] {
        switch self {
        case .thirythree, .eleven, .seven, .custom:
            return []
        case .hundred:
            return [33, 17, 10, 7, 33]
        case .nintynine:
            return [33, 33, 33]
        }
    }
}

enum TasbeehDesignType {
    case half
    case circle
    case progress
}

class TasbeehModel: ObservableObject {
    
    var tasbeeh: [Tasbeeh] = []
    
    @Published var animated = [false, true, true, true, true, false]
    @Published var degrees = [-85.0, -65.0, -45.0, 45.0, 65.0, 85.0]
        
    @Published var selectedDesign: TasbeehDesign = TasbeehDesign(ball: "ball", separator: "statue") {
        didSet {
            generateTasbee()
        }
    }
    @Published var biji: Int = 0
    @Published var tasbeehRadius = 360.0
    @Published var selectedTasbeehType: TasbeeType = .thirythree {
        didSet {
            generateTasbee()
        }
    }
    
    @Published var selectedDesignType: TasbeehDesignType = .circle
    
    @Published var textInputCustom: String = "0" {
        didSet {
            biji = Int(oldValue) ?? 0
        }
    }
    
    @Published var counter: Int = 0 {
        didSet {
            if counter == selectedTasbeehType.count {
                isCounterDone = true
            }
        }
    }
    
    @Published var currentBallIndex: Int = 0
    
    init() {
        generateTasbee()
    }
    
    let constant = 1.75
    
    func generateTasbee() {
        tasbeeh.removeAll()
        if selectedTasbeehType.separators.count != 0 {
            var indexDegree = 0
            for index in 0..<selectedTasbeehType.separators.count {
                tasbeeh.append(Tasbeeh(image: selectedDesign.separator,
                                       isball: false,
                                       degrees: Double(indexDegree) * degreeOfBall()))
                indexDegree += 1
                
                for _ in 0..<selectedTasbeehType.separators[index] {
                    tasbeeh.append(Tasbeeh(image: selectedDesign.ball,
                                           isball: true,
                                           degrees: Double(indexDegree) * degreeOfBall()))
                    indexDegree += 1
                }
            }
        } else {
            var indexDegree = 0
            for _ in 0..<selectedTasbeehType.count {
                tasbeeh.append(Tasbeeh(image: selectedDesign.ball,
                                       isball: true,
                                       degrees: Double(indexDegree) * degreeOfBall()))

                indexDegree += 1
                
            }
            print(tasbeeh.count)
        }
    }
    
    func numberOfBiji() -> Int {
        return selectedTasbeehType == .custom ? biji : selectedTasbeehType.separators.count + selectedTasbeehType.count
    }
    
    func radiusOfBall() -> Double {
        return (Double(Int(.pi*constant*(tasbeehRadius/2)) / numberOfBiji()))
    }
    
    func heightOfBall(_ index: Int) -> Double {
        return tasbeeh[index].isball ? radiusOfBall() : 2*radiusOfBall()
    }
    
    func offestOfBall(_ index: Int) -> Double {
        return  tasbeeh[index].isball ? -(tasbeehRadius/2) : -(tasbeehRadius/2 + radiusOfBall()/2)
    }
    
    func degreeOfBall() -> Double {
        return (Double(constant*180)/Double(numberOfBiji()))
    }
    
    var meter: Int {
        return TasbeeType.allCases.count
    }
    
    func spacingOfSelectors(width: CGFloat, frame size: CGFloat) -> CGFloat {
        return ((width - CGFloat((Int(size)*meter-1))) / CGFloat(meter-1))
    }
    
    @Published var isCounterDone: Bool = false
}

struct Tasbeeh: Equatable {
    var image: String
    var isball: Bool
    var degrees: Double
}

struct TasbeehDesign: Identifiable, Hashable {
    let id = UUID().uuidString
    let ball: String
    let separator: String
}

var ListOfTasbeehDesign = [
    TasbeehDesign(ball: "ball", separator: "statue"),
    TasbeehDesign(ball: "basket-ball", separator: "basketball"),
    TasbeehDesign(ball: "football", separator: "football-field"),
    TasbeehDesign(ball: "golf-ball-with-dents", separator: "golf")
]

struct TasbihView_Previews: PreviewProvider {
    static var previews: some View {
        TasbihFullView()
    }
}
