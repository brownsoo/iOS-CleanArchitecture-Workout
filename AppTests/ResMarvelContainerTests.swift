//
//  KisTestTests.swift
//  KisTestTests
//
//  Created by hyonsoo on 2023/08/24.
//

import XCTest
@testable import App

final class ResMarvelContainerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPage() throws {
        var res = ResMarvelContainer(offset: 0, limit: 10, total: 0, count: 0, results: [""])
        XCTAssertEqual(1, res.getPage())
        
        res.total = 10
        XCTAssertEqual(1, res.getPage())
        
        res.offset = 10
        res.total = 10
        XCTAssertEqual(2, res.getPage())
        
        res.offset = 17
        res.total = 100
        XCTAssertEqual(2, res.getPage())
        
    }
    
    func testGetTotaPages() throws {
        var res = ResMarvelContainer(offset: 0, limit: 10, total: 0, count: 0, results: [""])
        XCTAssertEqual(0, res.getTotalPages())
        
        res.total = 10
        res.limit = 10
        XCTAssertEqual(1, res.getTotalPages())
        
        res.total = 15
        res.limit = 10
        XCTAssertEqual(2, res.getTotalPages())
        
        res.total = 22
        res.limit = 10
        XCTAssertEqual(3, res.getTotalPages())
        
    }

}
