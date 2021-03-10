defmodule AccountServer do
  def handle_cast({:credit, c}, amount) do
    {:noreply, amount + c}
  end
  def handle_cast({:debit, c}, amount) do
    {:noreply, amount - c}
  end
  def handle_call(:get, amount) do
    {amount, amount}
  end
  def start_link(initial_amount) do
    MyGenericServer.start_link(AccountServer,initial_amount)
  end
end

{:ok, my_account} = AccountServer.start_link(4)
MyGenericServer.cast(my_account, {:credit, 5})
MyGenericServer.cast(my_account, {:credit, 2})
MyGenericServer.cast(my_account, {:debit, 3})
amount = MyGenericServer.call(my_account, :get)
IO.puts "current credit hold is #{amount}"
