import { addTrigger, addRule, createTask, cleanUpAutomation } from "../../support/rules/utils"
import { addEditIssueAssignToMeAction } from "../../support/rules/actions"

describe("Issue comment edited trigger", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Auto assign when issue comment edited", () => {
    it("creates a new rule for issue comment edited", () => {
      addRule("Issue Comment Edited Rule", "This rule assigns a user when an issue comment is edited");
      addTrigger("issue_comment_updated");
      cy.get("input[data-testid=add-component-main-branch]").click();
      addEditIssueAssignToMeAction();

      cy.contains("Issue Comment Edited Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and edits a comment", () => {
      createTask("Test Issue for Comment Editing", "This issue is created to test comment editing.");
      cy.reload();
      cy.contains("New");
      cy.get(".assigned-to").should("not.contain", "Test User");

      // add a comment on the issue
      cy.get(".contextual .icon-edit").first().click();
      cy.get("#issue_notes").clear().type("This is an edited test comment.");
      cy.get("input[type=submit]").contains("Submit").click();

      // edit the comment

      cy.get(".journal-actions .icon-edit").first().click();
      cy.get(".jstBlock .jstEditor .wiki-edit").first().clear().type("A new updated comment.");
      cy.get("input[type=submit]").contains("Save").click();
      cy.wait(1000);

      cy.reload();
      cy.contains("A new updated comment.");
      cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });

  });
});