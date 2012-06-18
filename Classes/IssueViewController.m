    //
//  IssueViewController.m
//  cocoachin3
//
//  Created by 国良 on 12-5-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IssueViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation IssueViewController
@synthesize mytitle;
@synthesize myContent;
@synthesize issueButton,naviBar,fid,successFlag;
@synthesize twitterDic;
@synthesize parserObjects;
@synthesize currentText;
@synthesize currentElementName;

 
- (void)viewDidLoad {
    [super viewDidLoad];
	//导航条
 
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(back)] autorelease];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"发布" 
																			   style:UIBarButtonItemStyleBordered 
																			  target:self 
																			  action:@selector(issueTopic)] autorelease];

//	UITextField *_textField = [[UITextField alloc] initWithFrame:CGRectMake(55, 135, 235, 212)];
//    _textField.borderStyle = UITextBorderStyleLine;
//    [_textField setEnabled:NO];
//    [self.view addSubview:_textField];
//    [_textField release];
//    
//    myContent = [[UITextView alloc] initWithFrame:CGRectMake(50, 130, 230, 207)];
//    myContent.delegate = self;
//    myContent.backgroundColor = [UIColor clearColor];
//    myContent.scrollEnabled = NO;//受字数限制，不能滑动
//    myContent.font = [UIFont systemFontOfSize:16.0f];
	// [myContent becomeFirstResponder];
//    [self.view addSubview:myContent];
	
}
- (void) back {
 	[self.navigationController popViewControllerAnimated:YES];
}
- (void)issueTopic {
	//NSString *myFid = self.fid;
	NSString *myFid  = @"3";
//    NSString *mytitles = @"test";
//    NSString *myContents = @"testcontents";
	NSString *mytitles = mytitle.text;
    NSString *myContents = myContent.text;
  	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	NSString *myToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]; 
   	NSString* myMethod=@"cocoachina.bbs.topic.add";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
 	
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@content%@fid%@method%@subject%@timestamp%@token%@%@",app_secret,app_key,myContents,myFid,myMethod,mytitles,currentDateStrInit,myToken,app_secret];
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
																				(CFStringRef)mytitles,
																				NULL,
																				(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				kCFStringEncodingUTF8 );
//	NSLog(encodTitle);
	NSString * encodContent = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  NULL,
																				  (CFStringRef)myContents,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8 );
//	NSLog(encodContent);
 	NSString* myUrlInit = @"http://api.cocoachina.com/?fid=%@&content=%@&subject=%@&timestamp=%@&app_key=%@&method=%@&sign=%@&token=%@";
 	NSString *myUrl = [NSString stringWithFormat:myUrlInit,myFid,encodContent,encodTitle,currentDateStr,app_key,myMethod,md5sign,myToken];
 

	
	
 	NSURL* url = [NSURL URLWithString:myUrl];
	flag=1;
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
}
 

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == mytitle ) {
        [mytitle resignFirstResponder];
    }
	if (theTextField == myContent ) {
        [myContent resignFirstResponder];
    }
    return YES;
}

-(IBAction) textfieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction) viratulkeyhidden:(id)sender
{
    // hidden viratulkey
    [mytitle resignFirstResponder];
    [myContent resignFirstResponder];
    
}

//- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
//{
//    UITableViewCell * cell=(UITableViewCell *)[[textField  superview] superview];
//    NSIndexPath *indexPath=[curTable indexPathForCell:cell];
//    if (indexPath.section==0) {
//        
//    }else {
//        [UIView beginAnimati*****:@"ResizeForKeyBoard" context:nil];
//        [UIView setAnimationDuration:0.30f];  
//        point = curTable.center;
//        curTable.center = CGPointMake(160, 120);
//        [UIView commitAnimati*****];
//    }
//    return YES;
//}
//
//- (BOOL)textFieldDidEndEditing:(UITextField *)textField
//{
//    UITableViewCell * cell=(UITableViewCell *)[[textField  superview] superview];
//    NSIndexPath *indexPath=[curTable indexPathForCell:cell];
//    
//    if (indexPath.section==0) {
//        
//    }else {
//        [UIView beginAnimati*****:@"ResizeForKeyBoard" context:nil];
//        [UIView setAnimationDuration:0.30f];  
//        
//        curTable.center = point;
//        [UIView commitAnimati*****];
//    }
//    return YES;
//}

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
														message:@"发布成功"   
													   delegate:self   
											  cancelButtonTitle:@"确定"  
											  otherButtonTitles:nil];  
		[alert show];
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"发布失败，"   
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
