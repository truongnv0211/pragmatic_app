describe('Signup page', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at e2e/app_commands/clean.rb
    cy.visit('/signup')
  })

  it('should display the signup form correctly', () => {
    cy.get('form[action="/users"]').should('exist')

    cy.get('label[for="user_name"]').should('contain.text', 'Name')
    cy.get('input#user_name[type="text"][name="user[name]"]').should('exist')

    cy.get('label[for="user_email"]').should('contain.text', 'Email')
    cy.get('input#user_email[type="email"][name="user[email]"]').should('exist')

    cy.get('label[for="user_password"]').should('contain.text', 'Password')
    cy.get('input#user_password[type="password"][name="user[password]"]').should('exist')

    cy.get('label[for="user_password_confirmation"]').should('contain.text', 'Confirmation')
    cy.get('input#user_password_confirmation[type="password"][name="user[password_confirmation]"]').should('exist')

    cy.get('input[type="submit"][name="commit"]').should('have.value', 'Create my account')
  })

  it('successfully creates a new user with valid inputs', () => {
    cy.get('input[name="user[name]"]').type('Example User')
    cy.get('input[name="user[email]"]').type('user@example.com')
    cy.get('input[name="user[password]"]').type('password123')
    cy.get('input[name="user[password_confirmation]"]').type('password123')

    cy.get('input[type="submit"]').click()

    cy.hash().should('equal', '')
    cy.contains('Example User')
  })

  it('displays error messages for invalid submission', () => {
    cy.get('input[type="submit"]').click()

    cy.get('div#error_explanation').should('exist')
    cy.get('div#error_explanation').should('contain.text', 'error')
  })

  it('shows error when email is already taken', () => {
    cy.appFactories([
      ['create', 'user']
    ]).then((records) => {
      let user = records[0]

      cy.get('input[name="user[name]"]').type(user.name)
      cy.get('input[name="user[email]"]').type(user.email)
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[name="user[password_confirmation]"]').type('password123')

      cy.get('input[type="submit"]').click()

      cy.get('div#error_explanation').should('exist')
      cy.get('div#error_explanation').should('contain.text', 'Email has already been taken')
    })
  })

  it('shows error when password and confirmation do not match', () => {
    cy.get('input[name="user[name]"]').type('Mismatch User')
    cy.get('input[name="user[email]"]').type('mismatch@example.com')
    cy.get('input[name="user[password]"]').type('password123')
    cy.get('input[name="user[password_confirmation]"]').type('different123')

    cy.get('input[type="submit"]').click()

    cy.get('div#error_explanation').should('exist')
    cy.get('div#error_explanation').should('contain.text', "Password confirmation doesn't match")
  })

  it('shows error when password is too short', () => {
    cy.get('input[name="user[name]"]').type('ShortPass User')
    cy.get('input[name="user[email]"]').type('shortpass@example.com')
    cy.get('input[name="user[password]"]').type('123')
    cy.get('input[name="user[password_confirmation]"]').type('123')

    cy.get('input[type="submit"]').click()

    cy.get('div#error_explanation').should('exist')
    cy.get('div#error_explanation').should('contain.text', 'Password is too short')
  })
})
