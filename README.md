# Ruzenkit

---
This project is discontinued. The goal of the project was to be a headless ecommerce CMS.
---

## docker-compose
You can run the project with docker-compose using this command:
```sh
docker-compose run -w /ruzenkit --service-ports api /bin/sh
```
You should have an access to a container with elixir installed. You can follow the phoenix elixir part to run the server.

## Phoenix elixir

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

You can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser to have a graphql playground.
