//
//  BluetoothScanStreamHandler.swift
//  flutter_device_searcher
//
//  Created by Peter Wong (Engineering) on 27/1/2023.
//
import Flutter
import CoreBluetooth

class BluetoothScanStreamHandler: NSObject, FlutterStreamHandler, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var discoveredDevices: Dictionary<String, CBPeripheral> = [:]
    
    private var bluetoothManager: CBCentralManager!
    
    private var onDiscoveredDevicesChanged: (() -> Void)?
    
    private var connectingPeripheral: CBPeripheral?
    private var onConnectSuccess: (() -> Void)?
    private var onConnectFailure: ((FlutterError) -> Void)?
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredDevices[peripheral.identifier.uuidString] = peripheral
        onDiscoveredDevicesChanged?()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let fError = error {
            // TODO distinguish errors
            onConnectFailure?(FlutterError(code: "1006", message: "Unexpected connection error.", details: fError.localizedDescription + Thread.callStackSymbols.joined(separator: "\n")))
        } else {
            if let service = peripheral.services?.first {
                peripheral.discoverCharacteristics(nil, for: service)
            } else {
                onConnectFailure?(FlutterError(code: "1006", message: "Unexpected connection error.", details: Thread.callStackSymbols.joined(separator: "\n")))
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let fError = error {
            // TODO distinguish errors
            onConnectFailure?(FlutterError(code: "1006", message: "Unexpected connection error.", details: fError.localizedDescription + Thread.callStackSymbols.joined(separator: "\n")))
        } else {
            onConnectSuccess?();
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let fError = error {
            // TODO distinguish errors
            onConnectFailure?(FlutterError(code: "1006", message: "Unexpected connection error.", details: fError.localizedDescription + Thread.callStackSymbols.joined(separator: "\n")))
        } else {
            onConnectFailure?(FlutterError(code: "1006", message: "Unexpected connection error.", details: Thread.callStackSymbols.joined(separator: "\n")));
        }
    }
    
    public func setup() {
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        bluetoothManager.scanForPeripherals(withServices: nil)
        
        onDiscoveredDevicesChanged = {
            let result = self.discoveredDevices.values.map({ value in
                var item: Dictionary<String, String> = [:]
                item["address"] = value.identifier.uuidString
                item["name"] = value.name
                return item
            })
            events(result)
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    public func stopScanning() {
        bluetoothManager.stopScan()
    }
    
    public func connect(_ address: String, _ onSuccess: @escaping () -> Void, _ onFailure: @escaping (FlutterError) -> Void) {
        if (connectingPeripheral != nil) {
            onFailure(FlutterError(code: "1005", message: "Device already connected.", details: Thread.callStackSymbols.joined(separator: "\n")))
        }
        
        if let peripheral = discoveredDevices[address] {
            onConnectSuccess = onSuccess
            onConnectFailure = onFailure
            connectingPeripheral = peripheral
            bluetoothManager.connect(peripheral)
        } else {
            onFailure(FlutterError(code: "1006", message: "Unknown device.", details: Thread.callStackSymbols.joined(separator: "\n")))
        }
    }
    
    public func disconnect() -> Bool {
        if let peripheral = connectingPeripheral {
            connectingPeripheral = nil
            bluetoothManager.cancelPeripheralConnection(peripheral)
            
            return true
        } else {
            return false
        }
    }
}
