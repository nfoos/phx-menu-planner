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
alias MenuPlanner.Menus
alias MenuPlanner.Menus.Menu
alias MenuPlanner.Repo

if Repo.one(from User, select: count()) == 0 do
  Accounts.create_user(%{name: "Admin", email: "admin", password: "secret"})
end

for service_type <- ~w(Lunch Dinner) do
  Menus.create_service_type!(service_type)
end

if Mix.env() == :dev do
  if Repo.one(from Menu, select: count()) == 0 do
    {:ok, menu} = Menus.create_menu(%{name: "Test Menu"})

    Menus.create_meal_service(%{
      date: "2020-05-24",
      menu_id: menu.id,
      menu_items: [
        %{name: "Pancakes Plain & Blueberry"},
        %{name: "Scrambled Eggs"},
        %{name: "Bacon"},
        %{name: "Sliced Watermelon"}
      ],
      name: "Brunch",
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-24",
      menu_id: menu.id,
      menu_items: [
        %{name: "Chicken Stir Fry"},
        %{name: "Lo Mein"},
        %{name: "Vegetarian Stir Fry"},
        %{name: "Spring Rolls"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-05-25",
      menu_id: menu.id,
      menu_items: [],
      name: "No Service",
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-25",
      menu_id: menu.id,
      menu_items: [],
      name: "No Service",
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-05-26",
      menu_id: menu.id,
      menu_items: [
        %{name: "Buffalo & BBQ Quesadillas"},
        %{name: "Cheese Quesadilla"},
        %{name: "Rice"},
        %{name: "Beans"},
        %{name: "Queso"}
      ],
      name: nil,
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-26",
      menu_id: menu.id,
      menu_items: [
        %{name: "Salmon with Lemon Dill Sauce"},
        %{name: "Lemon Herb Couscous Salad"},
        %{name: "Brussel Sprouts"},
        %{name: "Mushroom Goulash"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-05-27",
      menu_id: menu.id,
      menu_items: [],
      name: "Omelet Station",
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-27",
      menu_id: menu.id,
      menu_items: [
        %{name: "Pot Roast with Stewed Vegetables"},
        %{name: "Hearty Vegetable Stew"},
        %{name: "Green Beans w/ Goat Cheese & Rosemary"},
        %{name: "Corn Casserole"},
        %{name: "Caramel Strudel Cake"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-05-28",
      menu_id: menu.id,
      menu_items: [
        %{name: "Poke Bowls w/ Assorted Add-ins"},
        %{name: "White or Brown Rice"},
        %{name: "Steamed Bao Buns"},
        %{name: "Sesame Pear Tofu Stirfry"}
      ],
      name: nil,
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-28",
      menu_id: menu.id,
      menu_items: [
        %{name: "Turkey Chili"},
        %{name: "Chickpea Chili"},
        %{name: "Garlic Bread"},
        %{name: "Baked Potatoes w/ Add-ins"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-05-29",
      menu_id: menu.id,
      menu_items: [
        %{name: "Eggplant Parmesan"},
        %{name: "Baked Ziti"},
        %{name: "Caesar Salad"},
        %{name: "Garden Salad"},
        %{name: "Mixed Vegetables"}
      ],
      name: nil,
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-31",
      menu_id: menu.id,
      menu_items: [
        %{name: "Egg White Frittata"},
        %{name: "Scrambled Eggs"},
        %{name: "Bacon"},
        %{name: "Mixed Fruit"}
      ],
      name: "Brunch",
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-05-31",
      menu_id: menu.id,
      menu_items: [
        %{name: "Peach & Ginger Glazed Salmon, Chicken or Tofu"},
        %{name: "Brown Rice"},
        %{name: "Honey Glazed Carrots"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-06-01",
      menu_id: menu.id,
      menu_items: [
        %{name: "Chicken & Asparagus Skillet"},
        %{name: "White Rice"},
        %{name: "Steamed Broccoli"}
      ],
      name: nil,
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-06-01",
      menu_id: menu.id,
      menu_items: [
        %{name: "Roasted Ham"},
        %{name: "Potatoes Au Gratin"},
        %{name: "Asparagus"},
        %{name: "Spinach Stuffed Portabellas"},
        %{name: "Dinner Roll"},
        %{name: "Apple Pie"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-06-02",
      menu_id: menu.id,
      menu_items: [
        %{name: "BBQ Chicken or Tofu Tacos"},
        %{name: "Rice & Beans"},
        %{name: "Chips & Queso"},
        %{name: "Pico, Guac, Sour Cream"}
      ],
      name: nil,
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-06-02",
      menu_id: menu.id,
      menu_items: [
        %{name: "Pepper Steak"},
        %{name: "Sundried Tomato Vermincelli"},
        %{name: "Green Bean & Barley Medley"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-06-03",
      menu_id: menu.id,
      menu_items: [
        %{name: "Celery & Carrots"},
        %{name: "Eggplan Fries"},
        %{name: "Mixed Fruit"}
      ],
      name: "Wing Wednesday",
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-06-03",
      menu_id: menu.id,
      menu_items: [
        %{name: "Sweet & Sour Shrimp or Tofu"},
        %{name: "Rice Noodles"},
        %{name: "Chow Mein"},
        %{name: "Egg Rolls"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-06-04",
      menu_id: menu.id,
      menu_items: [
        %{name: "Balsamic Roasted Chicken"},
        %{name: "Arugula, Mango, Avacado Salad"},
        %{name: "Roasted Red Potato Medley"}
      ],
      name: nil,
      service_type_id: 1
    })

    Menus.create_meal_service(%{
      date: "2020-06-04",
      menu_id: menu.id,
      menu_items: [
        %{name: "Paprika Pork, Chicken or Mushroom"},
        %{name: "Wild Rice"},
        %{name: "Roasted Sweet Potato and Brussel Sprout Medley"}
      ],
      name: nil,
      service_type_id: 2
    })

    Menus.create_meal_service(%{
      date: "2020-06-05",
      menu_id: menu.id,
      menu_items: [
        %{name: "Philly Stead Sandwich"},
        %{name: "Onion Rings"},
        %{name: "Mixed Green Salad"}
      ],
      name: nil,
      service_type_id: 1
    })
  end
end
