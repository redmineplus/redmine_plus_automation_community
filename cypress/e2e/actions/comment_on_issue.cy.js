import { addTrigger, addRule, createTask, cleanUpAutomation, addComponentMainBranchClick, saveAndEnable } from "../../support/rules/utils"
import { addCommentOnIssueAction } from "../../support/rules/actions"

describe("Comment on issue action", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Comment issue when issue created", () => {
    it("creates a new rule for issue created", () => {
      addRule("Issue Created Rule", "This rule clones an issue when an issue is created");
      addTrigger("issue_created");
      addComponentMainBranchClick();
      addCommentOnIssueAction("My super comment");
      saveAndEnable()

      cy.contains("Issue Created Rule");
      cy.contains("Enabled");
    });

    it("creates an issue and comments it", () => {
      createTask("Test Issue for Creation", "This issue is created to test auto assignment on creation.");
      cy.reload();
      cy.contains("New");
      cy.contains("My super comment");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});