//
//  PhotoListViewModelTests.swift
//  Unsplash_ProjectTests
//
//  Created by 최형민 on 2023/02/16.
//

import XCTest
import RxSwift
import RxCocoa
@testable import Unsplash_Project

class PhotoListViewModelTests: XCTestCase {

    var viewModel: PhotoListViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        viewModel = PhotoListViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchPhotos() {
        let expectation = self.expectation(description: "Fetch photos successfully")
        let page = 1

        viewModel.fetchPhotos(page: page)
            .subscribe(onSuccess: { photos in
                XCTAssertGreaterThan(photos.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testTransform() {
        let expectation = self.expectation(description: "Transform input to output successfully")

        let input = PhotoListViewModel.Input(
            searchButtonTap: ControlEvent(events: Observable.just(()))
        )

        let output = viewModel.transform(input: input)

        let _ = output.photos.drive(onNext: { photos in
            XCTAssertGreaterThan(photos.count, 0)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)
    }
}

