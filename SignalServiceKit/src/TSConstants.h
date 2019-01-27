//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#ifndef TextSecureKit_Constants_h
#define TextSecureKit_Constants_h

typedef NS_ENUM(NSInteger, TSWhisperMessageType) {
    TSUnknownMessageType = 0,
    TSEncryptedWhisperMessageType = 1,
    TSIgnoreOnIOSWhisperMessageType = 2, // on droid this is the prekey bundle message irrelevant for us
    TSPreKeyWhisperMessageType = 3,
    TSUnencryptedWhisperMessageType = 4,
    TSUnidentifiedSenderMessageType = 6,
};

#pragma mark Server Address

#define textSecureHTTPTimeOut 10

#define kLegalTermsUrlString @"http://dedi.link"

//#ifndef DEBUG

// Production
#define textSecureWebSocketAPI @"wss://dedi.btk.gov.tr:443/v1/websocket/"
#define textSecureServerURL @"https://dedi.btk.gov.tr:443/"
#define textSecureCDNServerURL @"https://dedi.btk.gov.tr:80/dedi"
#define textSecureServiceReflectorHost @"https://dedi.btk.gov.tr:443/"
#define textSecureCDNReflectorHost @"https://dedi.btk.gov.tr:80/dedi"

#define contactDiscoveryURL @"https://api.directory.signal.org"
#define kUDTrustRoot @"BXu6QIKVz5MA8gstzfOgRQGqyLqOwNKHL6INkv3IHWMF"
#define USING_PRODUCTION_SERVICE

//#define textSecureWebSocketAPI @"wss://test.dedi.com.tr:443/v1/websocket/"
//#define textSecureServerURL @"https://test.dedi.com.tr:443/"
//#define textSecureCDNServerURL @"https://test.dedi.com.tr:443/dedi"
//#define textSecureServiceReflectorHost @"https://test.dedi.com.tr:443/"
//#define textSecureCDNReflectorHost @"https://test.dedi.com.tr:443/dedi"

//#else

// Staging
//#define textSecureWebSocketAPI @"wss://textsecure-service-staging.whispersystems.org/v1/websocket/"
//#define textSecureServerURL @"https://textsecure-service-staging.whispersystems.org/"
//#define textSecureCDNServerURL @"https://cdn-staging.signal.org"
//#define textSecureServiceReflectorHost @"meek-signal-service-staging.appspot.com";
//#define textSecureCDNReflectorHost @"meek-signal-cdn-staging.appspot.com";
//#define contactDiscoveryURL @"https://api-staging.directory.signal.org"
//#define kUDTrustRoot @"BbqY1DzohE4NUZoVF+L18oUPrK3kILllLEJh2UnPSsEx"

//#endif

BOOL IsUsingProductionService(void);

#define textSecureAccountsAPI @"v1/accounts"
#define textSecureAttributesAPI @"/attributes/"

#define textSecureMessagesAPI @"v1/messages/"
#define textSecureKeysAPI @"v2/keys"
#define textSecureSignedKeysAPI @"v2/keys/signed"
#define textSecureDirectoryAPI @"v1/directory"
#define textSecureAttachmentsAPI @"v1/attachments"
#define textSecureDeviceProvisioningCodeAPI @"v1/devices/provisioning/code"
#define textSecureDeviceProvisioningAPIFormat @"v1/provisioning/%@"
#define textSecureDevicesAPIFormat @"v1/devices/%@"
#define textSecureProfileAPIFormat @"v1/profile/%@"
#define textSecureSetProfileNameAPIFormat @"v1/profile/name/%@"
#define textSecureProfileAvatarFormAPI @"v1/profile/form/avatar"
#define textSecure2FAAPI @"/v1/accounts/pin"

#define SignalApplicationGroup @"group.org.btider.dediapp.group"

#endif
