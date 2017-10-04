defmodule NetworkSupervisor do
    use Supervisor
    def start_link(n,top,protocol,gcpid) do
        {:ok,_pid}= Supervisor.start_link(__MODULE__,{n,top,protocol,gcpid},[])
        send(:boss,{:topology_created})
        {:ok,_pid}
    end
    def init({n,top,protocol,gcpid}) do
        n_list = Enum.to_list 1..n
        children = Enum.map(n_list, fn(x)->worker(GossipNode, [top,n,x], [id: "node#{x}"]) end)
        supervise children, strategy: :one_for_one
    end
end