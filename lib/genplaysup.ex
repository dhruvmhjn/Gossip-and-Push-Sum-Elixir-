defmodule Genplaysup do
    use Supervisor
    def start_link(top,n,protocol) do
        {:ok,pid}= Supervisor.start_link(__MODULE__,{top,n,protocol})
    end
    def init({top,n,protocol}) do
        # check protocol and change module Genplay to Gossip or pushsum workers
        # nodes = Enum.map(1..n, fn(i) -> Genplay.start_link(top,n,i) end)
        nodes = Genplay.start_link(top,n,1)
        IO.puts inspect(nodes)
        supervise nodes, strategy: :simple_one_for_one
    end
end