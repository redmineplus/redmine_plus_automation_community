import {
  addTrigger,
  addRule,
  createTask,
  cleanUpAutomation,
  addComponentMainBranchClick,
  saveAndEnable,
  updateCurrentIssue
} from "../../support/rules/utils"
import {addDeleteIssueAction} from "../../support/rules/actions"

describe("Delete issue action", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Deletes issue when issue created", () => {
    it("creates a new rule for to delete issue", () => {
      addRule("Issue Created Rule", "This rule clones an issue when an issue is created");
      addTrigger("issue_updated");
      addComponentMainBranchClick();
      addDeleteIssueAction()
      saveAndEnable()

      cy.contains("Issue Created Rule");
      cy.contains("Enabled");
    });

    it("deletes an issue when issue created", () => {
      createTask("Test Issue for Creation", "This issue is created to test auto assignment on creation.");
      cy.contains("New");
      updateCurrentIssue("Updated Test Issue")
      cy.reload()
      cy.contains("404");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});