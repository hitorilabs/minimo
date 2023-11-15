import SwiftUI
import ARKit

struct DataView: View {
    
    @State var blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber] = [
        // Eye
        .eyeBlinkLeft: 0,       .eyeBlinkRight: 0,
        .eyeLookUpLeft: 0,      .eyeLookUpRight: 0,
        .eyeLookDownLeft: 0,    .eyeLookDownRight: 0,
        .eyeLookInLeft: 0,      .eyeLookInRight: 0,
        .eyeLookOutLeft: 0,     .eyeLookOutRight: 0,
        .eyeSquintLeft: 0,      .eyeSquintRight: 0,
        .eyeWideLeft: 0,        .eyeWideRight: 0,
        
        // Brow
        .browInnerUp: 0,
        .browDownLeft: 0,       .browDownRight: 0,
        .browOuterUpLeft: 0,    .browOuterUpRight: 0,
        
        // Nose
        .noseSneerLeft: 0,      .noseSneerRight: 0,
        
        // Cheek
        .cheekPuff: 0,
        .cheekSquintLeft: 0,    .cheekSquintRight:0,
        
        // Jaw
        .jawForward: 0,
        .jawOpen: 0,
        .jawLeft: 0,            .jawRight: 0,
        
        // Mouth
        .mouthClose: 0,
        .mouthFunnel: 0,
        .mouthPucker: 0,
        .mouthLeft: 0,              .mouthRight: 0,
        .mouthSmileLeft: 0,         .mouthSmileRight: 0,
        .mouthFrownLeft: 0,         .mouthFrownRight: 0,
        .mouthDimpleLeft: 0,        .mouthDimpleRight: 0,
        .mouthStretchLeft: 0,       .mouthStretchRight: 0,
        .mouthRollLower: 0,         .mouthRollUpper: 0,
        .mouthShrugLower: 0,        .mouthShrugUpper: 0,
        .mouthPressLeft: 0,         .mouthPressRight: 0,
        .mouthLowerDownLeft: 0,     .mouthLowerDownRight: 0,
        .mouthUpperUpLeft: 0,       .mouthUpperUpRight: 0,
        
        // Tongue
        .tongueOut: 0,
    ]
    
    var arSessionManager = ARSessionManager();
    @State private var lastFaceAnchorData: String = "";
    
    var body: some View {
        VStack {
            Text("keys: \(blendShapes.count)")
            ScrollView {
                ForEach(Array(blendShapes.keys), id: \.self) { key in
                    HStack {
                        Text("\(key.rawValue)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .monospaced()
                        Text("\(String(format: "%.4f", blendShapes[key]!.floatValue))")
                            .monospaced()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
        .onAppear {
            arSessionManager.startFaceTracking()
        }
        .onReceive(arSessionManager.$lastFaceAnchor) { faceAnchor in
            for (location, value) in faceAnchor?.blendShapes ?? [:] {
                blendShapes[location] = value;
            }
        }
    }
}

class ARSessionManager: NSObject, ARSessionDelegate {
    @Published var lastFaceAnchor: ARFaceAnchor?;
    let session = ARSession();

    override init() {
        super.init()
        session.delegate = self
    }

    func startFaceTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking not supported on this device")
            return
        }

        let configuration = ARFaceTrackingConfiguration()
        
        // Configure additional settings if needed
        session.run(configuration)
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // Handle face tracking updates
        for anchor in anchors {
            if let faceAnchor = anchor as? ARFaceAnchor {
                // Process face tracking data
                // e.g., faceAnchor.blendShapes
                lastFaceAnchor = faceAnchor;
            }
        }
    }
}

#Preview {
    DataView()
}
