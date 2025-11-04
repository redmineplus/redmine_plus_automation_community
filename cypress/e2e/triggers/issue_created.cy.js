import { addTrigger, addRule, createTask, cleanUpAutomation } from "../../support/rules/utils"
import { addEditIssueAssignToMeAction } from "../../support/rules/actions"

describe("Issue created trigger", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Auto assign when issue was created", () => {
    it("creates a new rule for task created and assigned", () => {
      addRule("Task Created Rule", "This rule assigns a user when a task is created");
      addTrigger("issue_created");
      cy.get("input[data-testid=add-component-main-branch]").click();
      addEditIssueAssignToMeAction();

      cy.contains("Task Created Rule");
      cy.contains("Enabled");
    });

    it("creates a task", () => {
      createTask("Test Task created and assigned", "This task is created to test auto assignment on creation.");
      cy.reload();
      cy.contains("New");
      cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    })
  })
});