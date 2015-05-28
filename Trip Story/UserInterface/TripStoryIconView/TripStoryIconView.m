//
//  TripStoryIconView.m
//  Trip Story
//
//  Created by Dinesh Challa on 5/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "TripStoryIconView.h"
#import "UIColor+Utilities.h"

@implementation TripStoryIconView

-(void)awakeFromNib
{
	[super awakeFromNib];
	self.leftTopView.layer.cornerRadius = self.leftTopView.frame.size.width/2;
	self.rightTopView.layer.cornerRadius = self.rightTopView.frame.size.width/2;
	self.leftBottomView.layer.cornerRadius = self.leftBottomView.frame.size.width/2;
	self.rightBottonView.layer.cornerRadius = self.rightBottonView.frame.size.width/2;
	self.leftTopView.layer.masksToBounds = self.rightTopView.layer.masksToBounds= self.leftBottomView.layer.masksToBounds= self.rightBottonView.layer.masksToBounds = NO;
	self.leftTopView.layer.shadowColor = self.rightTopView.layer.shadowColor = self.leftBottomView.layer.shadowColor = self.rightBottonView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.leftTopView.layer.shadowOffset = self.rightTopView.layer.shadowOffset = self.leftBottomView.layer.shadowOffset = self.rightBottonView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	self.leftTopView.layer.shadowRadius = self.rightTopView.layer.shadowRadius = self.leftBottomView.layer.shadowRadius = self.rightBottonView.layer.shadowRadius = 10;
	self.leftTopView.layer.shadowOpacity = self.rightTopView.layer.shadowOpacity = self.leftBottomView.layer.shadowOpacity = self.rightBottonView.layer.shadowOpacity = 0.0f;
	
	self.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:33.0/255.0 blue:46.0/255.0 alpha:1];
}

@end
