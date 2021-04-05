defmodule TaxIncluder do
  def add_tax(orders, tax_rates) do
    for order <- orders do
      additional_rate = tax_rates[order[:ship_to]] || 0
      [
        id: order[:id],
        ship_to: order[:ship_to],
        net_amount: order[:net_amount] * (1 + additional_rate)
      ]
    end
  end
end

tax_rates = [NC: 0.075, TX: 0.08]
orders = [
  [id: 123, ship_to: :NC, net_amount: 100.00],
  [id: 124, ship_to: :OK, net_amount: 35.50],
  [id: 125, ship_to: :TX, net_amount: 24.00],
  [id: 126, ship_to: :TX, net_amount: 44.80],
  [id: 127, ship_to: :NC, net_amount: 25.00],
  [id: 128, ship_to: :MA, net_amount: 10.00],
  [id: 129, ship_to: :CA, net_amount: 102.00],
  [id: 130, ship_to: :NC, net_amount: 50.00]
]

orders |> TaxIncluder.add_tax(tax_rates) |> IO.inspect
