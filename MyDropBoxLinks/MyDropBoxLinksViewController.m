//
//  MyDropBoxLinksViewController.m
//  MyDropBoxLinks
//
//  Created by Charles Konkol on 3/29/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
#import <DropboxSDK/DropboxSDK.h>
#import "MyDropBoxLinksViewController.h"

@interface MyDropBoxLinksViewController ()

@end

@implementation MyDropBoxLinksViewController
@synthesize tblView=tblView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dropboxURLs = [[NSMutableArray alloc] init];
    [self didPressLink];
    
    [[self restClient] loadMetadata:@""];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tblView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tblView release];
    [super dealloc];
}
- (IBAction)btnDropbox:(id)sender {
    [self didPressLink];
    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSString *filename = @"Info.plist";
    NSString *destDir = @"/";
    [[self restClient] uploadFile:filename toPath:destDir
                    fromPath:localPath];
    [[self restClient] loadMetadata:@"/"];
    [self.tblView reloadData];

}
- (void)didPressLink {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
}
- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        [dropboxURLs removeAllObjects];
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
            [dropboxURLs addObject:file.filename];
        }
    }
    
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
}



- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    NSLog(@"File loaded into path: %@", localPath);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dropboxURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [dropboxURLs objectAtIndex:indexPath.row];
    
    return cell;
}


@end
