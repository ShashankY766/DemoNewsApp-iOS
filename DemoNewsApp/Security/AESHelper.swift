//
//  AESHelper.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 27/12/25.
//

import Foundation
import CommonCrypto

/// AES-256 encryption helper
final class AESHelper {

    static func encrypt(text: String, key: String) -> String? {
        let data = Data(text.utf8)
        let keyData = Data(key.utf8)

        // Ensure key is 32 bytes for AES-256. If not, derive or pad/truncate deterministically.
        // Here we simply pad/truncate UTF-8 bytes to 32 bytes for demo purposes.
        var normalizedKey = Data(count: kCCKeySizeAES256)
        normalizedKey.withUnsafeMutableBytes { dst in
            let dstPtr = dst.bindMemory(to: UInt8.self).baseAddress!
            // Zero-fill first
            memset(dstPtr, 0, kCCKeySizeAES256)
            keyData.withUnsafeBytes { src in
                let srcPtr = src.bindMemory(to: UInt8.self).baseAddress!
                let count = min(keyData.count, kCCKeySizeAES256)
                if count > 0 {
                    memcpy(dstPtr, srcPtr, count)
                }
            }
        }

        // Prepare output buffer using Data to avoid overlapping access issues.
        var outLength: size_t = 0
        var outData = Data(count: data.count + kCCBlockSizeAES128)
        let outCapacity = outData.count

        let status: CCCryptorStatus = outData.withUnsafeMutableBytes { outBytes in
            data.withUnsafeBytes { inBytes in
                normalizedKey.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress,
                        kCCKeySizeAES256,
                        nil, // IV is nil for ECB-like behavior; consider providing an IV for CBC.
                        inBytes.baseAddress,
                        data.count,
                        outBytes.baseAddress,
                        outCapacity,
                        &outLength
                    )
                }
            }
        }

        guard status == kCCSuccess else { return nil }

        // Trim output buffer to the actual number of bytes written and return Base64.
        outData.count = outLength
        return outData.base64EncodedString()
    }
}

