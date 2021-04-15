defimpl ExFSM.Machine.State, for: Map do
  def state_name(order), do: String.to_atom(order["status"]["state"])
  def set_state_name(order, name), do: Kernel.get_and_update_in(order["status"]["state"], fn state -> {state, Atom.to_string(name)} end)
  def handlers(order) do
    {fsm, _} = MyRulex.apply_rules(order, [])
    fsm
  end
end

defmodule MyFSM do
  # use ExFSM
  # deftrans init({:process_payment, []}, order) do
  #   {:next_state, :not_verified, order}
  # end
  #
  # deftrans not_verified({:verfication, []}, order) do
  #   {:next_state, :finished, order}
  # end
  defmodule Paypal do
    use ExFSM
    deftrans init({:payment_process, []}, order) do
      {:next_state, :paid_with_paypal, order}
    end
  end
  defmodule Stripe do
    use ExFSM
    deftrans init({:payment_process, []}, order) do
        {:next_state, :paid_with_stripe, order}
      end
  end
  defmodule Delivery do
    use ExFSM
    deftrans init({:payment_process, []}, order) do
        {:next_state, :paid, order}
      end
  end
end

defmodule MyRulex do
  use Rulex
  # module acces pour pacrourir mon object avec clés
  defrule delivery_fsm(%{"payment_method"=> "Delivery"}, acc), do: {:ok, [MyFSM.Delivery | acc]}
  defrule paypal_fsm(%{"payment_method"=> "Paypal"}, acc), do: {:ok, [MyFSM.Paypal | acc]}
  defrule stripe_fsm(%{"payment_method"=> "Stripe"}, acc), do: {:ok, [MyFSM.Stripe | acc]}
end
