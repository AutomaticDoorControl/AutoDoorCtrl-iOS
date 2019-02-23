//
//  BLEManager.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

/**
 * Note: dispatch to the main thread when calling delegate methods.
 */
class BLEManager: NSObject {
    
    static let current = BLEManager()
    
    weak var delegate: BLEManagerDelegate?
    
    private var bluetoothManager: CBCentralManager!
    private var adc: CBPeripheral?
    private var adcDataPoint: CBCharacteristic?
    
    private let bleModuleUUID = CBUUID(string: "0xFFE0")
    private let bleCharacteristicUUID = CBUUID(string: "0xFFE1")
    
    // if the connection request last more than 5s, then let the delegate know of the timeout error.
    private let timeOutInterval: TimeInterval = 5.0
    private var connectingTimeoutTimer: Timer?
    private var scanningTimeoutTimer: Timer?
    
    private var availableBLEs: Set<CBPeripheral> = Set()
    
    private override init() {
        super.init()
        bluetoothManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .userInitiated))
    }
    
    // MARK: - Instance methods
    func scan() {
        availableBLEs.removeAll()
        if bluetoothManager.state == .poweredOn {
            bluetoothManager.scanForPeripherals(withServices: [bleModuleUUID], options: nil)
            scanningTimeoutTimer = Timer.scheduledTimer(withTimeInterval: timeOutInterval,
                                                        repeats: false) { [weak self] _ in
                self?.bluetoothManager.stopScan()
                self?.delegate?.didReceiveError(error: .scanningTimeout)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.delegate?.didReceiveError(error:
                        BLEError.error(fromBLEState: strongSelf.bluetoothManager.state))
                }
            }
        }
    }
    
    func connect(peripheral: CBPeripheral) {
        connectingTimeoutTimer = Timer.scheduledTimer(withTimeInterval: timeOutInterval,
                                            repeats: false) { [weak self] _ in
                                                self?.delegate?.didReceiveError(error: .connectionTimeout)
        }
        bluetoothManager.connect(peripheral)
    }
    
    func disconnect() {
        if let smartDeskUnwrapped = adc {
            bluetoothManager.cancelPeripheralConnection(smartDeskUnwrapped)
            adc = nil
            adcDataPoint = nil
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didDisconnectFromSmartDesk()
            }
        }
    }
    
    func send(string: String) {
        guard let peripheral = adc, let characteristic = adcDataPoint else {
            print("Not ready to send data")
            return
        }
        // note: will not work using the .withResponse type
        peripheral.writeValue(string.data(using: String.Encoding.utf8)!,
                              for: characteristic, type: .withoutResponse)
    }
    
    func send(colorCommand: String, color: UIColor) {
        guard let peripheral = adc, let characteristic = adcDataPoint else {
            print("Not ready to send data")
            return
        }
        // send 4 bytes of color information to the peripheral
        peripheral.writeValue(Data(bytes: BLEManager.generateByteArray(for: colorCommand, color: color)),
                              for: characteristic, type: .withoutResponse)
    }
    
    /**
     * Read the signal strength of the BLE connection. The result is passed
     * in as a parameter in the delegate callback `didReceiveRSSIReading(reading:status:)`.
     */
    func readSignalStrength() {
        adc?.readRSSI()
    }
}

extension BLEManager: CBCentralManagerDelegate {
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        handle(updatedState: central.state)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.debugDescription)
        // if you rename the ble module, there will be a newline. Be sure to remove it
        availableBLEs.insert(peripheral)
        scanningTimeoutTimer?.invalidate()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didDiscoverDoors(doors:
                Array(strongSelf.availableBLEs).map { Door(peripheral: $0) })
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        adc = peripheral
        adc?.delegate = self
        adc?.discoverServices([bleModuleUUID])
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                print(error.localizedDescription)
                self?.delegate?.didReceiveError(error: .peripheralDisconnected)
            }
        }
    }
    
    func handle(updatedState state: CBManagerState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .poweredOff:
                print("BLE Manager Powered off State")
                self?.delegate?.didReceiveError(error: .bluetoothOff)
            case .poweredOn:
                print("BLE Manager Powered on State")
            default:
                if let error = BLEError.error(fromBLEState: state) {
                    self?.delegate?.didReceiveError(error: error)
                }
            }
        }
    }
}

extension BLEManager: CBPeripheralDelegate {
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        guard services.count == 1 else {
            delegate?.didReceiveError(error: .genericError(error:
                NSError(domain: "Should only have 1 service", code: 0, userInfo: [:])))
            return
        }
        peripheral.discoverCharacteristics([bleCharacteristicUUID], for: services.first!)
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard error == nil else {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveError(error: .genericError(error: error))
            }
            return
        }
        guard let characteristics = service.characteristics, characteristics.count == 1 else {
            delegate?.didReceiveError(error: .unexpected)
            return
        }
        adcDataPoint = characteristics.first!
        // at this point, cancel the timeout error message
        connectingTimeoutTimer?.invalidate()
        // listen for values sent from the BLE module
        adc?.setNotifyValue(true, for: adcDataPoint!)
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.readyToSendData()
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let data = characteristic.value {
            let byteArray = [UInt8](data)
            // Arduino Serial string encoding is ascii
            // this can only receive 4 bytes at a time (4 characters)
            if let asciiStr = String(bytes: byteArray, encoding: String.Encoding.ascii) {
                DispatchQueue.main.async { [weak self] in
                    print(asciiStr)
                    self?.delegate?.didReceiveMessage(message: asciiStr.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        guard error == nil else {
            delegate?.didReceiveError(error: .genericError(error: error))
            return
        }
        let dbm = RSSI.intValue
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
             strongSelf.delegate?.didReceiveRSSIReading(reading: BLESignalStrength(rssi: dbm))
        }
    }
}

extension BLEManager {
    // MARK: - Utilities
    
    /**
     * Convert to a string with letters (e.g. `"AB"`) from an ascii string such as
     * `"65\r\n66\r\n10"`.
     *   - Use this method when processing strings from the serial monitor
     * - parameter asciiStr: String in ascii number form, separeted by \r\n
     */
    class func string(ascii asciiStr: String) -> String {
        let asciiArr = asciiStr.components(separatedBy: "\r\n")
        print(asciiArr)
        // remove the 10 and empty string
        return asciiArr.filter { $0 != "10" && $0 != "" }.map { element -> String in
            guard let asciiNum = Int(element), let unicodeScalar = UnicodeScalar(asciiNum) else {
                return ""
            }
            return "\(Character(unicodeScalar))"
        }.joined().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /**
     * Generate 4 bytes of data with the first byte being the command and last 3 bytes being the rgb values.
     * - parameter command: the command used to send the indicate what this byte arr is for
     * - parameter color: the color to send
     */
    class func generateByteArray(for command: String, color: UIColor) -> [UInt8] {
        var bytesToSend = [UInt8]()
        // add the ascii representation of the command to array
        bytesToSend.append(UInt8(command.unicodeScalars.first!.value))
        // append the respective rgb values to byte array
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        bytesToSend.append(UInt8(red * 255))
        bytesToSend.append(UInt8(green * 255))
        bytesToSend.append(UInt8(blue * 255))
        return bytesToSend
    }
}
