//
//  PullToMakeFlight.swift
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import ObjectiveC

// MARK: - PullToMakeFlight

public class PullToMakeFlight: PullToRefresh {
	public convenience init() {
		
		let refreshView =  NSBundle(forClass: self.dynamicType).loadNibNamed("FlightView", owner: nil, options: nil).first as! FlightView
		let animator =  FlightAnimator(refreshView: refreshView)
		self.init(refreshView: refreshView, animator: animator)
	}
}

// MARK: - FlightView

class FlightView: UIView {
	@IBOutlet
	private var cloudsLeft: UIView!
	@IBOutlet
	private var cloudsRight: UIView!
	@IBOutlet
	private var cloudsCenter: UIView!
	@IBOutlet
	private var airplane: UIView!
	@IBOutlet
	private var leftArrow: UIView!
	@IBOutlet
	private var leftArrowStick: UIImageView!
	@IBOutlet
	private var rightArrow: UIView!
	@IBOutlet
	private var rightArrowStick: UIView!
	@IBOutlet weak var hotairballoonLeft: UIImageView!
	@IBOutlet weak var hotairballoonRight: UIImageView!
	@IBOutlet weak var hotairballoonMiddle: UIImageView!
}

// MARK: - FlightAnimator

class FlightAnimator : RefreshViewAnimator {
	
	private let refreshView: FlightView
	
	init(refreshView: FlightView) {
		self.refreshView = refreshView
	}
	
	// MARK: - RefreshViewAnimator
	
	func animateState(state: State) {
		switch state {
		case .Inital:
			initalLayout()
		case .Releasing(let progress):
			releasingAnimation(progress)
		case .Loading:
			startLoading()
		case .Finished:
			finish()
		}
	}
	
	// MARK: - Private
	
