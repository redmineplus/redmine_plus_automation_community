import {
  addTrigger,
  addRule,
  createTask,
  cleanUpAutomation,
  addComponentMainBranchClick,
  saveAndEnable,
  navigateToTheLastCreatedSubtask
} from "../../support/rules/utils"
import {addCreateSubTaskAction} from "../../support/rules/actions"

describe("Create subtask action", () => {
  beforeEach(() => {
    cy.login();
  });

  describe("Create subtask when issue created", () => {
    it("creates a new rule for issue created", () => {
      addRule("Issue Created Rule", "This rule clones an issue when an issue is created");
      addTrigger("issue_created");
      addComponentMainBranchClick();
      addCreateSubTaskAction("My subtask subject", "My subtask description")
      saveAndEnable()

      cy.contains("Issue Created Rule");
      cy.contains("Enabled");
    });

    it("creates subtask when issue created", () => {
      createTask("Test Issue for Creation", "This issue is created to test auto assignment on creation.");
      cy.wait(1000);
      cy.reload();
      navigateToTheLastCreatedSubtask()
      cy.contains("New");
      cy.contains("My subtask subject");
      cy.contains("My subtask description");
      // cy.get(".assigned-to").should("contain", "Test User");
    });

    it("cleans up the automation", () => {
      cleanUpAutomation();
    });
  });
});