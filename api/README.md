# BudgetizerApi [![CircleCI](https://dl.circleci.com/status-badge/img/gh/RedSkiesReaperr/BudgetizerApi/tree/main.svg?style=svg&circle-token=fc9e7827ec863982becbe2ea066bc5d218f12789)](https://dl.circleci.com/status-badge/redirect/gh/RedSkiesReaperr/BudgetizerApi/tree/main) [![Rails Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop-rails)

BudgetizerApi is a backend Ruby on Rails project designed to manage and track personal budgets.

## Requirements

- Ruby v3.2.2
- Ruby on Rails v7.0.6
- PostgreSQL v16
- Go v1.21.3

## Getting Started

To get a copy of the project up and running on your local machine, follow these steps:

1. Clone the repository:
    ```shell
    git clone https://github.com/RedSkiesReaperr/Budgetizer.git
    ```

2. Install the required gems by running the following command in the project directory:
    ```shell
    bundle install
    ```

3. Set up the database with the necessary schema and seed data:
    ```shell
    rails db:setup
    ```

4. Launch the Rails server:
    ```shell
    rails server
    ```

5. The application should now be accessible locally at `http://localhost:3000`.

## Dependencies

BudgetizerApi relies on the following gems:

- **faker**: A library for generating fake data to assist with testing and
  development. [GitHub Repo](https://github.com/faker-ruby/faker)
- **rspec-rails**: A testing framework for writing and executing Ruby
  tests. [GitHub Repo](https://github.com/rspec/rspec-rails)
- **rubocop**: A code style checking and formatting tool to ensure consistent code
  quality. [GitHub Repo](https://github.com/rubocop/rubocop)
- **rubycritic**: A gem that generates code quality reports based on RubyCritic
  scores. [GitHub Repo](https://github.com/whitesmith/rubycritic)
- **simplecov**: A code coverage analysis tool to track how much of the codebase is being
  tested. [GitHub Repo](https://github.com/simplecov-ruby/simplecov)
- **brakeman**: A security scanning tool that detects potential security vulnerabilities in the
  code. [GitHub Repo](https://github.com/presidentbeef/brakeman). Use with: `bundle exec brakeman --color -o tmp/brakeman.html`
- **jsonapi-resources**: A gem for building JSON:API compliant APIs. [GitHub Repo](https://github.com/cerebris/jsonapi-resources)
- **devise**: Flexible authentication solution for Rails based on Warden. [GitHub Repo](https://github.com/heartcombo/devise)
- **devise_token_auth**: Token based authentication for Rails JSON APIs. [GitHub Repo](https://github.com/lynndylanhurley/devise_token_auth)