	private func initalLayout() {
		
		// clouds center
		var random = arc4random_uniform(2)
		if(random == 1) {
			refreshView.hotairballoonLeft.alpha = 1
			refreshView.hotairballoonRight.alpha = 1
			refreshView.hotairballoonMiddle.alpha = 1
			
			refreshView.airplane.alpha = 0
			refreshView.leftArrow.alpha = 0
			refreshView.leftArrowStick.alpha = 0
			refreshView.rightArrow.alpha = 0
			refreshView.rightArrowStick.alpha = 0
		}
		else {
			refreshView.hotairballoonLeft.alpha = 0
			refreshView.hotairballoonRight.alpha = 0
			refreshView.hotairballoonMiddle.alpha = 0
			
			refreshView.airplane.alpha = 1
			refreshView.leftArrow.alpha = 1
			refreshView.leftArrowStick.alpha = 1
			refreshView.rightArrow.alpha = 1
			refreshView.rightArrowStick.alpha = 1
		}
		
		refreshView.cloudsCenter.removeAllAnimations()
		refreshView.cloudsCenter.transform = CGAffineTransformMakeScale(1.0, 1.0)
		refreshView.cloudsCenter.layer.timeOffset = 0.0
		
		refreshView.cloudsCenter.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [110, 95],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		refreshView.cloudsCenter.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.ScaleX,
			values: [1, 1.2],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		refreshView.cloudsCenter.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.ScaleY,
			values: [1, 1.2],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		// clouds left
		
		refreshView.cloudsLeft.removeAllAnimations()
		refreshView.cloudsLeft.transform = CGAffineTransformMakeScale(1, 1)
		refreshView.cloudsLeft.layer.timeOffset = 0.0
		
		refreshView.cloudsLeft.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [140, 100],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		refreshView.cloudsLeft.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.ScaleX,
			values: [1, 1.3],
			keyTimes: [0.5, 1],
			duration: 0.3,
			beginTime:0))
		
		refreshView.cloudsLeft.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.ScaleY,
			values: [1, 1.3],
			keyTimes: [0.5, 1],
			duration: 0.3,
			beginTime:0))
		
		// clouds right
		
		refreshView.cloudsRight.removeAllAnimations()
		refreshView.cloudsRight.transform = CGAffineTransformMakeScale(1, 1)
		refreshView.cloudsRight.layer.timeOffset = 0.0
		
		refreshView.cloudsRight.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [140, 100],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		refreshView.cloudsRight.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.ScaleX,
			values: [1, 1.3],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		refreshView.cloudsRight.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.ScaleY,
			values: [1, 1.3],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		
		// airplane
		
		refreshView.airplane.layer.removeAllAnimations()
		refreshView.airplane.frame = CGRectMake(77, 140, refreshView.airplane.frame.width, refreshView.airplane.frame.height)
		refreshView.airplane.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(77, 140)), NSValue(CGPoint: CGPointMake(refreshView.frame.width / 2, 50))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.airplane.layer.timeOffset = 0.0
		
		// airplane
		
		refreshView.hotairballoonMiddle.layer.removeAllAnimations()
		refreshView.hotairballoonMiddle.frame = CGRectMake(77, 140, refreshView.hotairballoonMiddle.frame.width, refreshView.hotairballoonMiddle.frame.height)
		refreshView.hotairballoonMiddle.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(77, 140)), NSValue(CGPoint: CGPointMake(refreshView.frame.width / 2, 50))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.hotairballoonMiddle.layer.timeOffset = 0.0
		
		// hotAirballoonLeft
		var balloonLeftX = 10 + refreshView.hotairballoonLeft.frame.size.width/2
		refreshView.hotairballoonLeft.layer.removeAllAnimations()
		refreshView.hotairballoonLeft.frame = CGRectMake(balloonLeftX, 140, refreshView.hotairballoonLeft.frame.width, refreshView.hotairballoonLeft.frame.height)
		refreshView.hotairballoonLeft.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(balloonLeftX, 140)), NSValue(CGPoint: CGPointMake(balloonLeftX, 50))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.hotairballoonLeft.layer.timeOffset = 0.0
		
		// hotAirballoonRight
		var balloonRightX = refreshView.frame.width - refreshView.hotairballoonRight.frame.size.width/2 - 10
		refreshView.hotairballoonRight.layer.removeAllAnimations()
		refreshView.hotairballoonRight.frame = CGRectMake(balloonRightX, 140, refreshView.hotairballoonRight.frame.width, refreshView.hotairballoonRight.frame.height)
		refreshView.hotairballoonRight.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(balloonRightX, 140)), NSValue(CGPoint: CGPointMake(balloonRightX, 50))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.hotairballoonRight.layer.timeOffset = 0.0
		
		// arrows
		
		refreshView.leftArrowStick.layer.anchorPoint = CGPointMake(0.5, 0.5)
		refreshView.rightArrowStick.layer.anchorPoint = CGPointMake(0.5, 0.5)
	}
	
	private func releasingAnimation(progress: CGFloat) {
		if progress <= 1 {
			refreshView.cloudsCenter.layer.timeOffset = Double(progress) * 0.3
			refreshView.cloudsLeft.layer.timeOffset = Double(progress) * 0.3
			refreshView.cloudsRight.layer.timeOffset = Double(progress) * 0.3
			refreshView.airplane.layer.timeOffset = Double(progress) * 0.3
			refreshView.hotairballoonLeft.layer.timeOffset = Double(progress) * 0.3
			refreshView.hotairballoonRight.layer.timeOffset = Double(progress) * 0.3
			refreshView.hotairballoonMiddle.layer.timeOffset = Double(progress) * 0.3
		}
		
		/*refreshView.leftArrow.frame = CGRectMake(
			refreshView.leftArrow.frame.origin.x,
			refreshView.cloudsRight.layer.presentationLayer().frame.origin.y - refreshView.leftArrow.frame.height,
			refreshView.leftArrow.frame.width,
			refreshView.leftArrow.frame.height)*/
		
		refreshView.leftArrowStick.frame = CGRectMake(
			refreshView.leftArrowStick.frame.origin.x,
			refreshView.leftArrow.frame.origin.y - refreshView.leftArrowStick.frame.height + 5,
			refreshView.leftArrowStick.frame.width,
			60 * progress)
		
		refreshView.rightArrow.frame = CGRectMake(
			refreshView.rightArrow.frame.origin.x,
			refreshView.leftArrow.frame.origin.y,
			refreshView.rightArrow.frame.width,
			refreshView.rightArrow.frame.height)
		
		refreshView.rightArrowStick.frame = CGRectMake(
			refreshView.rightArrowStick.frame.origin.x,
			refreshView.leftArrowStick.frame.origin.y,
			refreshView.rightArrowStick.frame.width,
			refreshView.leftArrowStick.frame.height)
	}
	
	private func startLoading() {
		refreshView.airplane.center = CGPointMake(refreshView.frame.width / 2, 50)
		
		let airplaneAnimation = CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [50, 45, 50, 55, 50],
			keyTimes: [0, 0.25, 0.5, 0.75, 1],
			duration: 2,
			beginTime: 0,
			timingFunctions: [TimingFunction.Linear])
		
		airplaneAnimation.repeatCount = FLT_MAX;
		refreshView.airplane.layer.removeAllAnimations()
		refreshView.airplane.layer.addAnimation(airplaneAnimation, forKey: "")
		refreshView.airplane.layer.speed = 1
		
		//hotairballoonmiddle
		refreshView.hotairballoonMiddle.center = CGPointMake(refreshView.frame.width / 2, 50)
		
		let hotairballoonMiddleAnimation = CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [50, 45, 50, 55, 50],
			keyTimes: [0, 0.25, 0.5, 0.75, 1],
			duration: 2,
			beginTime: 0,
			timingFunctions: [TimingFunction.Linear])
		
		hotairballoonMiddleAnimation.repeatCount = FLT_MAX;
		refreshView.hotairballoonMiddle.layer.removeAllAnimations()
		refreshView.hotairballoonMiddle.layer.addAnimation(hotairballoonMiddleAnimation, forKey: "")
		refreshView.hotairballoonMiddle.layer.speed = 1

		//hotairballoonLeft
		var balloonLeftX = 10 + refreshView.hotairballoonLeft.frame.size.width/2
		refreshView.hotairballoonLeft.center = CGPointMake(balloonLeftX, 50)
		
		let hotairballoonLeftAnimation = CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [50, 45, 50, 55, 50],
			keyTimes: [0, 0.25, 0.5, 0.75, 1],
			duration: 2,
			beginTime: 0,
			timingFunctions: [TimingFunction.Linear])
		
		hotairballoonLeftAnimation.repeatCount = FLT_MAX;
		refreshView.hotairballoonLeft.layer.removeAllAnimations()
		refreshView.hotairballoonLeft.layer.addAnimation(hotairballoonLeftAnimation, forKey: "")
		refreshView.hotairballoonLeft.layer.speed = 1
		
		
		
		//hotairballoonRight
		var balloonRightX = refreshView.frame.width - refreshView.hotairballoonRight.frame.size.width/2 - 10
		refreshView.hotairballoonRight.center = CGPointMake(balloonRightX, 50)
		
		let hotairballoonRightAnimation = CAKeyframeAnimation.animationWith(
			AnimationType.PositionY,
			values: [50, 45, 50, 55, 50],
			keyTimes: [0, 0.25, 0.5, 0.75, 1],
			duration: 2,
			beginTime: 0,
			timingFunctions: [TimingFunction.Linear])
		
		hotairballoonRightAnimation.repeatCount = FLT_MAX;
		refreshView.hotairballoonRight.layer.removeAllAnimations()
		refreshView.hotairballoonRight.layer.addAnimation(hotairballoonRightAnimation, forKey: "")
		refreshView.hotairballoonRight.layer.speed = 1
		
		refreshView.leftArrowStick.layer.anchorPoint = CGPointMake(0.5, 0)
		refreshView.rightArrowStick.layer.anchorPoint = CGPointMake(0.5, 0)
		UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 7.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
			var frame = self.refreshView.leftArrowStick.frame
			frame.size.height = 0
			frame.origin.y = self.refreshView.leftArrow.frame.origin.y
			self.refreshView.leftArrowStick.frame = frame
			
			frame = self.refreshView.rightArrowStick.frame
			frame.size.height = 0
			frame.origin.y = self.refreshView.leftArrow.frame.origin.y
			self.refreshView.rightArrowStick.frame = frame
			
			}, completion: nil)
	}
	
	private func finish() {
		refreshView.airplane.removeAllAnimations()
		refreshView.airplane.layer.timeOffset = 0.0
		refreshView.airplane.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(refreshView.frame.width / 2, 50)), NSValue(CGPoint: CGPointMake(refreshView.frame.width, -50))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.airplane.layer.speed = 1
		
		//hotairballoonmiddle
		refreshView.hotairballoonMiddle.removeAllAnimations()
		refreshView.hotairballoonMiddle.layer.timeOffset = 0.0
		refreshView.hotairballoonMiddle.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(refreshView.frame.width / 2, 50)), NSValue(CGPoint: CGPointMake(refreshView.frame.width, -50))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.hotairballoonMiddle.layer.speed = 1
		
		//balloonLeft
		var balloonLeftX = 10 + refreshView.hotairballoonLeft.frame.size.width/2
		refreshView.hotairballoonLeft.removeAllAnimations()
		refreshView.hotairballoonLeft.layer.timeOffset = 0.0
		refreshView.hotairballoonLeft.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(balloonLeftX, 50)), NSValue(CGPoint: CGPointMake(balloonLeftX - refreshView.hotairballoonLeft.frame.width, -100))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.hotairballoonLeft.layer.speed = 1
		
		//balloonRight
		var balloonRightX = refreshView.frame.width - refreshView.hotairballoonRight.frame.size.width/2 - 10
		refreshView.hotairballoonRight.removeAllAnimations()
		refreshView.hotairballoonRight.layer.timeOffset = 0.0
		refreshView.hotairballoonRight.addAnimation(CAKeyframeAnimation.animationWith(
			AnimationType.Position,
			values: [NSValue(CGPoint: CGPointMake(balloonRightX, 50)), NSValue(CGPoint: CGPointMake(balloonRightX + refreshView.hotairballoonRight.frame.width , -100))],
			keyTimes: [0, 1],
			duration: 0.3,
			beginTime:0))
		refreshView.hotairballoonRight.layer.speed = 1
		
		
	}
}


