defmodule InventoryManager do

  defstruct inventory: [], cart: []

  def add_product(task_manager, name, price, stock) do

    products = task_manager.inventory
    id = length(products) + 1
    product = %{id: id, name: name, price: price, stock: stock}
    %InventoryManager{task_manager | inventory: products ++ [product]}

  end

  def list_products(task_manager) do
    if Enum.empty?(task_manager.inventory) do
      IO.puts("No products")
    else
      Enum.each(task_manager.inventory, fn product ->
        IO.puts("ID: #{product.id} | Name: #{product.name} | Price: #{product.price} | Stock: #{product.stock}")
      end)
    end


  end

  def increase_stock(task_manager, id, quantity) do

    update_inventory = Enum.map(task_manager.inventory, fn product ->
      if product.id == id do
        %{product | stock: product.stock + quantity}
      else
        product
      end
    end)
    %InventoryManager{task_manager | inventory: update_inventory}
  end

  def sell_product(task_manager, id, quantity) do

    product = Enum.find(task_manager.inventory, fn product -> product.id == id end)

    if product && product.stock >= quantity do
      update_inventory = Enum.map(task_manager.inventory, fn product ->
        if product.id == id do
          %{product | stock: product.stock - quantity}
        else
          product
        end
      end)

      update_cart = task_manager.cart ++ [%{id: product.id, name: product.name, price: product.price, quantity: quantity}]

      %InventoryManager{task_manager | inventory: update_inventory, cart: update_cart}

    else
      IO.puts("Product not found or insufficient stock")
    end

  end

  def view_cart(task_manager) do

    total = Enum.reduce(task_manager.cart, 0, fn product, acc -> product.price * product.quantity + acc end)

    IO.puts("\n--- Carrito ---")
    Enum.each(task_manager.cart, fn product ->
      IO.puts("Name: #{product.name} | Price: #{product.price} | Quantity: #{product.quantity}")
    end)

  end

  def checkout(task_manager) do

    IO.puts("\n--- Checkout complete---")
    %InventoryManager{task_manager | cart: []}

  end

  def run() do

    task_manager = %InventoryManager{}
    loop(task_manager)

  end

  defp loop(task_manager) do

    IO.puts("\n--- Menu ---")
    IO.puts("1. Add product")
    IO.puts("2. List products")
    IO.puts("3. Increase stock")
    IO.puts("4. Sell product")
    IO.puts("5. View cart")
    IO.puts("6. Checkout")
    IO.puts("7. Exit")
    IO.puts("Choose an option:")

    case IO.gets(" ") do
      "1\n" ->
        IO.puts("Name:")
        name = IO.gets(" ") |> String.trim_trailing()
        IO.puts("Price:")
        price = IO.gets(" ") |> String.trim_trailing() |> String.to_float()
        IO.puts("Stock:")
        stock = IO.gets(" ") |> String.trim_trailing() |> String.to_integer()
        task_manager = add_product(task_manager, name, price, stock)
        loop(task_manager)
      "2\n" ->
        list_products(task_manager)
        loop(task_manager)
      "3\n" ->
        IO.puts("ID:")
        id = IO.gets(" ") |> String.trim_trailing() |> String.to_integer()
        IO.puts("Quantity:")
        quantity = IO.gets(" ") |> String.trim_trailing() |> String.to_integer()
        task_manager = increase_stock(task_manager, id, quantity)
        loop(task_manager)
      "4\n" ->
        IO.puts("ID:")
        id = IO.gets(" ") |> String.trim_trailing() |> String.to_integer()
        IO.puts("Quantity:")
        quantity = IO.gets(" ") |> String.trim_trailing() |> String.to_integer()
        task_manager = sell_product(task_manager, id, quantity)
        loop(task_manager)
      "5\n" ->
        view_cart(task_manager)
        loop(task_manager)
      "6\n" ->
        task_manager = checkout(task_manager)
        loop(task_manager)
      "7\n" ->
        IO.puts("Goodbye!")
      _ ->
        IO.puts("Invalid option")
        loop(task_manager)
    end

  end

end

InventoryManager.run()
