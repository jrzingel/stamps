//
//  Rev.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation
import CryptoKit

// Determine the revision (rev) of the current Stamp
// Use this to compare if it should update in CouchDB

/// Convert the string to a MD5 hash
func MD5(data: Data) -> String {
    let digest = Insecure.MD5.hash(data: data) //Data(string.utf8))
    
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

/// Calculate the current stamp revision for version comparing.
/// - Important: the rawstamp should never contain `_rev` to avoid circular updates
func revision(stamp: RawStamp) -> String {
    do {
        let encoded = try JSONEncoder().encode(stamp)
        print(String(data: encoded, encoding: .utf8) ?? "unknown")
        return MD5(data: encoded)
    } catch {
        Logger.api.error("Cannot create revision \(error)")
    }
    return ""
}

