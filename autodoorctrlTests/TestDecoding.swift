//
//  TestDecoding.swift
//  autodoorctrlTests
//
//  Created by Jing Wei Li on 11/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import XCTest
@testable import ADC

class TestDecoding: XCTestCase {
    let complaints = """
        [{"location":"test","message":"thisisatest"},{"location":"testing","message":"1234"}]
    """
    let doors = """
        [{"name":"ADC","location":"Amos Eaton South","latitude":"42.72990000","longitude":"-73.68250000","mac":"62:fe:50:80:12:6a"}, {"name":"SAGE_SOUTH","location":"Sage Front Door","latitude":"42.73076220","longitude":"-73.68167500","mac":"56:13:5a:fb:1c:30"}]
    """
    
    func testDecodingComplaints() {
        do {
            let complaints = try JSONDecoder().decode([ServicesAPI.ComplaintResponse].self, from: self.complaints.data(using: .utf8)!)
            guard complaints.count == 2 else {
                XCTFail("Array length is not 2 doors")
                return
            }
            
            let complaint1 = complaints[0]
            XCTAssertEqual(complaint1.location, "test")
            XCTAssertEqual(complaint1.message, "thisisatest")
            
            let complaint2 = complaints[1]
            XCTAssertEqual(complaint2.location, "testing")
            XCTAssertEqual(complaint2.message, "1234")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDecodingDoors() {
        do {
            let doors = try JSONDecoder().decode([DoorResponse].self, from: self.doors.data(using: .utf8)!)
            guard doors.count == 2 else {
                XCTFail("Array length is not 2 doors")
                return
            }
            let door1 = doors[0]
            XCTAssertEqual(door1.mac, "62:fe:50:80:12:6a")
            XCTAssertEqual(door1.name, "ADC")
            XCTAssertEqual(door1.location, "Amos Eaton South")
            XCTAssertEqual(door1.latitude, 42.7299, accuracy: 0.0001)
            XCTAssertEqual(door1.longitude, -73.6825, accuracy: 0.0001)
            
            let door2 = doors[1]
            XCTAssertEqual(door2.mac, "56:13:5a:fb:1c:30")
            XCTAssertEqual(door2.name, "SAGE_SOUTH")
            XCTAssertEqual(door2.location, "Sage Front Door")
            XCTAssertEqual(door2.latitude, 42.7308, accuracy: 0.0001)
            XCTAssertEqual(door2.longitude, -73.6817, accuracy: 0.0001)
        
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

}
