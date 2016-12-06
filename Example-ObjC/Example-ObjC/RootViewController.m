//
//  RootViewController.m
//  Example-ObjC
//
//  Created by Anton Morozov on 12/6/16.
//  Copyright © 2016 Anton Morozov. All rights reserved.
//

#import "RootViewController.h"
#import "ZowdowSDK.h"

@interface RootViewController () <ZowdowSuggestionsLoaderDelegate>
    
@property (nonatomic, retain) ZowdowSuggestionsLoader *suggestionsLoader;
@property (nonatomic, retain) ZowdowSuggestionsContainer *suggestionsContainer;
@property (nonatomic, assign) ZowdowCarouselType carouselType;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _carouselType = ZowdowRotaryCarouselType;
    
    [ZowdowSDK sharedInstance].appKey = @"some key";
    
    _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchField becomeFirstResponder];
    
    _suggestionsLoader = [[ZowdowSuggestionsLoader alloc] init];
    _suggestionsLoader.delegate = self;
    
    [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.tableView.rowHeight = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void)textFieldDidChange :(UITextField *)theTextField{
    [_suggestionsLoader loadSuggestionsForFragment: theTextField.text];
}

- (IBAction)changeCarouselAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Carousel Types" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [self addAction:@"Linear" toAlertController:alertController];
    [self addAction:@"Linear B" toAlertController:alertController];
    [self addAction:@"Cards" toAlertController:alertController];
    [self addAction:@"Cover Flow" toAlertController:alertController];
    [self addAction:@"Rotary" toAlertController:alertController];
    [self addAction:@"Inline" toAlertController:alertController];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)addAction:(NSString*)title toAlertController:(UIAlertController*)controller
{
    UIAlertAction* act = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _carouselType = [controller.actions indexOfObject:action];
        [self.tableView reloadData];
    }];
    [controller addAction:act];
}
    
#pragma mark - ZowdowSuggestionsLoaderDelegate

-(void)zowdowSuggestionsLoader:(ZowdowSuggestionsLoader *)loader didReceiveSuggestions:(ZowdowSuggestionsContainer *)container
{
    _suggestionsContainer = container;
    [self.tableView reloadData];
}

-(void)zowdowSuggestionsLoader:(ZowdowSuggestionsLoader *)loader didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_suggestionsContainer) {
        return _suggestionsContainer.suggestionsCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CarouselCell"];
    if (_suggestionsContainer) {
        ZowdowSuggestionCellConfiguration *config = [ZowdowSuggestionCellConfiguration defaultConfiguration];
        cell = [_suggestionsContainer cellForTableView:tableView atIndexPath:indexPath configuration:config cardsCarouselType:_carouselType];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
