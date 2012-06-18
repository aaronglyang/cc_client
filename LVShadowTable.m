//
//  LVShadowTable.m
//  
//
//  Created by lv on 4/30/10.
//  Copyright 2010 Sensky Co., Ltd. All rights reserved.
//

#import "LVShadowTable.h"

static const CGFloat kShadowHeight        = 20.0;
static const CGFloat kShadowInverseHeight = 10.0;

@implementation LVShadowTable

- (CAGradientLayer*)shadowAsInverse:(BOOL)inverse {
	
	CAGradientLayer* newShadow = [[[CAGradientLayer alloc] init] autorelease];
	CGRect newShadowFrame = CGRectMake(0.0, 0.0,
									   self.frame.size.width,
									   inverse ? kShadowInverseHeight : kShadowHeight);
	newShadow.frame = newShadowFrame;
	
	CGColorRef darkColor = [UIColor colorWithRed:0.0
										   green:0.0
											blue:0.0
										   alpha:inverse ?
							(kShadowInverseHeight / kShadowHeight) * 0.5
												: 0.5].CGColor;
	CGColorRef lightColor = [self.backgroundColor
							 colorWithAlphaComponent:0.0].CGColor;
	
	newShadow.colors = [NSArray arrayWithObjects:
						(id)(inverse ? lightColor : darkColor),
						(id)(inverse ? darkColor : lightColor),
						nil];
	return newShadow;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	// Initialize the shadow layers.
	if (nil == _originShadow) {
		
		_originShadow = [self shadowAsInverse:NO];
		[self.layer insertSublayer:_originShadow atIndex:0];
		
	} else if (![[self.layer.sublayers objectAtIndex:0] isEqual:_originShadow]) {
		
		[_originShadow removeFromSuperlayer];
        _originShadow = [self shadowAsInverse:NO];
		[self.layer insertSublayer:_originShadow atIndex:0];
	}
	
	[CATransaction begin];
	[CATransaction setValue: (id)kCFBooleanTrue
					 forKey: kCATransactionDisableActions];
//	NSLog(@"_originShadow.frame[%@]", NSStringFromCGRect(_originShadow.frame));
	CGRect originShadowFrame = _originShadow.frame;
	originShadowFrame.size.width = self.frame.size.width;
	originShadowFrame.origin.y = self.contentOffset.y;
	_originShadow.frame = originShadowFrame;
	
	[CATransaction commit];
	
	// Remove the table cell shadows if there aren't any cells.
	NSArray* indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	if (0 == [indexPathsForVisibleRows count]) {
		
		[_topShadow removeFromSuperlayer];
		[_topShadow release];
		_topShadow = nil;
		
		[_bottomShadow removeFromSuperlayer];
		[_bottomShadow release];
		_bottomShadow = nil;
		return;
	}
	
	// Assumptions at this point: There are cells.
	NSIndexPath* firstRow = [indexPathsForVisibleRows objectAtIndex:0];
	
	// Check whether or not the very first row is visible.
	if (0 == [firstRow section]
		&& 0 == [firstRow row]) {
		
		UIView* cell = [self cellForRowAtIndexPath:firstRow];
		
		// Create the top shadow if necessary.
		if (nil == _topShadow) {
			
			_topShadow = [[self shadowAsInverse:YES] retain];
			[cell.layer insertSublayer:_topShadow atIndex:0];
			
		}  else if ([cell.layer.sublayers indexOfObjectIdenticalTo:_topShadow] != 0) {
			
			[_topShadow removeFromSuperlayer];
			[cell.layer insertSublayer:_topShadow atIndex:0];
		}
		
		CGRect shadowFrame = _topShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = -kShadowInverseHeight;
		_topShadow.frame = shadowFrame;
		
	} else {
		
		[_topShadow removeFromSuperlayer];
		[_topShadow release];
		_topShadow = nil;
	}
	
	NSIndexPath* lastRow = [indexPathsForVisibleRows lastObject];
	
	// Check whether or not the very last row is visible.
	if ([lastRow section] == [self numberOfSections] - 1
		&& [lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1) {
		
		UIView* cell = [self cellForRowAtIndexPath:lastRow];
		
		if (nil == _bottomShadow) {
			
			_bottomShadow = [[self shadowAsInverse:NO] retain];
			[cell.layer insertSublayer:_bottomShadow atIndex:0];
			
		}  else if ([cell.layer.sublayers indexOfObjectIdenticalTo:_bottomShadow] != 0) {
			
			[_bottomShadow removeFromSuperlayer];
			[cell.layer insertSublayer:_bottomShadow atIndex:0];
		}
		
		CGRect shadowFrame = _bottomShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = cell.frame.size.height;
		_bottomShadow.frame = shadowFrame;
		
	} else {
		[_bottomShadow removeFromSuperlayer];
		[_bottomShadow release];
		_bottomShadow = nil;
	}
}

@end
