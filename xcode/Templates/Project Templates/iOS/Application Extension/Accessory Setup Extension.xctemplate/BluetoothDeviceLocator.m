___FILEHEADER___

#import "BluetoothDeviceLocator.h"

#import <DeviceDiscoveryExtension/DeviceDiscoveryExtension.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface BluetoothDeviceLocator () <CBCentralManagerDelegate>
@end

/// A DeviceLocator that searches for devices using CoreBluetooth.
@implementation BluetoothDeviceLocator {
    CBCentralManager *_centralManager;
    NSMutableArray <DDDevice *> *_knownDevices;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Create a central Bluetooth manager to search for devices.
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

@synthesize eventHandler = _eventHandler;

- (void)startScanning
{
    // An example Bluetooth service ID for the device for which to scan.
    // This must match a value contained within the NSBluetoothServices array in the extension's Info.plist.
    CBUUID *exampleServiceID = [CBUUID UUIDWithString:@"___UUID:exampleBluetoothServiceID___"];

    // Start the central manager.
    
    [_centralManager scanForPeripheralsWithServices:@[exampleServiceID] options:nil];
}

- (void)stopScanning
{
    // Stop the central manager.
    
    [_centralManager stopScan];
}

/// Inform the session of the device state represented by the discovered peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    // If no event handler is set, don't report anything.
    
    if (_eventHandler == nil) {
        return;
    }
    
    // An example device identifier and name for the discovered device.
    // It's important that this come from or be associated with the device itself.
    NSUUID *exampleDeviceUUID = [NSUUID UUID];
    NSString *exampleDeviceIdentifier = exampleDeviceUUID.UUIDString;
    NSString *exampleDeviceName = [advertisementData[CBAdvertisementDataLocalNameKey] copy];
    
    // An example protocol for the discovered device.
    // This must match the type declared in the extension's Info.plist.
    UTType *exampleDeviceProtocol = [UTType typeWithIdentifier:@"com.example.example-protocol"];
    NSAssert(exampleDeviceProtocol != nil, @"Misconfiguration: UTType for protocol not defined.");
    
    // Create a DDDevice instance representing the device.
    DDDevice *device = [[DDDevice alloc] initWithDisplayName:exampleDeviceName category:DDDeviceCategoryHiFiSpeaker protocolType:exampleDeviceProtocol identifier:exampleDeviceIdentifier];
    device.bluetoothIdentifier = exampleDeviceUUID;
    
    [_knownDevices addObject:device];
    
    // Pass it to the event handler, if one is set.
    
    DDDeviceEvent *event = [[DDDeviceEvent alloc] initWithEventType:DDEventTypeDeviceFound device:device];
    _eventHandler(event);
}

/// Handle state updates for the central manager itself.
/// This required protocol method can be used to detect when Bluetooth status changes, by checking the central manager's state property.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Handle Bluetooth state changes, for example by informing the eventHandler that the devices that were previously discovered are no longer available.
    
    switch (central.state) {
        case CBManagerStateUnknown:
        case CBManagerStateResetting:
        case CBManagerStateUnsupported:
        case CBManagerStateUnauthorized:
        case CBManagerStatePoweredOff:
            if (_eventHandler) {
                for (DDDevice *device in _knownDevices) {
                    DDDeviceEvent *event = [[DDDeviceEvent alloc] initWithEventType:DDEventTypeDeviceLost device:device];
                    _eventHandler(event);
                }
            }
            [_knownDevices removeAllObjects];
            break;
            
        case CBManagerStatePoweredOn:
            _knownDevices = [NSMutableArray array];
            break;
    }
}

@end
