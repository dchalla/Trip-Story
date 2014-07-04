//
//  DTSLocation.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSLocation : NSObject

@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong) NSNumber *locationZipcode;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *locationCountry;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *locationID;

@end
