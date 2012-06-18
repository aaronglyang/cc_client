//
//  cocoachin3AppDelegate.h
//  cocoachin3
//
//  Created by 国良 on 12-5-22.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cocoachin3AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIViewController *forumViewController;
	//UINavigationController	*navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain)  UIViewController *forumViewController;
@property (nonatomic,retain) UINavigationController	*navigationController;

@end
