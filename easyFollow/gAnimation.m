//
//  gAnimation.m
//  easyFollow
//
//  Created by goshan on 10/20/12.
//  Copyright (c) 2012 easyFollow. All rights reserved.
//

#import "gAnimation.h"




@implementation gAnimation


//=================some kit function==================//

+ (void) brighten:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat duration = [[params objectAtIndex:1] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/2];
    view.alpha = 1.0;
    [UIView commitAnimations];
}

+ (void) darken:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat duration = [[params objectAtIndex:1] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/2];
    view.alpha = 0.0;
    [UIView commitAnimations];
}

+ (void) rotate1:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat duration = [[params objectAtIndex:1] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGFloat rotation = (120.0 * M_PI) / 180.0;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
    view.transform = rotate;
    [UIView commitAnimations];
}

+ (void) rotate2:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat duration = [[params objectAtIndex:1] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGFloat rotation = (240.0 * M_PI) / 180.0;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
    view.transform = rotate;
    [UIView commitAnimations];
}

+ (void) rotate3:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat duration = [[params objectAtIndex:1] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGFloat rotation = (0.0 * M_PI) / 180.0;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
    view.transform = rotate;
    [UIView commitAnimations];
}

+ (void)wobbleLeft:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat angle = [[params objectAtIndex:1] floatValue];
    CGFloat duration = [[params objectAtIndex:2] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/3];
    CGFloat rotation = (angle * M_PI) / 180.0;
    CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
    view.transform = wobbleLeft;
    [UIView commitAnimations];
}

+ (void)wobbleRight:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat angle = [[params objectAtIndex:1] floatValue];
    CGFloat duration = [[params objectAtIndex:2] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/3];
    CGFloat rotation = (-angle * M_PI) / 180.0;
    CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(rotation);
    view.transform = wobbleRight;
    [UIView commitAnimations];
}

+ (void)wobbleMiddle:(NSArray *)params{
    UIView *view = [params objectAtIndex:0];
    CGFloat duration = [[params objectAtIndex:2] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration/3];
    CGFloat rotation = 0.0;
    CGAffineTransform wobbleMiddle = CGAffineTransformMakeRotation(rotation);
    view.transform = wobbleMiddle;
    [UIView commitAnimations];
}

//=================main api function==================//

+ (void)makeView:(UIView *)view blinkWithDuration:(CGFloat)duration{
    NSArray *params = [NSArray arrayWithObjects:view, [NSNumber numberWithFloat:duration], nil];
    
    [self performSelector:@selector(brighten:) withObject:params afterDelay:0.0];
    [self performSelector:@selector(darken:) withObject:params afterDelay:duration/2];
}


+ (void)makeView:(UIView *)view toShow:(BOOL)show withDuration:(CGFloat)duration{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    if (show){
        view.alpha = 1.0;
    }
    else {
        view.alpha = 0.0;
    }
    [UIView commitAnimations];
}

+ (void)moveView:(UIView *)view toFinalFrame:(CGRect)frame withDuration:(CGFloat)duration{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [view setFrame:frame];
    [UIView commitAnimations];
}

+ (void)makeView:(UIView *)view rotateWithAngle:(CGFloat)angle andDuration:(CGFloat)duration{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    CGFloat rotation = (angle * M_PI) / 180.0;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
    view.transform = rotate;
    [UIView commitAnimations];
}

+ (void)makeView:(UIView *)view rotateAroundWithCycle:(CGFloat)cycle{
    NSArray *params = [NSArray arrayWithObjects:view, [NSNumber numberWithFloat:cycle], nil];
    
    [self performSelector:@selector(rotate1:) withObject:params afterDelay:0.0];
    [self performSelector:@selector(rotate2:) withObject:params afterDelay:cycle/3];
    [self performSelector:@selector(rotate3:) withObject:params afterDelay:2*cycle/3];
}

+ (void)makeView:(UIView *)view wobbleWithAngle:(CGFloat)angle andDuration:(CGFloat)duration{
    NSArray *params = [NSArray arrayWithObjects:view, [NSNumber numberWithFloat:angle], [NSNumber numberWithFloat:duration], nil];
    
    [self performSelector:@selector(wobbleLeft:) withObject:params afterDelay:0.0];
    [self performSelector:@selector(wobbleRight:) withObject:params afterDelay:duration/3];
    [self performSelector:@selector(wobbleMiddle:) withObject:params afterDelay:2*duration/3];
    
}


@end
