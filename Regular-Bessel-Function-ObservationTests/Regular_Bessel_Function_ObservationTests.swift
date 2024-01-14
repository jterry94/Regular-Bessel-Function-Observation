//
//  Regular_Bessel_Function_ObservationTests.swift
//  Regular-Bessel-Function-ObservationTests
//
//  Created by Jeff_Terry on 1/13/24.
//

import XCTest

final class Regular_Bessel_Function_ObservationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testCircleArea() async {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let myBessel = BesselFunctionCalculator()
        
        let result = await myBessel.calculateDownwardRecursion(xValue: 3.0 , order: 5, start: 43)
        
        let realAnswer = 0.0430284348770475839249112604629862213884896809211161691972
        
        XCTAssertEqual(result.besselValue, realAnswer, accuracy: 1.0E-7, "Was not equal to this resolution.")
        
        
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
