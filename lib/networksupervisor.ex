defmodule NetworkSupervisor do
    use Supervisor
    def start_link(n,top,protocol,_) do
        {:ok,pid}= Supervisor.start_link(__MODULE__,{n,top,protocol},[])
        #IO.puts "boss pid from nsup : #{inspect(Process.whereis(:boss))}"
        send(Process.whereis(:boss),{:topology_created})
        {:ok,pid}
    end
    def init({n,top,protocol}) do
        n_list = Enum.to_list 1..n
        IO.puts "n_list creaded"
        children = Enum.map(n_list, fn(x)->worker(GossipNode, [top,n,x], [id: "node#{x}"]) end)
        supervise children, strategy: :one_for_one
    end
end