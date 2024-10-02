//
//  Base58.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/2.
//

import Foundation

struct Base58 {
    private static let base58Alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    
    static func decode(_ input: String) -> [UInt8]? {
        var result = [UInt8](repeating: 0, count: input.count)
        
        for char in input {
            guard let index = base58Alphabet.firstIndex(of: char) else {
                return nil
            }
            
            var carry = base58Alphabet.distance(from: base58Alphabet.startIndex, to: index)
            
            for j in 0..<result.count {
                carry += 58 * Int(result[j])
                result[j] = UInt8(carry % 256)
                carry /= 256
            }
            
            if carry != 0 {
                return nil // Output too big
            }
        }
        
        // Skip leading zeros
        var leadingZeroCount = 0
        for char in input {
            if char == base58Alphabet.first {
                leadingZeroCount += 1
            } else {
                break
            }
        }
        
        let decoded = result.reversed().drop { $0 == 0 }.map { $0 }
        return [UInt8](repeating: 0, count: leadingZeroCount) + decoded
    }
}
