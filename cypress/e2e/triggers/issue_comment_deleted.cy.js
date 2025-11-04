import { addTrigger, addRule, createTask, cleanUpAutomation } from "../../support/rules/utils"
import { addEditIssueAssignToMeAction } from "../../support/rules/actions"

describe("Issue comment deleted trigger", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Auto assign when issue comment deleted", () => {
    it("creates a new rule for issue comment deleted", () => {
      addRule("Issue Comment Deleted Rule", "This rule assigns a user when an issue comment is deleted");
      addTrigger("issue_comment_deleted");
      cy.get("input[data-testid=add-component-main-branch]").click();
      addEditIssueAssignToMeAction()

      cy.contains("Issue Comment Deleted Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and deletes a comment", () => {
      createTask("Test Issue for Comment Deletion", "This issue is created to test comment deletion.");
      cy.reload();
      cy.contains("New");
      cy.get(".assigned-to").should("not.contain", "Test User");

      // Add a comment to the issue
      cy.get(".contextual .icon-edit").first().click();
      cy.get("#issue_notes").type("This is a test comment.");
      cy.get("input[type=submit]").contains("Submit").click();

      // Delete the comment
      cy.get(".journal-actions .icon-actions").first().click();
      cy.get(".journal-actions .icon-del").first().click();
      cy.wait(1000);


      // Verify the comment was deleted and user was assigned
      cy.reload();
      cy.get(".assigned-to").should("contain", "Test User");
    });


    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});