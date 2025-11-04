import React from 'react'
import App from '../components/App'

describe('<App />', () => {
    it('renders', () => {
        // see: https://on.cypress.io/mounting-react
        cy.mount(<App />)
    })

    it('Simple Rule', () => {
        cy.mount(<App />)
        cy.get('.triggersSearch__results__item').first().click()
        cy.get('.ruleNode').should('have.length', 1)

        cy.get('[data-testid="add-component-main-branch"]').click()
        cy.get('.ruleNode').should('have.length', 2)

        cy.get('.rulesSidebar-action-item').first().click()
        cy.get('.ruleNode').should('have.length', 2)

        expect(cy.get('.ruleNode.action.selected')).to.exist
    })

    // it('adds a condition', () => {
    //     cy.mount(<App />)
    //     cy.get('[data-testid="add-component-main-branch"]').first().click()
    //     cy.get('.node').should('have.length', 2)
    // })
})