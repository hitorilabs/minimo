import SwiftUI
import ARKit

struct ContentView: View {
    @State private var showIncompatibilityBanner =
        !ARFaceTrackingConfiguration.isSupported ||
        !ARBodyTrackingConfiguration.isSupported;
    @State var selectedPage = 1;
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            DataView()
            if showIncompatibilityBanner {
                BannerView(show: $showIncompatibilityBanner)
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: showIncompatibilityBanner)
            }

        }
    }
}

#Preview {
    ContentView()
}
