//
//  ItemsSelectionTableViewController.h
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsSelectionTableViewController;
@protocol ItemsSelectionTableViewCallback <NSObject>

- (void)viewController:(ItemsSelectionTableViewController *)viewController didSelectRow:(int)selection Mode:(int)_mode;

@end

enum ItemsSelectionTableViewControllerMode {
    ItemsSelectionTableViewControllerMode_LED,
    ItemsSelectionTableViewControllerMode_Remote,
    ItemsSelectionTableViewControllerMode_Setting,
    ItemsSelectionTableViewControllerMode_StuntSelection,
};

@interface ItemsSelectionTableViewController : UITableViewController {
    
}

@property (nonatomic, readwrite) NSArray                                *arrItems;
@property (assign, readwrite) int                                       mode;
@property (nonatomic, readwrite) id<ItemsSelectionTableViewCallback>    delegate;

@end
