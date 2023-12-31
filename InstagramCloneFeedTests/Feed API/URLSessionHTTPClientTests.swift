//
//  URLSessionHTTPClientTests.swift
//  InstagramCloneFeedTests
//
//  Created by Pavel Palancica on 16.12.2023.
//

import XCTest
import InstagramCloneFeed

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    /*func test_getFromURL_performsGETRequestWithURLV1() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request completion")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in } // This cand cause a data race
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_performsGETRequestWithURLV2() {
        let url = anyURL()
        let exp1 = expectation(description: "Wait for request completion 1")
        let exp2 = expectation(description: "Wait for request completion 2")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp1.fulfill()
        }
        
        makeSUT().get(from: url) { _ in exp2.fulfill() }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func test_getFromURL_performsGETRequestWithURLV3() {
        let url = anyURL()
        var receivedRequests: [URLRequest] = []
        
        URLProtocolStub.observeRequests { request in
            receivedRequests.append(request)
        }
        
        let exp = expectation(description: "Wait for request completion")
        makeSUT().get(from: url) { _ in exp.fulfill() }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedRequests.count, 1)
        XCTAssertEqual(receivedRequests.first?.url, url)
        XCTAssertEqual(receivedRequests.first?.httpMethod, "GET")
    }*/
    
    func test_getFromURL_performsGETRequestWithURLV4() {
        let url = anyURL()
        var receivedRequests: [URLRequest] = []
        
        URLProtocolStub.observeRequests { request in
            receivedRequests.append(request)
        }
        
        let exp = expectation(description: "Wait for request completion")
        makeSUT().get(from: url) { _ in exp.fulfill() }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedRequests.count, 1)
        XCTAssertEqual(receivedRequests.first?.url, url)
        XCTAssertEqual(receivedRequests.first?.httpMethod, "GET")
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as NSError?
        // Simply checking for equality on receivedError and error - won't work
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        //XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    // Delivered empty data and response on successful HTTP response with nil data since the URL Loading System completes the request with a non-nil empty data value (0 bytes) which is a valid case (e.g. HTTP 204 no content response)
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: nil, response: response, error: nil)
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, // #filePath
                         line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultValuesFor(data: Data?,
                                 response: URLResponse?,
                                 error: Error?,
                                 file: StaticString = #file, // #filePath
                                 line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        
        let result = resultFor(data: data,
                               response: response,
                               error: error,
                               file: file,
                               line: line)
        switch result {
            case let .success(data, response):
                return (data, response)
            default:
                XCTFail("Expected success, got \(result) instead", file: file, line: line)
                return nil
        }
    }
    
    private func resultErrorFor(data: Data?,
                                response: URLResponse?,
                                error: Error?,
                                file: StaticString = #file, // #filePath
                                line: UInt = #line) -> Error? {
        
        let result = resultFor(data: data,
                               response: response,
                               error: error,
                               file: file,
                               line: line)
        switch result {
            case let .failure(error):
                return error
            default:
                XCTFail("Expected failure, got \(result) instead", file: file, line: line)
                return nil
        }
    }
    
    private func resultFor(data: Data?,
                           response: URLResponse?,
                           error: Error?,
                           file: StaticString = #file, // #filePath
                           line: UInt = #line) -> HTTPClientResult {
        
        URLProtocolStub.stub(data: data,
                             response: response,
                             error: error)
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        var receivedResult: HTTPClientResult!
        
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResult
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(),
                               statusCode: 200,
                               httpVersion: nil,
                               headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(),
                           mimeType: nil,
                           expectedContentLength: 0,
                           textEncodingName: nil)
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?,
                         response: URLResponse?,
                         error: Error?) {
            stub = Stub(data: data,
                        response: response,
                        error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            // guard let url = request.url else { return false }
            // return URLProtocolStub.stubs[url] != nil
            // requestObserver?(request) // Removed in Video 16 at 7:20
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            // Added in Video 16 at 7:30
            // NOTE: This fixes the data race problem universally
            // Finish URL loading when observing requests to make sure all URL requests are finished before the test method returns. This way, we prevent data races with threads living longer than the test method that initiated them
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}

// We don't want Thread Sanitezer enabled all the times. But we can keep it in CI scheme.
// That way we can prevent data races before merging to main.
