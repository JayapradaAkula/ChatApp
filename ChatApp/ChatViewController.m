//
//  ViewController.m
//  ChatApp
//
//  Created by Jayaprada on 17/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import "ChatViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserCell.h"
#import "UILabel+UILabel_Height_Lines.h"

#define MENTION_NON_WORD_PATTEREN       [NSString stringWithFormat:@"\\B@\\w\\S*\\b"]
#define NAME_PREFIX                     [NSString stringWithFormat:@"@"]
//#define EMOJI_PATTERN                   [NSString stringWithFormat:@"\\(((.|\n)*?)\\)"]
#define EMOJI_PATTERN                   [NSString stringWithFormat:@"\\([^()]+[a-zA-Z]\\)"]

#define URL_PATTERN                     [NSString stringWithFormat:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"]
#define SUCCESS_NOTIFICATION            [NSString stringWithFormat:@"SUCCESS"]
#define FONT_1              [UIFont fontWithName:FONT_NAME size:14.0f]
#define FONT_NAME          [NSString stringWithFormat:@"%@",@"Helvetica Neue"]


@interface ChatViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate>
{
    NSMutableArray *sampleInputs;
    NSMutableArray *sampleOutputs;
    NSMutableDictionary *dict ;
    
    BOOL    isLinkFound;
    UIView          *loadingView;
    
    long int        currentIndex;

}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successCompleteNotification:)
                                                 name:SUCCESS_NOTIFICATION
                                               object:nil];
    
    loadingView = [[UIView alloc]initWithFrame:self.view.frame];//CGRectMake(420, 350, 80, 80)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = self.view.frame;
    activityIndicator.center = self.view.center;
    activityIndicator.tintColor = [UIColor blackColor];
    [loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [self.view addSubview:loadingView];
    
    [loadingView bringSubviewToFront:_collectionView];
    [loadingView setHidden:NO];

    
    UINib *cellNib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"userCell"];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;// UIRectEdge.None

    _submitBtn.enabled = NO;
    
    
    sampleInputs = [NSMutableArray new];
    sampleOutputs = [NSMutableArray new];
    currentIndex = 0;
    
    [self fillDataSource];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fillDataSource
{
    [sampleInputs addObject:@"@chris you around?"];
    [sampleInputs addObject:@"Good morning! (megusta) (coffee)"];
    [sampleInputs addObject:@"Olympics are starting soon;http://www.nbcolympics.com"];
    [sampleInputs addObject:@"@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"];
    [self fetchData:currentIndex];
}

-(void)fetchData:(long int)index
{
    if( index< sampleInputs.count)
    {
        NSString *input = [sampleInputs objectAtIndex:index];
        if( input.length > 1)
            [self convertToJSON:input];
    }

}

-(void)convertToJSON:(NSString*)string
{
    isLinkFound = NO;
    [loadingView setHidden:NO];

    dict = [NSMutableDictionary new];
    
    // MENTIONS
    NSMutableArray *mentionList = [NSMutableArray new];
    
    NSRange   searchedRange = NSMakeRange(0, [string length]);
    NSError  *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: MENTION_NON_WORD_PATTEREN options:0 error:&error];
    NSArray* matches = [regex matchesInString:string options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        NSString* matchText = [string substringWithRange:[match range]];
        if( [ matchText hasPrefix:NAME_PREFIX ])
        {
            matchText = [matchText substringFromIndex:[NAME_PREFIX length]];
            [mentionList addObject:matchText];
        }
    }
    if(mentionList.count > 0 )
    {
        [dict setObject:mentionList forKey:@"mentions"];
    }
    
    
    // EMOTICONS
    NSMutableArray *emojiList = [[NSMutableArray alloc] init];
    error = nil;
    regex = [NSRegularExpression regularExpressionWithPattern:EMOJI_PATTERN options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error)
    {
        NSArray *allMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *aMatch in allMatches)
        {
            NSRange matchRange = [aMatch range];
            NSString *foundString = [string substringWithRange:NSMakeRange(matchRange.location+1, matchRange.length-2)];
            
            if(( foundString.length <= 15 ) && (foundString.length) )
                [emojiList addObject:foundString];
        }
    }
    if( emojiList.count > 0 )
        [dict setObject:emojiList forKey:@"emoticons"];
    
    // URL DETECTION
    
    NSMutableArray *linkList = [NSMutableArray new];
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    [detector enumerateMatchesInString:string
                               options:0
                                 range:NSMakeRange(0, string.length)
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         isLinkFound = YES;
         
         if (result.resultType == NSTextCheckingTypeLink)
         {
             // NSLog(@"matched: %@",result.URL.absoluteString);
             [loadingView setHidden:NO];
             ;

             if ([self validateUrl:result.URL.absoluteString])
             {
                 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                 
                 manager.responseSerializer = [AFJSONResponseSerializer new];
                 
                 NSString *strUrl =  [NSString stringWithFormat:@"http://api.embed.ly/1/oembed?key=9e262634b2954a64b86e5521e9041101&url=%@&maxwidth=100&maxheight=100&format=json",result.URL.absoluteString];
                 
                
                 
                 
                 [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                  {
//                        NSLog(@"Response data = %@",responseObject);
                      NSString *pageTitle = [NSString stringWithFormat:@"%@ | %@",[responseObject valueForKey:@"title"], [responseObject valueForKey:@"provider_name"]];
                      NSMutableDictionary *linkDict = [NSMutableDictionary new];
                      
                      [linkDict setObject:result.URL.absoluteString forKey:@"url"];
                      [linkDict setObject:pageTitle forKey:@"title"];
                      [linkList addObject:linkDict];
                      
                      if( linkList.count > 0 )
                          [dict setObject:linkList forKey:@"links"];
                      
                      [[NSNotificationCenter defaultCenter]
                       postNotificationName:SUCCESS_NOTIFICATION
                       object:self];
                      
                      
                      return;
                      
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      
                      [loadingView setHidden:YES];

                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [alertController addAction:ok];
                      [self presentViewController:alertController animated:YES completion:nil];
                  }];
             }
             else
             {
                 [loadingView setHidden:YES];

                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 [self presentViewController:alertController animated:YES completion:nil];
                 
             }
         }
     }];
    
    if( !isLinkFound)
    {
        [self encodedOutput];
        
    }
}

