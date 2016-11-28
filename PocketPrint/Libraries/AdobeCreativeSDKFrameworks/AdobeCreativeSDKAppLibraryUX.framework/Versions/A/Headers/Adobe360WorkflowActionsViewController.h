/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

/**************************************************************************
 * [PRIVATE BETA] CreativeSync enables seamless multi-app workflows via
 * the included APIs. If you have any questions, please contact us at
 * https://creativesdk.zendesk.com/hc/en-us/requests/new
 *************************************************************************/

#ifndef Adobe360WorkflowActionsVCHeader
#define Adobe360WorkflowActionsVCHeader

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Adobe360WorkflowAction;
@class Adobe360WorkflowActionDataSource;
@class Adobe360MessageBuilder;

/*
 * This block is called for every action in the action registry & the dynamically 
 * added actions as well. A positve value prioritizes the action. Return 0 or negative value if
 * the action need not be prioritized.
 *
 * For example, if the values are 25, 3, 100, -1. The actions corresponding to positive values are
 * ordered in the descending order 100 will be first action, next 25 & then 3. The action with -1 
 * will be placed in the regular section below the priotrized section.
 */
typedef NSInteger (^adobe360ActionPriorityBlock) (Adobe360WorkflowAction *action);

/**
 *  The Adobe360WorkflowSenderDelegate protocol defines methods for
 *  responding to user interaction events and message handling events
 *  on the actions view controller. You must implement this protocol on
 *  the delegate of the status bar view controller.
 */
@protocol Adobe360WorkflowSenderDelegate <NSObject>

/**
 * Called by the action controller to add the necessary information to
 * the message builder. This information includes:
 *  - inputs: for most messages, inputs should be specified. If the action type is
 *    "capture", inputs will not be specified.
 *  - requestContext: the context information. This already be partially filled out
 * using the information already available to the action view controller.
 *  - appSpecificData: any other information needed by your application to
 * reconstruct the state while sending the message
 *
 * @see [Adobe360MessageBuilder addInputAsset:withError:]
 * @see [Adobe360MessageBuilder requestContext]
 * @see [Adobe360MessageBuilder appSpecificData]
 * @see Adobe360Context
 *
 * @param messageBuilder The message builder that will be used to construct the response.
 */
- (void)updateMessageBuilder:(Adobe360MessageBuilder *)messageBuilder forAction:(Adobe360WorkflowAction *)action;

/**
 * A required method for the delegate of the action view controller.
 * This method will be called when an error is encountered while preparing and
 * sending the 360 message.
 *
 * @param error The Adobe360Error object.
 * @param error The Adobe360MessageBuilder that incurred the error.
 * @see Adobe360Error
 */
- (void)errorSendingMessage:(NSError *)error messageBuilder:(Adobe360MessageBuilder *)messageBuilder;

/**
 * Called by the Adobe360ActionViewController when the UIViewController containing 
 * the action view controller should be dismissed as a result of clicking the cancel 
 * button. The Adobe360ActionViewController does not dismiss itself, so you should 
 * call dismissViewControllerAnimated on the Adobe360ActionViewController or its 
 * container when this delegate method
 * is called.
 */
- (void)didCancelActionViewController;

@optional
/**
 * Called by the action view controller when the user selects an action.
 * Can be used to indicate that we should not proceed with the action.
 *
 * @param action The action that will be sent.
 * @return YES if the controller should prepare a message for this action.
 * Return NO if it should not continue.
 * @see Adobe360WorkflowAction
 */
- (BOOL)shouldSelectAction:(Adobe360WorkflowAction *)action;

/**
 * Called by the Adobe360WorkflowActionsViewController when the message has begun packaging and
 * being dispatched. The progress object can be used to show user facing progress or for
 * cancelling the operation.
 *
 * @param messageBuilder The message builder object in the process of being packaged.
 * @param progress An NSProgress object representing the progress of the packaging/sending operation.
 * @see Adobe360MessageBuilder
 */
- (void)beganPackagingMessage:(Adobe360MessageBuilder *)messageBuilder
                 withProgress:(NSProgress *)progress;

/**
 * Called by the Adobe360WorkflowActionsViewController when the message has been successfully
 * sent to the secondary application. The integrating application should clean up any UI elements
 * and state displayed for preparing the message.
 *
 * @param messageBuilder The message builder object representing the message sent.
 * @see Adobe360MessageBuilder
 */
