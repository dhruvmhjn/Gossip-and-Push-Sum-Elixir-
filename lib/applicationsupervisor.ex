defmodule ApplicationSupervisor do
    use Supervisor
    def start_link(args) do
        result = {:ok, sup } = Supervisor.start_link(__MODULE__,args)
        start_workers(sup, args)
        result
    end
    
    def start_workers(sup, [numNodes,topology,algorithm]) do
    
        {:ok, gcpid} = Supervisor.start_child(sup, worker(GossipCounter, [numNodes]))
         #IO.inspect gcpid        
        Supervisor.start_child(sup, supervisor(NetworkSupervisor, [numNodes,topology,algorithm,gcpid]))
    
    end
    
    def init(_) do
        supervise [], strategy: :one_for_one
    end

end