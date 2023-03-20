import Reachability

protocol ConnectionStatusProtocol {
    func hasConnectivity() -> Bool 
}

final class ConnectionStatus: ConnectionStatusProtocol {
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            var isNetworkReachable = false
            if reachability.connection == .wifi || reachability.connection == .cellular {
                isNetworkReachable = true
            }
            return isNetworkReachable
        } catch {
            return false
        }
    }
}
