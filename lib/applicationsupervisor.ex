defmodule ApplicationSupervisor do
    use Supervisor
    def start_link(args) do
        return = {:ok, sup } = Supervisor.start_link(__MODULE__,args)
        start_workers(sup, args)
        return
    end
    
    def start_workers(sup, [numNodes,topology,algorithm]) do
    
        if algorithm == "gossip" do
            {:ok, gcpid} = Supervisor.start_child(sup, worker(GossipCounter, [numNodes]))     
            Supervisor.start_child(sup, supervisor(GossipSupervisor, [numNodes,topology,gcpid]))
        end

        if algorithm == "push-sum" do
            {:ok, gcpid} = Supervisor.start_child(sup, worker(PushsumCounter, [numNodes]))     
            Supervisor.start_child(sup, supervisor(PushsumSupervisor, [numNodes,topology,gcpid]))
        end
    
    end
    
    def init(_) do
        supervise [], strategy: :one_for_all
    end

end