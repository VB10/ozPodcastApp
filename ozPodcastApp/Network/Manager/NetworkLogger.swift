//
//  NetworkLogger.swift
//  ozPodcastApp
//
//  Created by Mert Saygılı on 27.10.2024.
//

/// NetworkLogger.swift
/// A utility class for detailed network request and response logging in Alamofire networking.
/// Created by Mert Saygılı on 23.10.2024.

import Foundation
import Alamofire

/// A singleton class responsible for logging network requests and responses with detailed formatting.
/// Provides comprehensive logging of HTTP requests, responses, headers, and bodies.
final class NetworkLogger {
    /// Shared singleton instance
    static let shared = NetworkLogger()
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// DateFormatter instance configured for logging timestamps
    /// Format: "yyyy-MM-dd HH:mm:ss.SSS"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

extension NetworkLogger {
    /// Logs the details of an HTTP request
    /// - Parameter request: The URLRequest to be logged
    /// - Note: Logs include URL, HTTP method, headers, and request body if present
    func logRequest(_ request: URLRequest) {
        let timestamp = dateFormatter.string(from: Date())
        
        var log = """
        ⬆️ REQUEST [\(timestamp)]
        ======================================
        URL: \(request.url?.absoluteString ?? "")
        METHOD: \(request.httpMethod ?? "")
        """
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            log += "\n\nHEADERS:"
            headers.forEach { log += "\n- \($0.key): \($0.value)" }
        }
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            log += "\n\nBODY:\n\(prettyPrintJSON(bodyString))"
        }
        
        log += "\n======================================"
        LoggerManager.shared.log(log, level: .info)
    }
    
    /// Logs the details of an HTTP response
    /// - Parameter response: The AFDataResponse object containing response details
    /// - Note: Logs include status code, duration, headers, response body, and any errors
    func logResponse(_ response: AFDataResponse<Data?>) {
        let timestamp = dateFormatter.string(from: Date())
        let statusCode = response.response?.statusCode ?? 0
        
        var log = """
        ⬇️ RESPONSE [\(timestamp)]
        ======================================
        URL: \(response.request?.url?.absoluteString ?? "")
        STATUS: \(statusCode)
        DURATION: \(String(format: "%.2f", response.metrics?.taskInterval.duration ?? 0))s
        """
        
        if let headers = response.response?.allHeaderFields as? [String: Any], !headers.isEmpty {
            log += "\n\nHEADERS:"
            headers.forEach { log += "\n- \($0.key): \($0.value)" }
        }
        
        if let data = response.data,
           let responseString = String(data: data, encoding: .utf8) {
            log += "\n\nRESPONSE BODY:\n\(prettyPrintJSON(responseString))"
        }
        
        if let error = response.error {
            log += "\n\nERROR:\n\(error.localizedDescription)"
        }
        
        log += "\n======================================"
        LoggerManager.shared.log(log, level: .info)
    }
    
    /// Formats a JSON string into a more readable format
    /// - Parameter jsonString: The raw JSON string to be formatted
    /// - Returns: A pretty-printed JSON string, or the original string if formatting fails
    private func prettyPrintJSON(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return jsonString
        }
        return prettyString
    }
}

/// A class that implements Alamofire's EventMonitor protocol to automatically log network requests and responses
/// Integrates with NetworkLogger to provide detailed logging of all network activities
final class NetworkEventMonitor: EventMonitor {
    /// Called when a request starts
    /// - Parameter request: The Alamofire Request that just started
    /// - Note: Automatically logs the request details using NetworkLogger
    func requestDidResume(_ request: Request) {
        NetworkLogger.shared.logRequest(request.request ?? URLRequest(url: URL(string: "invalid")!))
    }
    
    /// Called when a response is received and parsed
    /// - Parameters:
    ///   - request: The DataRequest that received the response
    ///   - response: The parsed response data
    /// - Note: Automatically logs the response details using NetworkLogger
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        if let responseData = response.data {
            let dataResponse = AFDataResponse<Data?>(
                request: response.request,
                response: response.response,
                data: responseData,
                metrics: response.metrics,
                serializationDuration: response.serializationDuration,
                result: .success(responseData)
            )
            NetworkLogger.shared.logResponse(dataResponse)
        }
    }
}
