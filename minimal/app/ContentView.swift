import Foundation
import SwiftUI
import Network
import ARKit


struct ContentView: View {
    
    @State var address: String = "127.0.0.1";
    @State var port: String = "25565";
    @ObservedObject var delegate: ARDelegate = ARDelegate(client: UDPClient(address: "127.0.0.1", port: "25565")!)
    
    var body: some View {
        ARViewRepresentable(arDelegate: delegate)
        TextField("ip_address", text: $address)
            .onSubmit {
                delegate.client = UDPClient(address: address, port: port)!
            }
        TextField("port", text: $port)
            .onSubmit {
                delegate.client = UDPClient(address: address, port: port)!
            }
    };
    
}

struct ARViewRepresentable: UIViewRepresentable {
    let arDelegate:ARDelegate
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARSCNView(frame: .zero)
        arDelegate.setARView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
