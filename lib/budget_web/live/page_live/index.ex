defmodule BudgetWeb.PageLive.Index do
  use BudgetWeb, :live_view

  def mount(_params, _session, socket) do
    starting_balance = 1000
    debits = []
    # dates = ""

    {:ok,
     assign(socket,
       entries: [
         %{"amount" => "30", "date" => "1/2/22", "category" => "entertainment"},
         %{"amount" => "50.75", "date" => "1/6/22", "category" => "bills"}
       ],
       starting_balance: starting_balance,
       debits: debits
     )}
  end

  def render(assigns) do
    ~H"""
    <h1> Your Balance Is <%= current_balance(@starting_balance, @entries) %> </h1>
    <.form
      let={f}
      for={:debit}
      phx-submit="debit"
      >
      <%= number_input f, :amount %>

      <div class="budget-table">
        <div class= "date-div">
          <h2 class= "date-h2"> Date </h2>                        
            <li> <%= date_input(f, :date)%> </li>
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
                <%= select(f, :category, ["Entertainment": "entertainment", "Rent": "rent", "Groceries": "groceries", "Bills": "bills"])%>
              </li>
            </ul>
          </div>
      </div>
    </.form>
    <h2> Entries </h2>
    <table> 
      <tr> 
        <th>Date</th>
        <th>Amount</th>
        <th>Category</th>
        <th>Type</th>
      </tr>
      <%= for entry <- @entries do %>
      <tr> 
        <td> <%= entry["date"] %> </td>
        <td> <%= entry["amount"]%> </td>
        <td> <%= entry["category"] %> </td>
        <td> <%= amount_type(entry) %> </td>
      </tr>
      <% end %>
    </table>
    """
  end

  # Debit is equal to amount. This is matching the key value pair of debit to amount
  def handle_event("debit", %{"debit" => new_entry}, socket) do
    socket = assign(socket, entries: [new_entry | socket.assigns.entries])

    {:noreply, socket}
  end

  def current_balance(starting_balance, entries) do
    starting_balance

    all_entries =
      Enum.map(entries, fn entry -> entry["amount"] end)
      |> Enum.map(fn amount ->
        {parsed_amount, _} = Float.parse(amount)
        parsed_amount
      end)
      |> Enum.sum()

    starting_balance - all_entries
  end

  def amount_type(%{"amount" => amount, "category" => "bills"}) do
    {parsed_amount, _} = Float.parse(amount)

    if parsed_amount < 0 do
      "refund"
    else
      "paid"
    end
  end

  def amount_type(%{"amount" => amount}) do
    {parsed_amount, _} = Float.parse(amount)

    if parsed_amount < 0 do
      "refund"
    else
      "spent"
    end
  end
end
