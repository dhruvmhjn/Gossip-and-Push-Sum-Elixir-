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
        newcount=count+1
        #IO.puts "#{newcount} node/s have heard the rumour."
        if newcount == numnodes do
            b = System.system_time(:millisecond)
            IO.puts "Rumour Propogated, Terminating."
            send(Process.whereis(:boss),{:rumourpropogated,b})
            #s:init.stop
            #OR Supervisor.stop(sup)
        end
        {:noreply,{newcount,numnodes}}
    end

end