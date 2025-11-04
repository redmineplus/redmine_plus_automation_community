import { addTrigger, addRule, createTask, cleanUpAutomation, updateCurrentIssue } from "../../support/rules/utils"
import { addEditIssueAssignToMeAction } from "../../support/rules/actions"

describe("Issue updated trigger", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Auto assign when issue updated", () => {
    it("creates a new rule for issue updated", () => {
      addRule("Issue Updated Rule", "This rule assigns a user when an issue is updated");
      addTrigger("issue_updated");
      cy.get("input[data-testid=add-component-main-branch]").click();
      addEditIssueAssignToMeAction();

      cy.contains("Issue Updated Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and updates it", () => {
      createTask("Test Issue for Update", "This issue is created to test auto assignment on update.");
      cy.reload();
      cy.contains("New");
      cy.get(".assigned-to").should("not.contain", "Test User");
      updateCurrentIssue("Updated Test Issue")

      cy.reload();
      cy.contains("Updated Test Issue");
      cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});