defmodule AccountServer do
  def handle_cast({:credit, c}, amount), do: {:noreply, amount + c}
  def handle_cast({:debit, c}, amount), do: {:noreply, amount - c}
  def handle_call(:get, amount), do: {amount, amount}

  def credit(process_pid, amount), do: MyGenericServer.cast(process_pid, {:credit, amount})
  def debit(process_pid, amount), do: MyGenericServer.cast(process_pid, {:debit, amount})
  def get(process_pid), do: MyGenericServer.call(process_pid, :get)

  def start_link(initial_amount), do: MyGenericServer.start_link(AccountServer,initial_amount)
end

# {:ok, my_account} = AccountServer.start_link(4)
# AccountServer.credit(my_account, 5)
# AccountServer.credit(my_account, 2)
# AccountServer.debit(my_account, 3)
# amount = AccountServer.get(my_account)
# IO.puts "current credit hold is #{amount}"
