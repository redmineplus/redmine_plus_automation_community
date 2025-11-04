import { selectors } from "../../support/selectors";

describe("Rules CRUD operations", () => {
  describe("global rules", () => {
    beforeEach(() => {
      cy.visit("/login");
      cy.get("#username").type("test");
      cy.get("#password").type("12345678");
      cy.get("input[name=login]").click();
      cy.visit("/automation_rules");
    });

    it("creates a new rule for all projects", () => {
      cy.get(".contextual .icon-add").should("be.visible");
      cy.get(".contextual .icon-add").click();

      cy.wait(1000)
      //wait for the form to be visible
      cy.get("#automation_rule_form").should("be.visible");
      // name="automation_rule[name]"
      cy.get('input[name="automation_rule[name]"]').type("New Rule");
      cy.get("#automation_rule_description").type("This is a new rule");
      cy.get("#automation_rule_is_for_all").click();
      cy.get("input[testid=submit-automation]").click();
      cy.contains("New Rule");
      cy.contains("Disabled");
      cy.contains("Save and enable");
      cy.contains("Add a trigger");
    });

    it("checks the rule in the project", () => {
      cy.visit("/projects/test-project-1/automation_rules");
      cy.contains("New Rule");
      cy.contains('No data to display').should('not.exist')
      cy.visit("/projects/test-project-2/automation_rules");
      cy.contains("New Rule");
      cy.contains('No data to display').should('not.exist')
    });

    it("edits a rule from index page", () => {
      cy.get(".icon-actions").click();
      cy.get("#context-menu .icon-settings").click();
      cy.get("#automation_rule_name").clear().type("Edited Rule");
      cy.get("#automation_rule_description").clear().type("This is an edited rule");
      cy.get("#automation_rule_form input[name=commit]").click();
      cy.contains("Automation");
      cy.contains("Edited Rule");
      cy.contains("This is an edited rule");
    });

    it("edits a rule from show page", () => {
      cy.contains("Edited Rule").click();
      cy.get(".contextual .icon-actions").click();
      cy.get(".contextual .icon-settings").click();
      cy.get("#automation_rule_name").clear().type("Edited Rule in show page");
      cy.get("#automation_rule_description").clear().type("This is an edited rule in show page");
      cy.get("#automation_rule_form input[name=commit]").click();
      cy.contains("Edited Rule in show page");
      cy.contains("Disabled");
      cy.contains("Save and enable");
      cy.contains("Add a trigger");
    });

    it("deletes a rule", () => {
      cy.get(".icon-actions").click();
      cy.get(".icon-del").click();
      cy.contains("Automation");
      cy.contains("No data to display");
    });
  });

  describe("project rules", () => {
    beforeEach(() => {
      cy.visit("/login");
      cy.get("#username").type("test");
      cy.get("#password").type("12345678");
      cy.get("input[name=login]").click();
      cy.visit("/projects/test-project-1/automation_rules");
    });

    it("creates a new rule for a project", () => {
      cy.get(".icon-add").click();
      cy.get("#automation_rule_name").type("New Rule");
      cy.get("#automation_rule_description").type("This is a new rule");
      cy.get("input[testid=submit-automation]").click();
      cy.contains("New Rule");
      cy.contains("Disabled");
      cy.contains("Save and enable");
      cy.contains("Add a trigger");
    });

    it("checks the rule in the project", () => {
      cy.contains("New Rule");
      cy.contains('No data to display').should('not.exist')
    });

    it("checks the rule a different project", () => {
      cy.visit("/projects/test-project-2/automation_rules");
      cy.contains('No data to display')
    });

    it("edits a rule from index page", () => {
      cy.get(".icon-actions").click();
      cy.get("#context-menu .icon-settings").click();
      cy.get("#automation_rule_name").clear().type("Edited Rule");
      cy.get("#automation_rule_description").clear().type("This is an edited rule");
      cy.get("#automation_rule_form input[name=commit]").click();
      cy.contains("Automation");
      cy.contains("Edited Rule");
      cy.contains("This is an edited rule");
    });

    it("edits a rule from show page", () => {
      cy.contains("Edited Rule").click();
      cy.get(".contextual .icon-actions").click();
      cy.get(".contextual .icon-settings").click();
      cy.get("#automation_rule_name").clear().type("Edited Rule in show page");
      cy.get("#automation_rule_description").clear().type("This is an edited rule in show page");
      cy.get("#automation_rule_form input[name=commit]").click();
      cy.contains("Edited Rule in show page");
      cy.contains("Disabled");
      cy.contains("Save and enable");
      cy.contains("Add a trigger");
    });

    it("deletes a rule", () => {
      cy.get(".icon-actions").click();
      cy.get(".icon-del").click();
      cy.contains("Automation");
      cy.contains("No data to display");
    });
  });
});
