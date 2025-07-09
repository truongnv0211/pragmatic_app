describe('Login page', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at e2e/app_commands/clean.rb
    cy.visit('/login')
  })

  it('should show form log in', () => {
    cy.get('h1').should('contain.text', 'Log in')

    cy.get('form[action="/login"]').should('exist')

    cy.get('label[for="session_email"]').should('contain.text', 'Email')
    cy.get('input#session_email[type="email"][name="session[email]"]').should('exist')

    cy.get('label[for="session_password"]').should('contain.text', 'Password')
    cy.get('input#session_password[type="password"][name="session[password]"]').should('exist')

    cy.get('a[href="/password_resets/new"]').should('contain.text', '(forgot password)')

    cy.get('input[type="checkbox"][name="session[remember_me]"]').should('exist')
    cy.get('label[for="session_remember_me"]').should('contain.text', 'Remember me on this computer')

    cy.get('input[type="submit"][name="commit"]').should('have.value', 'Log in')
  })

  it('click button login with valid email&password', function() {
    cy.appFactories([
      ['create', 'user']
    ]).then((records) => {
      let user = records[0]
      cy.get('input[name="session[email]"]').type(user.email)
      cy.get('input[name="session[password]"]').type('password')
      cy.get('input[type="submit"]').click()
      cy.url().should('include', '/users/')
    })
  })

  it('click button login with invalid email&password', function() {
    cy.get('input[name="session[email]"]').type('invalid_email@domain.local')
    cy.get('input[name="session[password]"]').type('invalid_password')
    cy.get('input[type="submit"]').click()
    cy.get('.alert.alert-danger').should('contain.text', 'Invalid email/password combination')
  })
})
