//
//  ViewController.h
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tbvRecipes;

+(NSMutableArray *)getArrayOfRecipes;

@end

