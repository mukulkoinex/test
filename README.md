# Test

This is a sample elixir app that deomnstrates the basics of phoenix, genservers and ecto. The application basically creates an in-memory priority queue with a persistent postgres/timescale layer. It also exposes apis to push and pop values from the queue. Also in case of any application crashes, the events from timescale will be replayed to generate the queue to the latest state.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
