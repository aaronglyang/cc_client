//
//  ReplyViewController.m
//  cocoachin3
//
//  Created by 国良 on 12-5-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ReplyViewController.h"


@implementation ReplyViewController
@synthesize reTitle,tid,successFlag,topicTitle;
@synthesize reContent,naviBar,replyButton;

@synthesize twitterDic;
@synthesize parserObjects;
@synthesize currentText;
@synthesize currentElementName;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSString * myTitle = [NSString stringWithFormat:@"Re:%@",self.topicTitle];
	self.reTitle.text = myTitle;
 
}
- (void) back {
 	[self.navigationController popViewControllerAnimated:YES];
}
 
-(IBAction) viratulkeyhidden:(id)sender{
	[reTitle resignFirstResponder];
	[reContent resignFirstResponder];
}
- (IBAction)reTopic:(id)sender {
	NSString *myTid = self.tid;
	//NSString *myTid = @"105615";
 	NSString *myReTitle = reTitle.text;
	NSString *myReContent = reContent.text;
  	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	
  	NSString* myMethod=@"cocoachina.bbs.topic.reply";
	
	NSString *myToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]; 
 	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
 	
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@content%@method%@subject%@tid%@timestamp%@token%@%@",app_secret,app_key,myReContent,myMethod,myReTitle,myTid,currentDateStrInit,myToken,app_secret];
 	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	NSString * encodTitle = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				NULL,
																				(CFStringRef)myReTitle,
																				NULL,
																				(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				kCFStringEncodingUTF8 );
	NSString * encodContent = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  NULL,
																				  (CFStringRef)myReContent,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8 );
	
	NSString* myUrl = @"http://api.cocoachina.com/?tid=%@&content=%@&subject=%@&timestamp=%@&app_key=%@&method=%@&sign=%@&token=%@";
 	myUrl = [NSString stringWithFormat:myUrl,myTid,encodContent,encodTitle,currentDateStr,app_key,myMethod,md5sign,myToken];
 	NSURL* url = [NSURL URLWithString:myUrl];
	flag=1;
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == reTitle ||theTextField == reContent  ) {
        [theTextField resignFirstResponder];
    }
	
    return YES;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if (!tmpMutableData) {
        tmpMutableData =  [[NSMutableData alloc] initWithData:data]; //[NSMutableData dataWithData:data];
    } else {
        [tmpMutableData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
    if (0 < [tmpMutableData length]) {
		NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);  
		NSString* str = [[NSString alloc] initWithData:tmpMutableData encoding:enc];
		[tmpMutableData release];
		
		tmpMutableData = nil;
		NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
		NSXMLParser* parser = [NSXMLParser alloc];
		[parser initWithData:postData];
		[parser setDelegate:self];
		[parser parse];
		[parser release];
    }
}

#pragma mark NSXMLParserDelegate--->
- (void )parserDidStartDocument:(NSXMLParser *)parser
{
	
	self.twitterDic = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
	self.parserObjects = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
	
}



- (void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString :@"success" ]) // 找节点进行解析
	{
		NSMutableDictionary *newNode = [[ NSMutableDictionary alloc ] initWithCapacity : 0 ];
		[self.parserObjects addObject :newNode];
		self.twitterDic = newNode;
		self.currentElementName = @"success";
	}	
	
	
}

- (void )parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	self.currentText = [[ NSString alloc] initWithString:string];
}

- (void )parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
 	
 	if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ]   )
	{	
 		self.successFlag  = self.currentText;
	}
	
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//	int errorid  =	[parseError code];
}

-(void )parserDidEndDocument:(NSXMLParser *)parser// 得到的解析结果
{  		
	NSString *myToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]; 
	if(!myToken){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请先登陆！"   
													   delegate:self   
											  cancelButtonTitle:@"确定"  
											  otherButtonTitles:nil];  
		[alert show];
		//	LoginViewController *loginViewController = [[LoginViewController alloc] init];
		//		//loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		//		//[self presentModalViewController:firstViewController animated:YES];
		//		[self.navigationController pushViewController:loginViewController animated:YES];
	}
	if (self.successFlag) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"回复成功"   
													   delegate:self   
											  cancelButtonTitle:@"确定"  
											  otherButtonTitles:nil];  
		[alert show];
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"回复失败，"   
													   delegate:self   
											  cancelButtonTitle:@"确定"  
											  otherButtonTitles:nil];  
		[alert show];
	}
	
}


- (void)dealloc {
    [super dealloc];
}


@end
