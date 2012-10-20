//
//  gAnimation.h
//  easyFollow
//
//  Created by Qiu Han on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gAnimation : NSObject

+ (void)makeView:(UIView *)view toShow:(BOOL)show withDuration:(CGFloat)duration;
+ (void)makeView:(UIView *)view blinkWithDuration:(CGFloat)duration;
+ (void)moveView:(UIView *)view toFinalFrame:(CGRect)frame withDuration:(CGFloat)duration;
+ (void)makeView:(UIView *)view rotateWithAngle:(CGFloat)angle andDuration:(CGFloat)duration;
+ (void)makeView:(UIView *)view rotateAroundWithCycle:(CGFloat)cycle;
+ (void)makeView:(UIView *)view wobbleWithAngle:(CGFloat)angle andDuration:(CGFloat)duration;

@end
