//
//  FileTransferCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileTransferModel.h"
@interface FileTransferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectContactLabel;




-(void)showCellDataWithModel:(FileTransferModel *)model;

@end