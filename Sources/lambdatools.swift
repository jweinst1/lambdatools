struct lambdatools {

    //iterator for chars in a string
    struct StrIter {
        
        let string:String
        var current:String.Index
        
        init(string:String) {
            self.string = string
            self.current = self.string.endIndex
        }
        
        mutating func next() -> Character? {
            if self.current != self.string.startIndex {
                let returned = self.string[self.current]
                self.current = self.string.index(before: self.current)
                return returned
            }
            else {
                return nil
            }
        }
    }
    
    //new types to signify states of the machine
    enum pState {
        case int
        case end
    }
    
    struct CharSets {
        static let ints:Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        static let opers:Set<Character> = ["+", "-", "*", "/", "%"]
    }
    
    //used for linking lambdas together
    enum MathLambda {
        indirect case l(((Int) -> Int), MathLambda)
        case end
    }
    //produces the capturing lambda used for math operations
    static func makeLambda(type:Character, arg:Int) -> ((Int) -> Int) {
        switch type {
        case "+":
            return {(num) in return num + arg}
        case "-":
            return {(num) in return num - arg}
        case "*":
            return {(num) in return num * arg}
        case "/":
            return {(num) in return num - arg}
        case "%":
            return {(num) in return num % arg}
        default:
            return {(num) in return num}
        }
    }
    
    //creates a closure from a string input
    class mathClosure {
        
        var mode:pState
        var intlst:[Character]
        var op:Character
        var opc:Int
        
        init(){
            self.mode = pState.int
            self.intlst = [Character]()
            self.op = "\0"
            self.opc = 0
        }
        
        func getInt() -> Int {
            return Int(String(self.intlst))!
        }
        
        func clearAll() {
            self.intlst = [Character]()
            self.op = "\0"
            self.opc = 0
        }
        
        func create(input:String) -> MathLambda {
            var code = StrIter(string:input)
            var lambda = MathLambda.end
            while self.mode != pState.end {
                let nchar = code.next()
                if nchar != nil {
                    switch self.mode {
                    case .int:
                        if CharSets.ints.contains(nchar!){
                            self.intlst.insert(nchar!, at: 0)
                        }
                        else if CharSets.opers.contains(nchar!){
                            self.op = nchar!
                            lambda = MathLambda.l(makeLambda(type: self.op, arg: self.getInt()), lambda)
                            self.clearAll()
                        }
                    case .end:
                        break
                    }
                }
            }
            return lambda
        }
        
    }
    
    //top level function to compile strings into lambda calculus
    static func compileLambda(input:String) -> ((inout Int)-> Void) {
        let mach = mathClosure()
        let lnklst = mach.create(input: input)
        var pnter = lnklst
        return {( arg:inout Int) in
            var mode = true
            while mode {
                switch pnter {
                case .l(let fnc, let next):
                    arg = fnc(arg)
                    pnter = next
                case .end:
                    mode = false
                }
            }
        }
    }
}
