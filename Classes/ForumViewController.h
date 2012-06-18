//
//  ForumViewController.h
//  cocoachin3
//
//  Created by 国良 on 12-5-23.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVShadowTable.h"

@interface ForumViewController : UIViewController <NSXMLParserDelegate> {
	IBOutlet LVShadowTable* forumTable;
	NSMutableDictionary* twitterDic;
	NSMutableArray* parserObjects;
	NSMutableDictionary* twitterDic2;
	NSMutableArray* parserObjects2;
	NSString* currentText;
	NSString* currentElementName;
	NSString* nowFid;
	NSString *content;	
	UINavigationBar *naviBar;
	
	int flag;
    
    NSMutableData* tmpMutableData;
}

@property(nonatomic,retain)  NSString* nowFid;
@property(nonatomic, retain) NSString* currentElementName;
@property(nonatomic, retain) NSString* currentText;
@property(nonatomic, retain) NSString* content;
@property(nonatomic, retain) NSMutableArray* parserObjects;
@property(nonatomic, retain) NSMutableDictionary* twitterDic;
@property(nonatomic, retain) NSMutableArray* parserObjects2;
@property(nonatomic, retain) NSMutableDictionary* twitterDic2;
 @property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@end
