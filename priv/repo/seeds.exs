# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MenuPlanner.Repo.insert!(%MenuPlanner.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query, only: [from: 2]

alias MenuPlanner.Accounts
alias MenuPlanner.Accounts.User
alias MenuPlanner.Repo

if Repo.one(from User, select: count()) == 0 do
  Accounts.create_user(%{name: "Admin", email: "admin", password: "secret"})
end
