//
//  Unsplash_ProjectTests.swift
//  Unsplash_ProjectTests
//
//  Created by 최형민 on 2023/02/16.
//

import XCTest
import RxSwift
import RxCocoa
@testable import Unsplash_Project

class PhotoSearchViewModelTests: XCTestCase {
    
    var viewModel: PhotoSearchViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        viewModel = PhotoSearchViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testFetchSearchedPhotos() {
        let expectation = self.expectation(description: "Fetch searched photos successfully")
        let query = "cat"
        let page = 1
        
        viewModel.fetchSearchedPhotos(query: query, page: page)
        
        viewModel.photos.subscribe(onNext: { photos in
            XCTAssertGreaterThan(photos.count, 0)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}

