defmodule BudgetWeb.PageLive.Index do
  use BudgetWeb, :live_view

  def mount(_params, _session, socket) do
    balance = 1000
    debits = []
    # dates = ""

    {:ok,
     assign(socket,
       balance: balance,
       debits: debits
     )}
  end

  def render(assigns) do
    IO.inspect(assigns)

    ~H"""
    <h1> Your Balance Is <%= @balance %> </h1>
    <.form
      let={f}
      for={:debit}
      phx-submit="debit"
      >
      <%= number_input f, :amount %>

      <div class="budget-table">
        <div class= "date-div">
          <h2 class= "date-h2"> Date </h2>
            <ul>
               <.form
                let={f}
                for={:date_input}
                phx-submit="debit"
                >
                <li> <%= date_input(f, :dates)%> </li>
                <ul>

                <%= for debit <- @debits do %>
                <li> <%= date_input(f, :dates)%> </li>
                <% end %>
                </ul>
              
                </.form>
            </ul>


        </div>
        <div class="debit-div">
          <h2 class= "debit-h2"> Debits</h2>
          <ul>
            <%= for debit <- @debits do %>
              <li> <%= debit %> </li>
            <% end %>
          </ul>
        </div>
          <div class="category-div">
            <h2 class= "category-h2">Category</h2>
            <ul>
              <li>
                <%= select(f, :category, ["Entertainment": "entertainment", "Rent": "rent", "Groceries": "groceries"])%>
              </li>
            </ul>
          </div>
      </div>
    </.form>
    """
  end

  # Debit is equal to amount. This is matching the key value pair of debit to amount
  def handle_event("debit", %{"debit" => %{"amount" => amount}}, socket) do
    {amount, _} = Float.parse(amount)
    # Updating the :balance field in the socket to balance-amount
    socket =
      update(socket, :balance, fn balance -> balance - amount end)
      # Piping the socket with the updated balance value. Updating the :debits key with the correct amount
      |> update(:debits, fn debits -> [amount | debits] end)

    {:noreply, socket}
  end
end
