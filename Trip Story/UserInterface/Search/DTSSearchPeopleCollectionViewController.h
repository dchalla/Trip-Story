//
//  DTSSearchPeopleCollectionViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 6/3/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "PFQueryCollectionViewController.h"
#import "DTSViewLayoutProtocol.h"
#import <Parse/Parse.h>
#import "DTSSearchRootViewControllerProtocol.h"

@interface DTSSearchPeopleCollectionViewController : PFQueryCollectionViewController<UICollectionViewDelegateFlowLayout,DTSViewLayoutProtocol,DTSSearchRootViewControllerProtocol>

@end
