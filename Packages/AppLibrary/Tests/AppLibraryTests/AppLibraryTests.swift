import Foundation
@testable import Gateways
@testable import Models
import Testing

@MainActor
@Test func cryptoCurrenceDecoding() async throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    let data = Data(
        """
        {
            "symbol": "btcinr",
            "baseAsset": "btc",
            "quoteAsset": "inr",
            "openPrice": "5656600",
            "lowPrice": "5656600.0",
            "highPrice": "5656600.0",
            "lastPrice": "5656600.0",
            "volume": "0",
            "bidPrice": "0.0",
            "askPrice": "0.0",
            "at": 1726738206000
        }
        """.utf8
    )
    let result = try decoder.decode(WazirxTracker.CryptoUpdate.self, from: data)

    #expect(result.baseAsset == "btc")
    #expect(result.quoteAsset == "inr")
    #expect(result.lastPrice == "5656600.0")
}
