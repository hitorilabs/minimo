import SwiftUI
import ARKit
import Network

@main
struct ar: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var address = "10.0.0.1"
    @State private var port = "25565"
    
    var body: some View {
        VStack {
            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Port", text: $port)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            ARFaceTrackingView(viewModel: ARFaceTrackingViewModel(address: address, port: port))
        }
    }
}

struct ARFaceTrackingView: View {
    @ObservedObject var viewModel: ARFaceTrackingViewModel
    
    var body: some View {
        Text("ARFaceTrackingView")
            .onAppear {
                self.viewModel.arSession.run(ARFaceTrackingConfiguration(), options: [.removeExistingAnchors, .resetTracking])
            }
            .onDisappear {
                self.viewModel.arSession.pause()
            }
    }
}

class ARSessionDelegateWrapper: NSObject, ARSessionDelegate {
    var didUpdate: ((ARSession, [ARAnchor]) -> Void)?
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        didUpdate?(session, anchors)
    }
}

class ARFaceTrackingViewModel: ObservableObject {
    let arSession = ARSession()
    let arSessionDelegate = ARSessionDelegateWrapper()
    let client: UDPClient
    
    @Published var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:]
    
    init(address: String, port: String) {
        // Create UDP socket
        self.client = UDPClient(address: address, port: port)!
        
        // Set up AR session
        arSession.delegate = arSessionDelegate
        let configuration = ARFaceTrackingConfiguration()
        arSession.run(configuration, options: [.removeExistingAnchors, .resetTracking])
        
        // Set up AR session delegate
        arSessionDelegate.didUpdate = { [weak self] session, anchors in
            if let faceAnchor = anchors.first as? ARFaceAnchor {
                self?.blendShapes = faceAnchor.blendShapes
                        
                let blendShapeData = zip(faceAnchor.blendShapes.keys, faceAnchor.blendShapes.values)
                    .reduce(String()) {
                        (out, data) in out + "\(data.0.rawValue):\(data.1);"
                    }
                    .data(using: .utf8)!
                print(blendShapeData)
                self?.client.send(blendShapeData)
            }
        }
    }
}
