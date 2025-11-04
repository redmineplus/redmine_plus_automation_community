export const addRule = (name, description) => {
  cy.visit("/automation_rules");
  cy.get("a[href='/automation_rules/new']").click();
  cy.get('input[name="automation_rule[name]"]').type(name);
  cy.get("#automation_rule_description").type(description);
  cy.get("#automation_rule_is_for_all").click();
  cy.get("input[testid=submit-automation]").click();
}
export function addTrigger(selectorType) {
  cy.get(`#trigger--${selectorType}`).click();
}

export const createTask = (subject, description) => {
  cy.visit("/projects/test-project-1/issues/new");
  cy.get("#issue_subject").type(subject);
  cy.get("#issue_description").type(description);
  cy.get("#issue_status_id").select("New");
  cy.get("input[name=commit]").click();

  cy.contains(subject);
}

export const cleanUpAutomation = () => {
  cy.visit("/automation_rules");
  cy.get(".icon-actions.js-contextmenu").each(($el) => {
    cy.wrap($el).should("be.visible");
    cy.wrap($el).wait(500).click();
    cy.get(".icon.icon-del").click();
  });
  cy.contains("No data to display");
}

export const navigateToTheRule = () => {
  cy.visit("/automation_rules");
  cy.get("td a").first().click();
}

export const navigateToRulePipeline = () => {
  navigateToTheRule();
  cy.get(".icon-time").first().click();
  cy.get(".icon-logs").first().click();
}

export const addComponentMainBranchClick = () => {
  cy.get("input[data-testid=add-component-main-branch]").click();
}

export const navigateToTheLastCreatedIssue = () => {
  cy.visit("/issues");
  cy.get(".issue .id a").first().click();
}

export const navigateToTheLastCreatedSubtask = () => {
  cy.get(".issue .subject a").first().click();
}

export const updateCurrentIssue = (subject) => {
  cy.get(".contextual .icon-edit").first().click();
  cy.get("#issue_subject").clear().type(subject);
  cy.get("input[type=submit]").contains("Submit").click();
  // cy.wait(1000);
}

export const clickNext = () => cy.get('.triggerFormActions input[name="Next"]').click();
export const saveAndEnable = () => cy.get('a[data-testid=save-rule-button]').click();