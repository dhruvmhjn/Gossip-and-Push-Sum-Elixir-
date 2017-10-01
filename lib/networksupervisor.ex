defmodule NetworkSupervisor do
    use Supervisor
    def start_link(n,top,protocol,gcpid) do
        {:ok,_pid}= Supervisor.start_link(__MODULE__,{n,top,protocol,gcpid},[])

    end
    def init({n,top,protocol,gcpid}) do
        #numnodes = String.to_integer(n) 
        n_miners = Enum.to_list 1..n
        #IO.inspect n_miners
        children = Enum.map(n_miners, fn(x)->worker(GossipNode, [top,n,x], [id: "node#{x}"]) end)
        #IO.inspect children
        supervise children, strategy: :one_for_one
    end
end