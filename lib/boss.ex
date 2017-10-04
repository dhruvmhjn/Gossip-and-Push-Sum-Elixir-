defmodule Boss do
    def main(args) do 
        parse_args(args)
    end
    defp parse_args(args) do
        cmdarg = OptionParser.parse(args)
        {[],[numNodes,topology,algorithm],[]} = cmdarg
        numInt = String.to_integer(numNodes)
        
        #Code to Round OFF
        numInt = cond do
            (topology == "2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
            (topology =="imp2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
            true -> numInt
        end

        if topology == "2D" || topology =="imp2D" do
            IO.puts "Rounded off. Starting 2D grid with #{numInt} Nodes." 
        end
        
        ApplicationSupervisor.start_link([numInt,topology,algorithm])

        #sleep the main process
        
        rstring = "This is the first rumour"
        IO.puts "foo";
        :timer.sleep(1000)
        IO.puts "bar"


        if topology == "line" || topology =="full" do
            GenServer.cast(:node1, {:rumour, rstring})
        end
        if topology == "2D" || topology =="imp2D" do
            GenServer.cast(:node11, {:rumour, rstring})
        end

        boss_receiver("string")
    end
            
    def boss_receiver(k) do
        receive do
            {:hello, cpid} ->
                send cpid, {:k_valmsg, k}
        end
        boss_receiver(k)
    end
end
        
