#lambdatools

A swift package for compiling arithmetic lambdas into functions in swift.

###Installation

`lambdatools` is available under the swift package manager, newly released with Swift 3. To use it in your own swift package, 
in your Package.swift document, under your dependencies list put:

```
.Package(url: "https://github.com/jweinst1/lambdatools.git",
                 majorVersion: 1),
```

###Usage

In a swift file of your choice, you can use lambdatools like this:

```
import lambdatools

let fnc = lambdatools.compileLambda("-6*2+5")
print(fnc(10))
```

This example will print 13.