- (BOOL) validateUrl: (NSString *) candidate
{
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", URL_PATTERN];
    return [urlTest evaluateWithObject:candidate];
}

- (void)successCompleteNotification:(NSNotification *) notification
{
    if( [notification.name isEqualToString:SUCCESS_NOTIFICATION] )
    {
        [self encodedOutput];
    }
}


-(void)encodedOutput
{
    [loadingView setHidden:YES];

    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *strData = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    NSString *escapedJSONString = [strData stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    NSLog(@"%@", escapedJSONString);
    
    if( escapedJSONString.length > 4 )
    {
        [sampleOutputs addObject:escapedJSONString];
        [_collectionView reloadData];
        
            currentIndex++;
        [self fetchData:currentIndex];
        

        NSInteger section = [self.collectionView numberOfSections] - 1;
        NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
        
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sampleOutputs.count-1 inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];

        //[self storeData:json];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:NSLocalizedString(@"Oops!try again!", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void)storeData:(NSData*)encodedString
{
    // WRITING IN TO PLIST FILE
    NSError *error = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:encodedString options:NSJSONReadingAllowFragments error:&error];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"pListFile.plist"];
    
    //                     NSLog(@"plistPath...:%@", plistPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"pListFile" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    [JSON writeToFile:plistPath atomically: YES];
}



#pragma mark TEXTFEILD METHODS


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if( string.length > 0 )
        _submitBtn.enabled = YES;

    return YES;
}

#pragma mark TEXTFEILD METHODS
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bottomViewTopConstraint.constant = 300.0f;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    _bottomViewTopConstraint.constant = 10.0f;
    
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    [textField resignFirstResponder];
    
    return YES;
}




#pragma mark COLLECTION VIEW MTHODS
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsZero;
//}
//
//-(CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 0);
//    
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int currentWidth = self.view.frame.size.width;
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout sectionInset];
    int fixedWidth = currentWidth - (sectionInset.left + sectionInset.right);
    

    NSString *str = [sampleOutputs objectAtIndex:indexPath.item];
    CGFloat height = [UILabel heightForText:str font:FONT_1 withinWidth:_collectionView.frame.size.width];
    int numberOfLines = [UILabel numberOfLines:str font:FONT_1 withinWidth:_collectionView.frame.size.width];
    
    CGFloat deltaHeight = height/numberOfLines;
    height = (numberOfLines+1)*deltaHeight;
    
    
    return CGSizeMake(fixedWidth, height+self.view.frame.size.height/8.0f);

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int numberOfSections = 1;
    
    return  numberOfSections;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  sampleOutputs.count;
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //   LAZY LOADING TEST
    
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"userCell";
    UserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLbl.text = [NSString stringWithFormat:@"Player :%d", (int)indexPath.item];
    cell.subLbl.text = [sampleOutputs objectAtIndex:indexPath.item];
    cell.subLbl.textColor = [UIColor darkTextColor];
    return cell;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)onSumbit:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.enabled = NO;
    
    [sampleInputs addObject:_textFeild.text];
    [self fetchData:sampleInputs.count-1];
   //[self convertToJSON:_textFeild.text];
    _textFeild.text = @"";
}
@end
