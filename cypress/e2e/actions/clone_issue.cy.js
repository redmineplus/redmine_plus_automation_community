import {
  addTrigger,
  addRule,
  createTask,
  cleanUpAutomation,
  addComponentMainBranchClick,
  navigateToTheLastCreatedIssue,
  saveAndEnable
} from "../../support/rules/utils"
import { addCloneIssueAction } from "../../support/rules/actions"

describe("Cone issue action", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Clone issue when issue created", () => {
    it("creates a new rule for issue created", () => {
      addRule("Issue Clone Rule", "This rule clones an issue when an issue is created");
      addTrigger("issue_created");
      addComponentMainBranchClick();
      addCloneIssueAction();
      saveAndEnable()

      cy.contains("Issue Clone Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and verifies assignment", () => {
      createTask("Test Issue for clone !!!", "Cloned description");
      navigateToTheLastCreatedIssue()

      cy.contains("New");
      cy.contains("Clone of Test Issue for clone !!!");
      cy.contains("Cloned description");
      cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});