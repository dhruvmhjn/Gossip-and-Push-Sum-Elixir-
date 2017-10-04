defmodule PushsumCounter do
    use GenServer
    def start_link(numnodes) do
        myname = String.to_atom("pcoumter")
        return = GenServer.start_link(__MODULE__, {numnodes}, name: myname )
        return
    end
    
    def init({numnodes}) do
        truesum = (numnodes*(numnodes + 1))/2
        {:ok,{0,numnodes,truesum}}
    end

    def handle_cast({:sumvalue,computedsum},{count,numnodes,truesum})do
        newcount=count+1
        if newcount == numnodes do
            b = System.system_time(:millisecond)
            IO.puts "Sum Computed, Terminating."
            send(Process.whereis(:boss),{:sumcomputed,b})   
        end
        {:noreply,{newcount,numnodes,truesum}}
    end

end