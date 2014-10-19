//
//  DTSTripDetailsProtocol.h
//  Trip Story
//
//  Created by Dinesh Challa on 10/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSTrip.h"

@protocol DTSTripDetailsProtocol <NSObject>
@property (nonatomic, strong) DTSTrip *trip;
@end
