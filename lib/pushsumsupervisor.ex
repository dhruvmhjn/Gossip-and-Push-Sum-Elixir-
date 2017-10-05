defmodule PushsumSupervisor do
    use Supervisor
    def start_link(n,top,_) do
        {:ok,pid}= Supervisor.start_link(__MODULE__,{n,top},[])
        send(Process.whereis(:boss),{:pushsum_topology_created})
        {:ok,pid}
    end
    def init({n,top}) do
        n_list = Enum.to_list 1..n
        children = Enum.map(n_list, fn(x)->worker(PushsumNode, [top,n,x], [id: "node#{x}"]) end)
        supervise children, strategy: :one_for_all
    end
end