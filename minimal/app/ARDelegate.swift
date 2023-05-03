import Foundation
import ARKit

class ARDelegate: NSObject, ARSCNViewDelegate, ObservableObject {
    
    @Published var client: UDPClient
    
    init(client: UDPClient) {
        self.client = client
    }
    
    func setARView(_ arView: ARSCNView) {
        self.arView = arView
        
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        arView.delegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        let blendShapes = faceAnchor.blendShapes
        let blendShapeData = try? JSONSerialization.data(withJSONObject: blendShapes)
        self.client.send(blendShapeData!)
    }
    
    // MARK: - Private

    private var arView: ARSCNView?
}
