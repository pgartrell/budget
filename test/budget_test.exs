defmodule BudgetTest do
  use ExUnit.Case

  test "I can subtract an amount" do
    balance = 1000
    balance = Account.debit(balance, 50)
    assert balance == 950
  end

  test "I can add an amount" do
    balance = 1000
    balance = Account.credit(balance, 50)
    assert balance == 1050
  end
end

defmodule Account do
  def debit(balance, amount) do
    balance - amount
  end

  def credit(balance, amount) do
    balance + amount
  end
end
