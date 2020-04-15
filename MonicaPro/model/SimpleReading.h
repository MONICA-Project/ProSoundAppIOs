//
//  SensorSummaryItem.h
//  EiB
//
//  Created by Daniel Eriksson on 04/03/15.
//  Copyright (c) 2015 CNet Mac Account. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleReading : NSObject

@property (nonatomic) double readingValue;
@property (nonatomic) double readingValue2;
@property (nonatomic, retain) NSDate* readingDate;

@end
