//
//  Venue.h
//  ApiKit
//
//  Created by Johann Kerr on 5/11/14.
//  Copyright (c) 2014 Johann Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;
@class Stats;

@interface Venue : NSObject

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Stats *stats;
@property (nonatomic, strong) NSString *name;

@end
