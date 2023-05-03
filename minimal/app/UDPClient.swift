import Network
import Foundation

class UDPClient {
    
    var connection: NWConnection
    var address: NWEndpoint.Host
    var port: NWEndpoint.Port
    
    var resultHandler = NWConnection.SendCompletion.contentProcessed { NWError in
        guard NWError == nil else {
            print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            return
        }
    }

    init?(address newAddress: String, port newPort: String) {
        guard let codedAddress = IPv4Address(newAddress) ?? IPv4Address("127.0.0.1"),
            let codedPort = NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(Int32(newPort) ?? 25565)) else {
                print("Failed to create connection address")
                return nil
        }
        address = .ipv4(codedAddress)
        port = codedPort
        
        connection = NWConnection(host: address, port: port, using: .udp)
        connection.stateUpdateHandler = { newState in
            switch (newState) {
            case .ready:
                print("State: Ready")
                return
            case .setup:
                print("State: Setup")
            case .cancelled:
                print("State: Cancelled")
            case .preparing:
                print("State: Preparing")
            default:
                print("ERROR! State not defined!\n")
            }
        }
        connection.start(queue: .global())
    }
    
    deinit {
        connection.cancel()
    }
    
    func send(_ data: Data) {
        self.connection.send(content: data, completion: self.resultHandler)
    }
}
