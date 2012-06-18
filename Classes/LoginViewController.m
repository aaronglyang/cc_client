    //
//  SecondViewController.m
//  cocoachin3
//
//  Created by 国良 on 12-5-24.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController
@synthesize username;
@synthesize password;
@synthesize label,flagLable,naviBar;
@synthesize string,token,success;
@synthesize login;
@synthesize twitterDic;
@synthesize parserObjects;
@synthesize currentText;
@synthesize currentElementName;

 
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"退出" 
																			   style:UIBarButtonItemStyleBordered 
																			  target:self 
																			  action:@selector(loginOutCocoachina)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"登陆" 
																			   style:UIBarButtonItemStyleBordered 
																			  target:self 
																			  action:@selector(loginCocoachina)] autorelease];
	
	NSString *loginFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]; 
	//self.naviBar.barStyle = UIBarStyleBlackTranslucent;
	//self.naviBar.barStyle = UIBarStyleBlack;
	//self.navigationItem.backBarButtonItem =UIBarStyleBlackTranslucent;
	if (loginFlag) {
		self.flagLable.text = @"已登录";
	}else{
		self.flagLable.text = @"未登录";
	}
	
//	UIImageView *background = [[UIImageView alloc] initWithFrame:   CGRectMake(0,0,320,480)];
//	[background setImage:[UIImage imageNamed:@"LoginBack.png"]];	
//	[self.view addSubview:background]; 
}
 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == username  ) {
        [username resignFirstResponder];
    }
	if (theTextField == password ) {
        [password resignFirstResponder];
    }
    return YES;
}
-(IBAction) viratulkeyhidden:(id)sender{
	[username resignFirstResponder];
	[password resignFirstResponder];
}
 
- (void)loginCocoachina{
	NSString *myUserName = username.text;
	NSString *userpass = password.text;
  	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	
	 const char *cUserpass = [userpass UTF8String]; 
	unsigned char result1[32]; 
	CC_MD5( cUserpass, strlen(cUserpass), result1 ); 
 	NSMutableString *md5passWord = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
		[md5passWord appendFormat:@"%02x",result1[i]];   //md5小写加密  %02x
    } 
//	NSLog(md5passWord);
	//md5passWord = @"1abcf4325d1e3d96da3ec0615a7a7d02";
	NSString* passSign = [NSString stringWithFormat:@"%@%@",md5passWord,app_secret];
	const char *cPassSign = [passSign UTF8String]; 
	unsigned char result2[32]; 
	CC_MD5( cPassSign, strlen(cPassSign), result2 ); 
 	NSMutableString *md5PassSign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
         [md5PassSign appendFormat:@"%02X",result2[i]];   //md5大写加密  %02X
    }
	
	NSString* myMethod=@"cocoachina.member.login";	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
 	
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@method%@timestamp%@username%@userpass%@%@",app_secret,app_key,myMethod,currentDateStrInit,myUserName,md5PassSign,app_secret];
 	
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?timestamp=%@&app_key=%@&method=%@&username=%@&userpass=%@&sign=%@";
  	myUrl = [NSString stringWithFormat:myUrl,currentDateStr,app_key,myMethod,myUserName,md5PassSign,md5sign];
 	NSURL* url = [NSURL URLWithString:myUrl];
	flag=1;
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
  }

- loginOutCocoachina{
	//NSString* myToken = self.token;
	NSString *myToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]; 

  	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	
	NSString* myMethod=@"cocoachina.member.quit";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
 	
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@method%@timestamp%@token%@%@",app_secret,app_key,myMethod,currentDateStrInit,myToken,app_secret];
 	
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?timestamp=%@&app_key=%@&method=%@&token=%@&sign=%@";
	//NSLog(myUrl);
  	myUrl = [NSString stringWithFormat:myUrl,currentDateStr,app_key,myMethod,myToken,md5sign];
 	NSURL* url = [NSURL URLWithString:myUrl];
	flag=2;
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (parserObjects) {
		return [parserObjects count];
	}
	
	return 1;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);  
	NSString* str = [[NSString alloc] initWithData:data encoding:enc];
	NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser* parser = [NSXMLParser alloc];
	[parser initWithData:postData];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
}

#pragma mark NSXMLParserDelegate--->
- (void )parserDidStartDocument:(NSXMLParser *)parser
{
//	if (flag==1) {
//		self.twitterDic = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
//		self.parserObjects = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
//		
//	}
}



- (void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if (flag==1) {
		if ([elementName isEqualToString :@"token" ]) // 找节点进行解析
		{
			self.currentElementName = @"token";
		}
	}else if(flag == 2){
		if ([elementName isEqualToString :@"success" ]) // 找节点进行解析
		{
			self.currentElementName = @"success";
		}
	}
	
	
}

- (void )parser:(NSXMLParser *)parser foundCharacters:(NSString *)str {
	self.currentText = str;
    //[[ NSString alloc] initWithString:string];
}

- (void )parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if (flag==1) {
		if ( self.currentElementName && [elementName isEqualToString :self.currentElementName ])
		{
			self.token = self.currentText;
		}
		
	}else {
		if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ])
		{
			self.success = self.currentText;
			
		}
	}
	
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	int errorid  =	[parseError code];
	NSLog(@"到了这里  错误提示[%d]", errorid);
}

-(void )parserDidEndDocument:(NSXMLParser *)parser// 得到的解析结果
{	
	NSLog(@"得到的解析结果,获取token值：");
 	NSLog(@"token[%@]",self.token);
	if(flag ==1){
	
		if (self.token) {
			self.flagLable.text = @"登陆成功";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"登陆成功"   
														   delegate:self   
												  cancelButtonTitle:@"确定"  
												  otherButtonTitles:nil];  
			[alert show];
			
		}else {
			self.flagLable.text = @"登陆失败";
		}
		
	}else {
		NSLog(self.success);
		if (self.success) {
			self.flagLable.text = @"退出成功";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"退出成功"   
														   delegate:self   
												  cancelButtonTitle:@"确定"  
												  otherButtonTitles:nil];  
			[alert show];
			self.token = nil;
		}else {
			self.flagLable.text = @"退出失败";
		}
	}

	
	
	[[NSUserDefaults standardUserDefaults] setObject:self.token forKey:@"USERTOKEN"] ;
	//self.mytel = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTOKEN"]; 
}

- (void)dealloc {
    [super dealloc];
	[username release];
	[password release];
	[login release];
    [label release];
    [string release];
	
	[success release];
	[twitterDic release];
	[parserObjects release];
    [currentText release];
    [currentElementName release];
	
	[flagLable release];
	[token release];

}

@end