//
//  ChallengeAttemptCell.h
//  iChallengeEarth
//
//  Created by Administrator on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChallengeAttemptCell : UITableViewCell
{
	IBOutlet UILabel *challengeTitle;
	IBOutlet UILabel *challengeCategorie;
	IBOutlet UILabel *attemptStartTime;
    IBOutlet UIImageView *challengeImage;
}

@property (nonatomic,strong) UILabel *challengeTitle;
@property (nonatomic,strong) UILabel *challengeCategorie;
@property (nonatomic,strong) UILabel *attemptStartTime;
@property (nonatomic,strong) UIImageView *challengeImage;

@end
