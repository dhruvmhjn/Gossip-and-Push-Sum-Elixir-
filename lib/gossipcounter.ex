defmodule GossipCounter do
    use GenServer
    def start_link(numnodes) do
        myname = String.to_atom("gcounter")
        return = GenServer.start_link(__MODULE__, {numnodes}, name: myname )
        return
    end
    
    def init({numnodes}) do
        {:ok,{0,numnodes}}
    end

    def handle_cast(:heardrumour,{count,numnodes})do
        IO.puts "#{count} nodes have heard the rumour."
        newcount=count+1
        if newcount == numnodes do
            IO.puts "Rumour Propogated, Terminating."
            :init.stop
            #OR Supervisor.stop(sup)
        end
        {:noreply,{newcount,numnodes}}
    end

end