- (void)didLaunchMessage:(Adobe360MessageBuilder *)messageBuilder;

/**
 * This method will be called when an error is encountered loading the action registry.
 * Depending on the use cases, this may or may not be a critical error. See 
 * Adobe360WorkflowActionDataSource addActionToRegistry for more information on
 * explicitly specifying your actions.
 *
 * @param error The NSError object encountered by the registry loading mechanism.
 */
- (void)errorLoadingActionRegistry:(NSError *)error;

/**
 * Called by the Adobe360WorkflowActionsViewController when its content size is changed
 * @param size The new size of the content
 */
- (void)contentDidChangeToSize:(CGSize)size;

@end

/**
 * In the primary app (initiator) of the workflow, you can show this UIViewController
 * to provide the user with a set of actions to present to the user for selection.
 *
 * This view controller is designed to be displayed as a popover on iPad or
 * modally on iPhone. It is recommended to use UIPresentationPopoverController for
 * presenting this view controller.
 */
@interface Adobe360WorkflowActionsViewController : UIViewController

/**
 * The delegate object for callbacks.
 */
@property (weak, nonatomic) id <Adobe360WorkflowSenderDelegate> actionDelegate;

/*
 * This block is called for every action in the action registry & the dynamically
 * added actions as well. A positve value prioritizes the action. Return 0 or negative value if
 * the action need not be prioritized.
 *
 * For example, if the values are 25, 3, 100, -1. The actions corresponding to positive values are
 * ordered in the descending order 100 will be first action, next 25 & then 3. The action with -1
 * will be placed in the regular section below the priotrized section.
 */
@property (copy, nonatomic) adobe360ActionPriorityBlock prioritizeBlock;

/**
 * The underlying action data source used to populate the view controller. This data
 * source is read only, and updates to the object will not be reflected until the next
 * view load.
 *
 * @see Adobe360WorkflowActionDataSource
 */
@property (strong, nonatomic, readonly) Adobe360WorkflowActionDataSource *dataSource;

/**
 * Creates an instance of the Adobe360WorkflowAppLibraryController object. This should be presented in
 * a popover on iPad and modally on iPhone.
 */
+ (instancetype)instantiateWorkflowActionsViewController;

/**
 * A array of NSString objects. This array is used to whitelist actions that include
 * a specific subtype. All actions by all apps that match this subtype will be shown.
 * If this is not specified or is empty, the action view controller
 * will display only the actions that do not have a specified type.
 */
- (void)setWhitelistedSubTypes:(NSArray *)whitelistedSubTypes;

/**
 * A array of NSString objects. This array is used to whitelist actions that include
 * a specific action id. All apps that match the actionIds will be shown.
 * If this is not specified or is empty, the action view controller
 * will display only the actions that do not have a specified type.
 *
 * If this is specified, the whitelistedSubTypes property will be ignored.
 */
- (void)setWhitelistedActionIds:(NSArray *)whitelistedActionIds;

/**
 * Set to YES to only show actions whitelisted by the arrays.
 * If NO, general actions, actions without a subtype, and other default actions, will always be
 * shown below the list of specified actions.
 *
 * NO by default.
 */
- (void)setShowOnlyWhitelistedActions:(BOOL)showOnlyWhitelistedActions;

/**
 * A array of Adobe360SupportedAction objects. This array is used to filter the 
 * action types & corresponding media types explicitly supported.
 *
 * @see Adobe360SupportedAction
 */
- (void)setSupportedActionTypes:(NSArray *)suppportedTypes;

/**
 * The method allows to add actions dynamically to ActionsViewController.
 * Clients can use this method to add necessary actions not present in action registry.
 * 
 *
 * @param action An Adobe360WorkflowAction instance that needs to be added.
 */
- (void)addActionToRegistry:(Adobe360WorkflowAction *)action;

/**
 * Override the displayed list of actions. If you need to change the list of actions
 * displayed, set this variable to the list to diplay. If set to nil, the action view
 * controller will consult the Adobe360WorkflowActionDataSource.
 * 
 * By default, this is nil.
 */
- (void)setExplicitActionList:(NSArray *)actionList;

@end

#endif
