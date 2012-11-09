//
//  ROBaseDialogViewController.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-8-30.
//  Copyright 2011年 renren-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ROBaseDialogViewDelegate <NSObject>

//*******added by goshan
- (void)closeWeb;

@end

@interface ROBaseDialogViewController : UIViewController {
    UIView *_backgroundView;
    UIButton *_cancelButton;
    BOOL _showingKeyboard;
    UIDeviceOrientation _orientation;
    id<ROBaseDialogViewDelegate> delegate;
}

@property (nonatomic,assign) id<ROBaseDialogViewDelegate> delegate;
@property (nonatomic,retain)UIView *backgroundView;
@property (nonatomic,retain)UIButton *cancelButton;

- (void)show;
- (void)close;
- (void)updateSubviewOrientation;
- (void)sizeToFitOrientation:(BOOL)transform;
- (CGRect)fitOrientationFrame;

@end
