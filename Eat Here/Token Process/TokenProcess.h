//
//  TokenProcess.h
//  Eat Here
//
//  Created by Silstone on 18/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <Foundation/Foundation.h>
// Protocol definition starts here
@protocol SampleProtocolDelegate <NSObject>
@required
- (void) processCompleted;
@end
// Protocol Definition ends here

@interface TokenProcess : NSObject{
    // Delegate to respond back
    id <SampleProtocolDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

-(void)startSampleProcess; // Instance method
@end
