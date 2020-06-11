import UIKit
import SwiftUI
import PlaygroundSupport




struct ContentView: View {
    var body: some View {
        Text("SwiftUI in a Playground!")
}
}

class WaveAnimation
{
    var isAnimated = false
    let universalSize = UIScreen.main.bounds
    
    func Wave(interval: CGFloat, amplitude: CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height/2) -> Path
    {
        Path
            { path in
                path.move(to: CGPoint(x: 0, y: baseline))
                path.addCurve(
                    to: CGPoint(x: 1 * interval, y: baseline),
                    control1: CGPoint(x: interval * (0.35), y: amplitude + baseline),
                    control2: CGPoint(x: interval * (0.65), y: -amplitude + baseline))
                path.addCurve(
                    to: CGPoint(x: 2 * interval, y: baseline),
                    control1: CGPoint(x: interval * (1.35), y: amplitude + baseline),
                    control2: CGPoint(x: interval * (1.65), y: -amplitude + baseline))
                path.addLine(to: CGPoint(x: 2 * interval, y: UIScreen.main.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        }
    }
    
    func weakWave()
    {
        // background wave
        Wave(interval: universalSize.width, amplitude:100, baseline: universalSize.height/6)
            .foregroundColor(Color.init(red: 135/255, green: 140/255, blue: 140/255, opacity: 0.4))
            .offset(x: isAnimated ? -1 * universalSize.width : 0)
            .animation(Animation.linear(duration: 6)
            .repeatForever(autoreverses: false))
            
        // midground wave
        Wave(interval: universalSize.width * 2, amplitude: 80, baseline: universalSize.height/6)
            .foregroundColor(Color.init(red: 135/255, green: 140/255, blue: 140/255, opacity: 0.6))
            .offset(x: isAnimated ? -1 * (universalSize.width * 2) : 0)
            .animation(Animation.linear(duration: 4)
            .repeatForever(autoreverses: false))
            
        //foreground
        Wave(interval: universalSize.width * 4, amplitude: 60, baseline: 60 + universalSize.height/6)
            .foregroundColor(Color.init(red: 130/255, green: 140/255, blue: 140/255, opacity: 1))
            .offset(x: isAnimated ? -1 * (universalSize.width * 4) : 0)
            .animation(Animation.linear(duration: 4)
            .repeatForever(autoreverses: false))
    }
}

let test = WaveAnimation()
test.weakWave()
