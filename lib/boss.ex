defmodule Boss do
    @name "BOSS"
    def main(args) do 
        parse_args(args,@name)
    end
    defp parse_args(args,temp_asnode) do
        cmdarg = OptionParser.parse(args)
        {[],[numNodes,topology,algorithm],[]} = cmdarg
        numInt = String.to_integer(numNodes)
        
        #Code to Round OFF
        if topology == "2D" || topology =="imp2D" do
            numInt = round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
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
        
