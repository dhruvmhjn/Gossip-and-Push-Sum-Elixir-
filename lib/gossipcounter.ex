defmodule GossipCounter do
    use GenServer
    def start_link(numnodes) do
        #IO.puts "abc in gcounter"
        myname = String.to_atom("gcounter")
        return = {:ok, pid} = GenServer.start_link(__MODULE__, {numnodes}, name: myname )
        #IO.puts "abc in gcounter"
        #IO.inspect pid
        return
    end
    
    def init({numnodes}) do
        {:ok,{0,numnodes}}
    end

    def handle_cast(:heardrumour,{count,numnodes})do
        IO.puts "In Gcounter"
        newcount=count+1
        if newcount == numnodes do
            :init.stop
            #OR Supervisor.stop(sup)
        end
        {:noreply,{newcount,numnodes}}
    end

end