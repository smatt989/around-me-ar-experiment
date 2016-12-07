//
//  Place.m
//  Around Me
//
//  Created by Matthew Slotkin on 12/6/16.
//  Copyright © 2016 Jean-Pierre Distler. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address placeId:(NSString *)placeId {
    if((self = [super init])) {
        _location = location;
        _reference = reference;
        _placeName = name;
        _address = address;
        _placeId = placeId;
    }
    return self;
}

- (NSString *)infoText {
    return [NSString stringWithFormat:@"Name:%@\nAddress:%@\nPhone:%@\nWeb:%@", _placeName, _address, _phoneNumber, _website];
}

@end
