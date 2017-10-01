defmodule Genplaysup do
    use Supervisor
    def start_link(top,n,protocol) do
        {:ok,pid}= Supervisor.start_link(__MODULE__,{top,n,protocol},[])
    end
    def init({top,n,protocol}) do
        # check protocol and change module Genplay to Gossip or pushsum workers
        # nodes = Enum.map(1..n, fn(i) -> Genplay.start_link(top,n,i) end)
        IO.inspect self
        n_miners = Enum.to_list 1..n
        children = Enum.map(n_miners, fn(x)->worker(Genplay, [], [name: "node#{x}"]) end)
        IO.puts inspect children
        abc = Supervisor.start_child(children, strategy: :simple_one_for_one)
        #IO.puts inspect(abc)

    end
end