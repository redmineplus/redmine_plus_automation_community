import { addTrigger, addRule, createTask, cleanUpAutomation } from "../../support/rules/utils"
import { addEditIssueAssignToMeAction} from "../../support/rules/actions"

describe("Issue created trigger", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Auto assign when issue comment created", () => {
    it("creates a new rule for issue comment created", () => {
      addRule("Issue Comment Created Rule", "This rule assigns a user when an issue comment is created");
      addTrigger("issue_comment_created");
      cy.get("input[data-testid=add-component-main-branch]").click();
      addEditIssueAssignToMeAction();

      cy.contains("Issue Comment Created Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and adds a comment", () => {
      createTask("Test Issue for Comment Creation", "This issue is created to test comment creation.");
      cy.reload();
      cy.contains("New");
      cy.get(".assigned-to").should("not.contain", "Test User");

      // Add a comment to the issue
      cy.get(".contextual .icon-edit").first().click();
      cy.get("#issue_notes").type("This is a test comment.");
      cy.get("input[type=submit]").contains("Submit").click();

      // Verify the comment was added
      cy.reload();
      cy.contains("This is a test comment.");
      cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});