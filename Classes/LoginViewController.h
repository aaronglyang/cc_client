//
//  SecondViewController.h
//  cocoachin3
//
//  Created by 国良 on 12-5-24.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController
<NSXMLParserDelegate> {
    UITextField *username;
	UITextField *password;
    UILabel *label;
    NSString *string;
	UIButton *login;
	int flag;
	NSMutableDictionary* twitterDic;
	NSMutableArray* parserObjects;
	NSString* currentText;
	NSString* currentElementName;
	UINavigationBar *naviBar;
	NSString *token;
	NSString *success;
	UILabel *flagLable;
 }
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *flagLable;
@property (nonatomic, retain) IBOutlet UIButton *login;

 @property (nonatomic, copy) NSString *string;
@property(nonatomic, retain) NSString* currentElementName;
@property(nonatomic, retain) NSString* currentText;
@property(nonatomic, retain) NSString* token;
@property(nonatomic, retain) NSString* success;
@property(nonatomic, retain) NSMutableArray* parserObjects;
@property(nonatomic, retain) NSMutableDictionary* twitterDic;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;

- (void)loginCocoachina;
- (void)loginOutCocoachina;
-(IBAction) viratulkeyhidden:(id)sender;
@end
 
