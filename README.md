# Ruby on Rails Tutorial sample application

## Reference implementation

This is the reference implementation of the sample application from
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](https://www.railstutorial.org/)
(6th Edition)
by [Michael Hartl](http://www.michaelhartl.com/).

See also the [7th edition README](https://github.com/learnenough/rails_tutorial_sample_app_7th_ed#readme).

## License

All source code in the [Ruby on Rails Tutorial](https://www.railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, first follow the setup steps in [Section 1.1 Up and running](https://www.railstutorial.org/book#sec-up_and_running).

Next, clone the repo and `cd` into the directory:

```
$ git clone https://github.com/mhartl/sample_app_6th_ed.git
$ cd sample_app_6th_ed
```

Also make sure you’re using a compatible version of Node.js:

```
$ nvm install 16.13.0
$ node -v
v16.13.0
```

Then install the needed packages (while skipping any Ruby gems needed only in production):

```
$ yarn add jquery@3.5.1 bootstrap@3.4.1
$ gem install bundler -v 2.2.17
$ bundle _2.2.17_ config set --local without 'production'
$ bundle _2.2.17_ install
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
yarn run cypress run --project ./e2e
```

If the test suite passes, you’ll be ready to seed the database with sample users and run the app in a local server:

```
$ rails db:seed
$ rails server
```

Follow the instructions in [Section 1.2.2 `rails server`](https://www.railstutorial.org/book#sec-rails_server) to view the app. You can then register a new user or log in as the sample administrative user with the email `example@railstutorial.org` and password `foobar`.

## Deploying

To deploy the sample app to production, you’ll need a Heroku account as discussed [Section 1.4 Deploying](https://www.railstutorial.org/book/beginning#sec-deploying).

The full production app includes several advanced features, including sending email with [SendGrid](https://sendgrid.com/) and storing uploaded images with [AWS S3](https://aws.amazon.com/s3/). As a result, deploying the full sample app can be rather challenging. The suggested method for testing a deployment is to use the branch for Chapter 10 (“Updating users”), which doesn’t require more advanced settings but still includes sample users.

To deploy this version of the app, you’ll need to create a new Heroku application, switch to the right branch, push up the source, run the migrations, and seed the database with sample users:

```
$ heroku create
$ git checkout updating-users
$ git push heroku updating-users:main
$ heroku run rails db:migrate
$ heroku run rails db:seed
```

Visiting the URL returned by the original `heroku create` should now show you the sample app running in production. As with the local version, you can then register a new user or log in as the sample administrative user with the email `example@railstutorial.org` and password `foobar`.

## Branches

The reference app repository includes a separate branch for each chapter in the tutorial (Chapters 3–14). To examine the code as it appears at the end of a particular chapter (with some slight variations, such as occasional exercise answers), simply check out the corresponding branch using `git checkout`:

```
$ git checkout <branch name>
```

A full list of branch names appears as follows (preceded the number of the corresponding chapter in the book):

```
 3. static-pages
 4. rails-flavored-ruby
 5. filling-in-layout
 6. modeling-users
 7. sign-up
 8. basic-login
 9. advanced-login
10. updating-users
11. account-activation
12. password-reset
13. user-microposts
14. following-users
```

For example, to check out the branch for Chapter 7, you would run this at the command line:

```
$ git checkout sign-up
```

## Help with the Rails Tutoiral

Experience shows that comparing code with the reference app is often helpful for debugging errors and tracking down discrepancies. For additional assistance with any issues in the tutorial, please consult the [Rails Tutorial Help page](https://www.railstutorial.org/help).

Suspected errors, typos, and bugs can be emailed to <support@learnenough.com>. All such reports are gratefully received, but please double-check with the [online version of the tutorial](https://www.railstutorial.org/book) and this reference app before submitting.

## Cypress test

```
$ yarn run cypress run --project ./e2e
```
