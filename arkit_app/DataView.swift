import SwiftUI
import ARKit

@Observable class BlendShapeFeature: Identifiable {
    var value: NSNumber = 0;
}

struct DataView: View {
    var arSessionManager = ARSessionManager();
    @State private var blendShapes: [ARFaceAnchor.BlendShapeLocation: BlendShapeFeature] = Dictionary(
        uniqueKeysWithValues: [
            // Eye
            .eyeBlinkLeft,       .eyeBlinkRight,
            .eyeLookUpLeft,      .eyeLookUpRight,
            .eyeLookDownLeft,    .eyeLookDownRight,
            .eyeLookInLeft,      .eyeLookInRight,
            .eyeLookOutLeft,     .eyeLookOutRight,
            .eyeSquintLeft,      .eyeSquintRight,
            .eyeWideLeft,        .eyeWideRight,
            
            // Brow
            .browInnerUp,
            .browDownLeft,       .browDownRight,
            .browOuterUpLeft,    .browOuterUpRight,
            
            // Nose
            .noseSneerLeft,      .noseSneerRight,
            
            // Cheek
            .cheekPuff,
            .cheekSquintLeft,    .cheekSquintRight,
            
            // Jaw
            .jawForward,
            .jawOpen,
            .jawLeft,            .jawRight,
            
            // Mouth
            .mouthClose,
            .mouthFunnel,
            .mouthPucker,
            .mouthLeft,              .mouthRight,
            .mouthSmileLeft,         .mouthSmileRight,
            .mouthFrownLeft,         .mouthFrownRight,
            .mouthDimpleLeft,        .mouthDimpleRight,
            .mouthStretchLeft,       .mouthStretchRight,
            .mouthRollLower,         .mouthRollUpper,
            .mouthShrugLower,        .mouthShrugUpper,
            .mouthPressLeft,         .mouthPressRight,
            .mouthLowerDownLeft,     .mouthLowerDownRight,
            .mouthUpperUpLeft,       .mouthUpperUpRight,
            
            // Tongue
            .tongueOut,
        ].map { (key: $0, value: BlendShapeFeature()) });
    
    var body: some View {
        VStack {
            HStack {
                Text("keys: \(blendShapes.count)")
            }
            ScrollView {
                ForEach(Array(blendShapes.keys), id: \.self) { key in
                    HStack {
                        Text("\(key.rawValue)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .monospaced()
                        Text("\(String(format: "%.4f", blendShapes[key]!.value.floatValue))")
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
                blendShapes[location]?.value = value;
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
                lastFaceAnchor = faceAnchor;
            }
        }
    }
}

#Preview {
    DataView()
}

