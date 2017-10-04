defmodule ApplicationSupervisor do
    use Supervisor
    def start_link(args) do
        return = {:ok, sup } = Supervisor.start_link(__MODULE__,args)
        start_workers(sup, args)
        return
    end
    
    def start_workers(sup, [numNodes,topology,algorithm]) do
    
        {:ok, _} = Supervisor.start_child(sup, worker(GossipCounter, [numNodes]))     
        Supervisor.start_child(sup, supervisor(NetworkSupervisor, [numNodes,topology,algorithm,gcpid]))
    
    end
    
    def init(_) do
        supervise [], strategy: :one_for_one
    end

end