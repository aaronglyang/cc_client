//
//  LVShadowTable.h
//  
//
//  Created by lv on 4/30/10.
//  Copyright 2010 Sensky Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LVShadowTable : UITableView {
	
	CAGradientLayer* _originShadow;
	CAGradientLayer* _topShadow;
	CAGradientLayer* _bottomShadow;
}

@end
