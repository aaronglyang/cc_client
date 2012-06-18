//
//  IssueViewController.h
//  cocoachin3
//
//  Created by 国良 on 12-5-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IssueViewController : UIViewController
<NSXMLParserDelegate> {
	UITextField *mytitle;
	UITextField *myContent;
	UIButton *issueButton;
	UINavigationBar *naviBar;
	NSString *fid;
	
	NSMutableDictionary* twitterDic;
	NSMutableArray* parserObjects;
	NSString* currentText;
	NSString* currentElementName;
	NSMutableData* tmpMutableData;
	int flag;
	NSString * successFlag;

}
@property (nonatomic, retain) IBOutlet UITextField *mytitle;
@property (nonatomic, retain) IBOutlet UITextField *myContent;
@property (nonatomic, retain) IBOutlet UIButton *issueButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic,retain) NSString *successFlag;

@property (nonatomic,retain) NSString *fid;
@property(nonatomic, retain) NSString* currentElementName;
@property(nonatomic, retain) NSString* currentText;
@property(nonatomic, retain) NSMutableArray* parserObjects;
@property(nonatomic, retain) NSMutableDictionary* twitterDic;

- (void)issueTopic;
-(IBAction) textfieldDoneEditing:(id)sender;
-(IBAction) viratulkeyhidden:(id)sender;

@end
