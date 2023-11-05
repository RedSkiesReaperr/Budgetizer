# Budgetizer

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

2. Run setup app:
    ```shell
    make install
    ```

3. Setup API:
    ```shell
    cd api/
    bundle install
    rails db:setup
    rails s
    ```

4. Setup front end:
    ```shell
    cd web/
    yarn install
    yarn dev
    ```

> *API should now be accessible locally at [this adress](http://localhost:3000).*
>
> *Frontend should be accessible locally at [this address](http://localhost:3001).*
