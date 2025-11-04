import {
  addTrigger,
  addRule,
  createTask,
  cleanUpAutomation,
  addComponentMainBranchClick,
  saveAndEnable,
  navigateToTheLastCreatedIssue
} from "../../support/rules/utils"
import {addCreateIssueAction} from "../../support/rules/actions"

describe("Create issue action", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Create another issue when issue created", () => {
    it("creates a new rule for issue created", () => {
      addRule("Issue Created Rule", "This rule clones an issue when an issue is created");
      addTrigger("issue_created");
      addComponentMainBranchClick();
      addCreateIssueAction("My subject", "My description")
      saveAndEnable()

      cy.contains("Issue Created Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and issue created", () => {
      createTask("Test Issue for Creation", "This issue is created to test auto assignment on creation.");
      navigateToTheLastCreatedIssue()
      cy.contains("New");
      cy.contains("My subject");
      cy.contains("My description");
      // cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});