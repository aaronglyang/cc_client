//
//  ReplyViewController.h
//  cocoachin3
//
//  Created by 国良 on 12-5-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReplyViewController : UIViewController
<NSXMLParserDelegate> {
	UINavigationBar *naviBar;
	NSString * topicTitle;
 	UITextField *reTitle;
	UITextView *reContent;
	NSString * tid;
	UIButton *replyButton;
	NSMutableDictionary* twitterDic;
	NSMutableArray* parserObjects;
	NSString* currentText;
	NSString* currentElementName;
	NSMutableData* tmpMutableData;
	int flag;
	NSString * successFlag;
}
@property (nonatomic, retain) UINavigationBar *naviBar;
@property(nonatomic,retain) IBOutlet UITextField *reTitle;
@property(nonatomic,retain) IBOutlet UITextView *reContent;
@property(nonatomic,retain) IBOutlet UIButton *replyButton;
@property(nonatomic,retain) NSString *tid;
@property (nonatomic,retain) NSString *successFlag;
@property (nonatomic,retain) NSString * topicTitle;
@property(nonatomic, retain) NSString* currentElementName;
@property(nonatomic, retain) NSString* currentText;
@property(nonatomic, retain) NSMutableArray* parserObjects;
@property(nonatomic, retain) NSMutableDictionary* twitterDic;
- (IBAction)reTopic:(id)sender;
-(IBAction) viratulkeyhidden:(id)sender;
@end
