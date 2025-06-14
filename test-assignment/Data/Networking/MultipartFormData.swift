//
//  MultipartFormData.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import Foundation

/// Helper for building multipart/form-data bodies.
struct MultipartFormData {
    /// Boundary string to separate parts
    let boundary: String

    /// Internal storage of body parts
    private var parts = Data()

    /// Content-Type header value
    var contentType: String { "multipart/form-data; boundary=\(boundary)" }

    init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
        self.parts = Data()
    }

    /// Append a simple text field
    @discardableResult
    mutating func appendField(name: String, value: String) -> Self {
        parts.append("--\(boundary)\r\n")
        parts.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        parts.append("\(value)\r\n")
        return self
    }

    /// Append a file (e.g. image) field
    @discardableResult
    mutating func appendFile(
        name: String,
        fileName: String,
        mimeType: String,
        fileData: Data
    ) -> Self {
        parts.append("--\(boundary)\r\n")
        parts.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        parts.append("Content-Type: \(mimeType)\r\n\r\n")
        parts.append(fileData)
        parts.append("\r\n")
        return self
    }

    /// Finalize and return the complete httpBody data
    func finalize() -> Data {
        var data = parts
        data.append("--\(boundary)--\r\n")
        return data
    }
}

extension Data {
    /// Append a string to Data using UTF-8 encoding
    mutating func append(_ string: String) {
        if let d = string.data(using: .utf8) {
            append(d)
        }
    }
}
