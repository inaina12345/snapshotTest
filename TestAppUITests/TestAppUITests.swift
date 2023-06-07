//
//  TestAppUITests.swift
//  TestAppUITests
//
//  Created by mac on 2023/06/01.
//

import XCTest
import SnapshotTesting


final class TestAppUITests: XCTestCase {

    override func setUpWithError() throws {
        
//        SnapshotTesting.diffTool = "compare"
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLandScape() throws {
        
        let app = XCUIApplication()
        app.launch()
                
        sleep(1)
        
        var device = XCUIDevice.shared.orientation
        device = .landscapeRight // device under test is set to landscapeLeft
        XCUIDevice.shared.orientation = device
        XCTAssertTrue(device.isLandscape) // tests if device is in portrait

        sleep(7)
        
//        let snapshotScreen = app.windows.firstMatch.screenshot().image
        guard let snapshotScreen = app.windows.firstMatch.screenshot().image.removingStatusBar else {
            return
        }
        assertSnapshot(matching: snapshotScreen, as: .image())
    }
    
    func testPortLait() throws {
        
        let app = XCUIApplication()
        app.launch()
        sleep(1)

        var device = XCUIDevice.shared.orientation
        device = .portrait // device under test is set to landscapeLeft
        XCUIDevice.shared.orientation = device
        
        sleep(5)
        guard let snapshotScreen = app.windows.firstMatch.screenshot().image.removingStatusBar else {
            return
        }
//        isRecording = true
        assertSnapshot(matching: snapshotScreen, as: .image())
    }
}

//
//  UIImage.swift
//  swift-2048UITests
//
//  Created by a.alterpesotskiy on 19/04/2019.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit
import XCTest

extension UIImage {
    
    
    
    var removingStatusBar: UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
    
        let scale = UIScreen.main.scale
        var yOffset: CGFloat = 0
        if (!UIDevice.current.isXFamily) {
            yOffset = 22 * scale
        } else if (UIDevice.current.isIPhoneX) {
            yOffset = 44 * scale
        } else if (UIDevice.current.isIPhoneX_Max || UIDevice.current.isIPhoneXR || UIDevice.current.isIPhone14_Pro) {
            yOffset = 48.6 * scale
        }
        let rect = CGRect(
            x: 0,
            y: Int(yOffset),
            width: cgImage.width,
            height: cgImage.height - Int(yOffset)
        )
        
        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }
        
        return nil
    }
    
    func fill(element: XCUIElement) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()!
        context.fill(
            CGRect(
                x: element.frame.minX,
                y: element.frame.minY,
                width: element.frame.size.width,
                height: element.frame.size.height
            )
        )
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return myImage!
    }
}

//
//  UIDevice.swift
//  swift-2048UITests
//
//  Created by a.alterpesotskiy on 19/04/2019.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import XCTest

extension UIDevice {
    
    enum UIDeviceModelType : Equatable {
        
        case iPhoneX
        case iPhoneXR
        case iPhoneX_Max
        case iPhone14_Pro
        case other(model: String)
        
        static func type(from model: String) -> UIDeviceModelType {
            switch model {
            case "iPhone10,3", "iPhone10,6", "iPhone11,2":
                return .iPhoneX
            case "iPhone11,4":
                return .iPhoneX_Max
            case "iPhone11,8":
                return .iPhoneXR
            case "iPhone15,2":
                return .iPhone14_Pro
            default:
                return .other(model: model)
            }
        }
        
        static func ==(lhs: UIDeviceModelType, rhs: UIDeviceModelType) -> Bool {
            switch (lhs, rhs) {
            case (.iPhoneX, .iPhoneX):
                return true
            case (.iPhoneX_Max, .iPhoneX_Max):
                return true
            case (.iPhoneXR, .iPhoneXR):
                return true
            case (.iPhone14_Pro, .iPhone14_Pro):
                return true
            case (.other(let modelOne), .other(let modelTwo)):
                return modelOne == modelTwo
            default:
                return false
            }
        }
    }
    
    var simulatorModel: String? {
        guard TARGET_OS_SIMULATOR != 0 else { return nil }
        return ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"]
    }
    
    var hardwareModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return model
    }
    
    var modelType: UIDeviceModelType {
        let model = self.simulatorModel ?? self.hardwareModel
        return UIDeviceModelType.type(from: model)
    }
    
    var isIPhoneX: Bool {
        return modelType == .iPhoneX
    }
    
    var isIPhoneXR: Bool {
        return modelType == .iPhoneXR
    }
    
    var isIPhoneX_Max: Bool {
        return modelType == .iPhoneX_Max
    }
    
    var isIPhone14_Pro: Bool {
        return modelType == .iPhone14_Pro
    }
    
    
    var isXFamily: Bool {
        return modelType == .iPhoneX_Max
            || modelType == .iPhoneX
            || modelType == .iPhoneXR
            || modelType == .iPhone14_Pro
    }

}
