defmodule Genplaysup do
    use Supervisor
    def start_link(top,n,protocol) do
        {:ok,_pid}= Supervisor.start_link(__MODULE__,{top,n,protocol},[])

    end
    def init({top,n,protocol}) do
        # check protocol and change module Genplay to Gossip or pushsum workers
        # nodes = Enum.map(1..n, fn(i) -> Genplay.start_link(top,n,i) end)
        #child_processes = [ worker(Sequence.Server, [stash_pid]) ]
        #supervise child_processes, strategy: :one_for_one

        #IO.inspect self
        n_miners = Enum.to_list 1..n
        children = Enum.map(n_miners, fn(x)->worker(Genplay, [top,n,x], [id: "node#{x}"]) end)
        
        #Supervisor.start_child(self, worker(Genplay, [top,n,1], [id: "node1"]))

        #IO.puts inspect children

        #abc = Supervisor.start_child([children], strategy: :simple_one_for_one)
        #IO.puts inspect(abc)

        supervise children, strategy: :one_for_one
    end
end

# def start_link(stash_pid) do
#     {:ok, _pid} = Supervisor.start_link(__MODULE__, stash_pid)
#     end
#     def init(stash_pid) do
#     child_processes = [ worker(Sequence.Server, [stash_pid]) ]
#     supervise child_processes, strategy: :one_for_one
#     end
#     end