defmodule Genplaysup do
    use Supervisor
    def start_link(top,n,protocol) do
        {:ok,_pid}= Supervisor.start_link(__MODULE__,{top,n,protocol},[])

    end
    def init({top,n,protocol}) do 
        n_miners = Enum.to_list 1..n
        children = Enum.map(n_miners, fn(x)->worker(Genplay, [top,n,x], [id: "node#{x}"]) end)
        IO.puts "this is in supervisior"
        supervise children, strategy: :one_for_one
    end
end