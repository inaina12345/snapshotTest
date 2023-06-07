//
//  TestAppTests.swift
//  TestAppTests
//
//  Created by mac on 2021/05/18.
//

import XCTest
@testable import TestApp

class TestAppTests: XCTestCase {

    let view = ViewController()
         
    func testTestMethod() {
        view.flag = true
        view.testMethod()
    }
    
    func testExample() throws {

    }
    
}

import SnapshotTesting
import XCTest

class MyViewControllerTests: XCTestCase {
    
    func testMyViewController() {
        let vc: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//        isRecording = true
        assertSnapshot(matching: vc, as: .image)
    }
}
