//
//  YNCSDKConnection.m
//  Yuneec_SDK_iOSExample
//
//  Created by Julian Oes on 23/12/16.
//  Copyright © 2016 yuneec. All rights reserved.
//

#import "YNCSDKConnection.h"
#import "YNCSDKInternal.h"

#include <vector>

using namespace dronecore;

static id<YNCSDKConnectionDelegate> _delegate;

@implementation YNCSDKConnection

// Singleton
+ (id)instance {
    static YNCSDKConnection *temp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        temp = [[self alloc] init];
    });
    
    return temp;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)dealloc {
    // Should never be called.
}

void on_discover(uint64_t uuid) {
    NSLog(@"Found device with UUID: %llu", uuid);
    if (_delegate && [_delegate respondsToSelector:@selector(onDiscover)]) {
        [_delegate onDiscover];
    }
}

void on_timeout(uint64_t uuid) {
    NSLog(@"Lost device with UUID: %llu", uuid);
    if (_delegate && [_delegate respondsToSelector:@selector(onTimeout)]) {
        [_delegate onTimeout];
    }
}

- (YNCConnectionResult)connect {
    [self requestNetwork];
    
    DroneCore *dc = [[YNCSDKInternal instance] dc];
    DroneCore::ConnectionResult ret = dc->add_udp_connection();
    if (ret != DroneCore::ConnectionResult::SUCCESS) {
        NSLog(@"Connect error: %u", (unsigned)ret);
        switch(ret) {
            case dronecore::DroneCore::ConnectionResult::BIND_ERROR:
                return YNCConnectionResultBindError;
            case dronecore::DroneCore::ConnectionResult::COMMAND_DENIED:
                return YNCConnectionResultCommandDenied;
            case dronecore::DroneCore::ConnectionResult::CONNECTION_ERROR:
                return YNCConnectionResultConnectionError;
            case dronecore::DroneCore::ConnectionResult::CONNECTIONS_EXHAUSTED:
                return YNCConnectionResultConnectionsExhausted;
            case dronecore::DroneCore::ConnectionResult::DESTINATION_IP_UNKNOWN:
                return YNCConnectionResultDestinationIpUnknown;
            case dronecore::DroneCore::ConnectionResult::DEVICE_BUSY:
                return YNCConnectionResultDeviceBusy;
            case dronecore::DroneCore::ConnectionResult::DEVICE_NOT_CONNECTED:
                return YNCConnectionResultDeviceNotConnected;
            case dronecore::DroneCore::ConnectionResult::NOT_IMPLEMENTED:
                return YNCConnectionResultNotImplemented;
            case dronecore::DroneCore::ConnectionResult::SOCKET_CONNECTION_ERROR:
                return YNCConnectionResultSocketError;
            case dronecore::DroneCore::ConnectionResult::SOCKET_ERROR:
                return YNCConnectionResultSocketError;
            case dronecore::DroneCore::ConnectionResult::TIMEOUT:
                return YNCConnectionResultTimeOut;
            default:
                return YNCConnectionResultUnknown;
        }
    }
    
    dc->register_on_discover(&on_discover);
    dc->register_on_timeout(&on_timeout);
    
    return YNCConnectionResultSuccess;
}

- (void)removeConnection {
    [[YNCSDKInternal instance] resetDroneCore];
}

- (void)setDelegate:(id<YNCSDKConnectionDelegate>)delegate {
    _delegate = delegate;
}

//MARK: Get Camera Mode String
+ (NSString *)getConnectionResultString:(YNCConnectionResult)connectionResultEnum {
    
    switch(connectionResultEnum) {
        case YNCConnectionResultSuccess:
            return @"Success";
        case YNCConnectionResultBindError:
            return @"Bind Error";
        case YNCConnectionResultCommandDenied:
            return @"Command Denied";
        case YNCConnectionResultSocketError:
            return @"Socket Error";
        case YNCConnectionResultNotImplemented:
            return @"Not Implemented";
        case YNCConnectionResultTimeOut:
            return @"Timeout";
        case YNCConnectionResultDeviceNotConnected:
            return @"Device Not Connected";
        case YNCConnectionResultDestinationIpUnknown:
            return @"Destination Ip Unknown";
        case YNCConnectionResultDeviceBusy:
            return @"Device Busy";
        case YNCConnectionResultConnectionsExhausted:
            return @"Connections Exhausted";
        case YNCConnectionResultSocketConnectionError:
            return @"Socket Connection Error";
        default:
            return @"Unknown";
    }
}

//MARK:Since China's National Bank iPhone requires users to allow App to access cellular data and WiFi connection to the network, add a network request to prompt the network for permission, to resolve the qustion of "no route to host"
- (void)requestNetwork {
    NSURL *url = [NSURL URLWithString:@"https://192.168.42.1/"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",dict);
        } else {
            NSLog(@"request network error:%@",error);
        }
    }];
    
    [dataTask resume];
}

@end
