//
//  ContentView.swift
//  tools
//
//  Created by jose juan alcantara rincon on 16/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var animate = false
    @State var endSplash = false
    
    var body: some View {
        ZStack{
            
            Calculator()
            
            ZStack{
                Color("b")
                Image("iconsmall")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 100, height: animate ? nil : 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaleEffect(animate ? 3 : 1)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            .opacity(endSplash ? 0 : 1)
        }
    }
    
    func animateSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            withAnimation(Animation.easeOut(duration: 0.45)){
                animate.toggle()
            }
            withAnimation(Animation.easeOut(duration: 0.35)){
                endSplash.toggle()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        Calculator()
    }
}

struct CalculationState {
    var currentNumber: String = "0"
    
    mutating func appendNumber(_ number: String){
        if(number == "." && !currentNumber.contains(".")){
            currentNumber += number
        }
        else if(currentNumber == "0" || currentNumber == "3.1416" || currentNumber == "2.718"){
            currentNumber = number
        }
        else if(number != "." && currentNumber != "0"){
            currentNumber += number
        }
    }
    
    mutating func cleanNumber(){
        currentNumber = "0"
    }
}

struct OperationState {
    var currentOperation: String = "0"
    
    var num1: String = "0"
    var num2: String = "0"
    var result: String = "0"
    
    mutating func operation(_ operation: String,_ num: String){
        currentOperation = operation
        num1 = num
    }
    
    mutating func makeOperation(_ num: String){
        num2 = num
        if (num1.contains(".") || num2.contains(".")) {
            switch currentOperation {
            case "+":
                result = String(format:"%.2f", Double(num1)! + Double(num2)!)
            case "-":
                result = String(format:"%.2f", Double(num1)! - Double(num2)!)
            case "x":
                result = String(format:"%.2f" ,Double(num1)! * Double(num2)!)
            case "/":
                if(num2 != "0"){
                    result = String(format:"%.2f" ,Double(num1)! / Double(num2)!)
                    
                }else{
                    result = "undefined"
                }
            default:
                result = "0"
            }
        }else{
            switch currentOperation {
            case "+":
                result = String(Int(num1)! + Int(num2)!)
            case "-":
                result = String(Int(num1)! - Int(num2)!)
            case "x":
                result = String(Int(num1)! * Int(num2)!)
            case "/":
                if(num2 != "0"){
                    result = String(format:"%.2f", Double(num1)! / Double(num2)!)
                    
                }else{
                    result = "undefined"
                }
            default:
                result = "0"
            }
        }
    }
    
    mutating func cleanOperation(){
        currentOperation = "0"
        num1 = "0"
        num2 = "0"
    }
}

struct Calculator: View {
    
    @State var state = CalculationState()
    @State var op = OperationState()
    
    var number:String {
        return state.currentNumber
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 20){
            Spacer()
            Text(number)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .lineLimit(3)
                .padding(.bottom, 64)
                .animation(.spring())
            
            HStack{
                Extra(extra: "e", state: $state)
                Spacer()
                Extra(extra: "pi", state: $state)
                Spacer()
                Extra(extra: "%", state: $state)
                Spacer()
                Operation(operation: "x", state: $state, op: $op)
            }
            
            HStack{
                Number(number: "7", state: $state)
                Spacer()
                Number(number: "8", state: $state)
                Spacer()
                Number(number: "9", state: $state)
                Spacer()
                Operation(operation: "/", state: $state, op: $op)
            }
            
            HStack{
                Number(number: "4", state: $state)
                Spacer()
                Number(number: "5", state: $state)
                Spacer()
                Number(number: "6", state: $state)
                Spacer()
                Operation(operation: "+", state: $state, op: $op)
            }
            
            HStack{
                Number(number: "1", state: $state)
                Spacer()
                Number(number: "2", state: $state)
                Spacer()
                Number(number: "3", state: $state)
                Spacer()
                Operation(operation: "-", state: $state, op: $op)
            }
            
            HStack{
                Clean(state: $state, op: $op)
                Spacer()
                Number(number: "0", state: $state)
                Spacer()
                Dot(state: $state)
                Spacer()
                Operation(operation: "=", state: $state, op: $op)
            }
        }.padding(32)
    }
}

struct Number: View {
    
    let number: String
    
    @Binding var state: CalculationState
    
    var numberString: String {
       return(number)
    }
    
    var body: some View{
        Text(numberString)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .background(Color.black)
            .cornerRadius(20)
            .shadow(color: .black, radius: 1, x: 0, y: 1)
            .onTapGesture {
                state.appendNumber(number)
            }
    }
}

struct Operation: View {
    let operation: String
    @Binding var state: CalculationState
    @Binding var op: OperationState
    
    var operationString: String{
        if (operation == "/") {
            return "÷"
        }
        return operation
    }
    
    var body: some View{
        Text(operationString)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(.black)
            .frame(width: 64, height: 64)
            .background(Color.white)
            .border(Color.black, width: 0.1)
            .cornerRadius(20)
            .shadow(color: .black, radius: 1, x: 0, y: 1)
            .onTapGesture {
                if(operation != "="){
                    if(state.currentNumber != "0"){
                        op.operation(operation, state.currentNumber)
                        state.cleanNumber()
                    }
                    if(state.currentNumber == "0"){
                        op.operation(operation, op.num1)
                    }
                }
                else if(operation == "="){
                    op.makeOperation(state.currentNumber)
                    state.currentNumber = op.result
                }
            }
        }
}

struct Extra: View {
    let extra: String
    
    @Binding var state: CalculationState
    
    var extraString: String {
        if(extra == "pi"){
            return "π"
        }
        return extra
    }
    var body: some View{
        Text(extraString)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .background(Color.gray)
            .border(Color.black, width: 0.1)
            .cornerRadius(20)
            .shadow(color: .black, radius: 1, x: 0, y: 1)
            .onTapGesture {
                if(extra == "pi"){
                    state.cleanNumber()
                    state.appendNumber("3.1416")
                }
                else if(extra == "e"){
                    state.cleanNumber()
                    state.appendNumber("2.718")
                }
                else if(extra == "%"){
                    state.currentNumber = String(Double(state.currentNumber)! / 100)
                }
            }
    }
}

struct Clean: View {
    @Binding var state: CalculationState
    @Binding var op: OperationState
    var body: some View{
        Text("CA")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .background(Color.red)
            .border(Color.black, width: 0.1)
            .cornerRadius(20)
            .shadow(color: .black, radius: 1, x: 0, y: 1)
            .onTapGesture {
                state.cleanNumber()
                op.cleanOperation()
            }
    }
}


struct Dot: View {
    @Binding var state: CalculationState
    var body: some View{
        Text(".")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .background(Color.black)
            .border(Color.black, width: 0.1)
            .cornerRadius(20)
            .shadow(color: .black, radius: 1, x: 0, y: 1)
            .onTapGesture {
                state.appendNumber(".")
            }
    }
}
