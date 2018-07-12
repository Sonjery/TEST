//
//  MarketOrderCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MarketOrderCell.h"

@implementation MarketOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCellDataWithModel:(MarketOrderModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.ProjectName];
    self.personLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.planDateLabel.text = [NSString stringWithFormat:@"%@",model.CreateDate];
    self.applyBuyDateLabel.text = [NSString stringWithFormat:@"%@",model.MarketDate];
    self.demandDateLabel.text = [NSString stringWithFormat:@"%@",model.OrderDate];
    NSString *stateString;
    switch ([model.State integerValue]) {
        case 0:
            stateString = @"";
            break;
        case 1:
            stateString = @"";
            break;
        case 2:
            stateString = @"已提交未审核";
            break;
        default:
            stateString = @"";
            break;
    }    
    self.currentStateLabel.text = [NSString stringWithFormat:@"   项目当前状态:  %@",stateString];

}
@end
