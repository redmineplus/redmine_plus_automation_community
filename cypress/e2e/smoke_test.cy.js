describe("Redmine Plugin Smoke Test", () => {
  beforeEach(() => {
    cy.visit("/login");
    cy.get("#username").type("test"); // Replace with your test credentials
    cy.get("#password").type("12345678");
    cy.get("input[name=login]").click();
  });

  it("Checks if Redmine and the plugin are running", () => {
    cy.visit("/"); // Home page
    cy.contains("Redmine"); // Verify Redmine is running
    cy.contains("Sign out"); // Verify the it's logged in
  });
});