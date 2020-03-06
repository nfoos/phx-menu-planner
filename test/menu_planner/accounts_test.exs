defmodule MenuPlanner.AccountsTest do
  use MenuPlanner.DataCase

  alias MenuPlanner.Accounts
  alias MenuPlanner.Accounts.User

  @valid_attrs %{email: "some email", name: "some name", password: "123456"}
  @update_attrs %{email: "some updated email", name: "some updated name", password: "654321"}
  @invalid_attrs %{email: nil, name: nil}

  describe "list_users/0" do
    test "returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end
  end

  describe "get_user/1" do
    test "returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user(user.id) == user
    end
  end

  describe "get_user!/1" do
    test "returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end
  end

  describe "get_user_by/1" do
    test "returns the user with given param" do
      user = insert(:user)
      assert Accounts.get_user_by(email: user.email) == user
    end
  end

  describe "create_user/1" do
    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "enforces unique email" do
      assert {:ok, %User{id: id}} = Accounts.create_user(@valid_attrs)
      assert {:error, changeset} = Accounts.create_user(@valid_attrs)

      assert %{email: ["has already been taken"]} = errors_on(changeset)

      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "requires password to be at least 6 chars long" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      {:error, changeset} = Accounts.create_user(attrs)

      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end

  describe "update_user/2" do
    test "with valid data updates the user" do
      user = insert(:user)
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "change_user/1" do
    test "returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authenticate_by_email_and_pass/2" do
    @pass "123456"

    setup do
      {:ok, user: insert(:user, password_hash: Pbkdf2.hash_pwd_salt(@pass))}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} = Accounts.authenticate_by_email_and_pass(user.email, @pass)

      assert auth_user.id == user.id
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_email_and_pass(user.email, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} = Accounts.authenticate_by_email_and_pass("unknownuser", @pass)
    end
  end
end
