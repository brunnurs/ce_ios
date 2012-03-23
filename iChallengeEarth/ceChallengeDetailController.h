//
//  ceChallengeDetailController.h
//  iChallengeEarth
//
//  Created by Administrator on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Challenge.h"

//Shows the details of the detailChallenge-property
@interface ceChallengeDetailController : UIViewController
{
	Challenge *detailChallenge;
    bool allowStart;
	
	IBOutlet UITextView *description;
	IBOutlet UILabel *cTitle;
	IBOutlet UIImageView *achievement;
	IBOutlet UILabel *category;
	IBOutlet UILabel *difficultyLabel;
	IBOutlet UIImageView *difficultyIcon;
    
    IBOutlet UIBarButtonItem *startButton;
}

@property (nonatomic,strong) Challenge *detailChallenge;
@property bool allowStart;



//private
-(void)updateValues;


@end
