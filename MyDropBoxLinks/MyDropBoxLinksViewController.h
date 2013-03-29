//
//  MyDropBoxLinksViewController.h
//  MyDropBoxLinks
//
//  Created by Charles Konkol on 3/29/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDropBoxLinksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    DBRestClient *restClient;
    NSMutableArray *dropboxURLs;
}
@property (retain, nonatomic) IBOutlet UITableView *tblView;

- (IBAction)btnDropbox:(id)sender;

@end
