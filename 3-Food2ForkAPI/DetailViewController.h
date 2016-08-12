//
//  DetailViewController.h
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *imvRecipeImage;
@property (retain, nonatomic) IBOutlet UITextView *txtvIngredient;

- (IBAction)btnRevDidTouch:(id)sender;
- (IBAction)btnNextDidTouch:(id)sender;

@property int recipeIndex;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end
