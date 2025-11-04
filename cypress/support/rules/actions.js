export const addAssignToTestUserAction = () => {
  cy.get('.rulesSidebar-action-item').first().click()
  cy.get('#action--assign_issue').click()
  cy.get('.intervalValue div').first().click();
  cy.contains('.intervalValue div[role="option"]', 'specific user').click();
  cy.get('.rulesSidebar-form div').last().click();
  cy.contains('.rulesSidebar-form div[role="option"]', 'Test User').click();
  cy.get('.triggerFormActions input[name="Next"]').click();
  cy.get('a[data-testid=save-rule-button]').click();
}

export const addDeleteIssueAction = () => {
  cy.get('.rulesSidebar-action-item').first().click()
  cy.get('#action--delete_issue').click()
}

export const addLinkIssueAction = () => {
  cy.get('.rulesSidebar-action-item').first().click()
  cy.get('#action--link_issue').click()
  cy.get('.linkTypeField div').first().click()
  cy.contains('.rulesSidebar-form div[role="option"]', 'is duplicate of').click();

  cy.get('.linkIssueField div').first().click()
  cy.contains('.rulesSidebar-form div[role="option"]', 'Most recent created issue').click();
}

export const addCreateIssueAction = (subject=null, description=null) => {
  cy.get('.rulesSidebar-action-item').first().click()
  cy.get('#action--create_issue').click()
  cy.get('#textInput-subject').type(subject || 'Test Issue for Deletion');
  cy.get('#textareaInput-description').type(description || 'This issue is created to test deletion.');
  // cy.get('.rulesSidebar-form div').first().click();
  // cy.contains('.rulesSidebar-form div[role="option"]', 'Assignee').click();
  // cy.get('.rulesSidebar-form div').first().click();
  // cy.get('.issueFieldName--assigned_to_id div').first().click();
  // cy.contains('.rulesSidebar-form div[role="option"]', '<< me >>').click();
}

export const addCreateSubTaskAction = (subject=null, description=null) => {
  cy.get('.rulesSidebar-action-item').first().click()
  cy.get('#action--create_subtask').click()
  cy.get('#textInput-subject').type(subject || 'Test Issue for Deletion');
  cy.get('#textareaInput-description').type(description || 'This issue is created to test deletion.');
  // cy.get('.rulesSidebar-form div').first().click();
  // cy.contains('.rulesSidebar-form div[role="option"]', 'Assignee').click();
  // cy.get('.rulesSidebar-form div').first().click();
  // cy.get('.issueFieldName--assigned_to_id div').first().click();
  // cy.contains('.rulesSidebar-form div[role="option"]', '<< me >>').click();
}

export const addLogAction = (text) => {
  cy.get('.rulesSidebar-action-item').first().click();
  cy.get('#action--log_action').click();
  cy.get('.rulesSidebar-form input[type="text"]').first().type(text);
  cy.get('.triggerFormActions input[name="Next"]').click();
  cy.get('a[data-testid=save-rule-button]').click();
}

export const addEditIssueAssignToMeAction = () => {
  cy.get('.rulesSidebar-action-item').first().click();
  cy.get('#action--edit_issue').click();
  cy.get('.rulesSidebar-form div').first().click();
  cy.contains('.rulesSidebar-form div[role="option"]', 'Assignee').click();
  cy.get('.rulesSidebar-form div').first().click();
  cy.get('.intervalValue div').first().click();
  cy.contains('.rulesSidebar-form div[role="option"]', '<< me >>').click();
  cy.get('.triggerFormActions input[name="Next"]').click();
  cy.get('a[data-testid=save-rule-button]').click();
}

export const addCloneIssueAction = () => {
  cy.get('.rulesSidebar-action-item').first().click();
  cy.get('#action--clone_issue').click();
  cy.get('.rulesSidebar-form div').first().click();
  cy.contains('.rulesSidebar-form div[role="option"]', 'Assignee').click();
  cy.get('.rulesSidebar-form div').first().click();
  cy.get('.issueFieldName--assigned_to_id div').first().click();
  cy.contains('.rulesSidebar-form div[role="option"]', '<< me >>').click();
  cy.get('.triggerFormActions input[name="Next"]').click();
  cy.get('a[data-testid=save-rule-button]').click();
}

export const addCommentOnIssueAction = (comment) => {
  cy.get('.rulesSidebar-action-item').first().click();
  cy.get('#action--comment_issue').click();
  cy.get('.textareaInput-wrapper').type(comment || 'Default comment');
}