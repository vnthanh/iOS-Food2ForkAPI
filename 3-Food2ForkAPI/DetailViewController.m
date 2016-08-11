//
//  DetailViewController.m
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"
#import "Recipe.h"

@interface DetailViewController ()
// get from ViewController (prev vc)
@property (nonatomic, retain) NSMutableArray*arrayOfRecipes;
@property int recipeCount;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrayOfRecipes = [ViewController getArrayOfRecipes];
    _recipeCount = (int)_arrayOfRecipes.count;
    
    [self downloadAndParseAndUpdate];
    
    // set bar's back button color
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)downloadAndParseAndUpdate {
    
    Recipe *tempRecipe = _arrayOfRecipes[self.recipeIndex];
    
    // set main title
    self.title = tempRecipe.title;
    
    
    NSString *rID = tempRecipe.recipeID;
    NSString *requestURLString = [NSString stringWithFormat:@"http://food2fork.com/api/get?key=7094f866ecc388982e34015eddfaa2d8&rId=%@", rID];
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    // download and parse
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // parse json
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        // hard-code to get inside json dictionary
        NSDictionary *recipe = [json objectForKey:@"recipe"];
        NSArray *ingredient = [recipe objectForKey:@"ingredients"];
        // done
        
        // download image data from url
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempRecipe.imageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.txtvIngredient.text = [ingredient componentsJoinedByString:@"\n"];
            self.imvRecipeImage.image = image;
            
            // set view controller image, image cover all
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        });
    });
    

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_imvRecipeImage release];
    [_txtvIngredient release];
    [super dealloc];
}
- (IBAction)btnRevDidTouch:(id)sender {
    if(self.recipeIndex > 0)
    {
        self.recipeIndex -= 1;
        [self downloadAndParseAndUpdate];
    }
}

- (IBAction)btnNextDidTouch:(id)sender {
    if(self.recipeIndex < _recipeCount-1)
    {
        self.recipeIndex += 1;
        [self downloadAndParseAndUpdate];
    }
}
@end
