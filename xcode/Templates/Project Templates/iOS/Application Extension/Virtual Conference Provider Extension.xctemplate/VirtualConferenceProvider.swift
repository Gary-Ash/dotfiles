___FILEHEADER___

import EventKit

class ___FILEBASENAME___: EKVirtualConferenceProvider {
    
    override func fetchAvailableRoomTypes() async throws -> [EKVirtualConferenceRoomTypeDescriptor] {
        let roomType = EKVirtualConferenceRoomTypeDescriptor(title: "My Virtual Conference Room", identifier: "my_virtual_conference_room")
        return [roomType]
    }
    
    override func fetchVirtualConference(identifier: EKVirtualConferenceRoomTypeIdentifier) async throws -> EKVirtualConferenceDescriptor {
        let urlDescriptor = EKVirtualConferenceURLDescriptor(title: nil, url: URL(string: "https://example.com/")!)
        let virtualConferenceDescriptor = EKVirtualConferenceDescriptor(title: "My Virtual Conference", urlDescriptors: [urlDescriptor], conferenceDetails: "Any other notes or details you wish to include about this virtual conference.")
        return virtualConferenceDescriptor
    }
}
