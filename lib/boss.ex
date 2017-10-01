defmodule Boss do
    @name "BOSS"
    def main(args) do 
        parse_args(args,@name)
    end
    defp parse_args(args,temp_asnode) do
        cmdarg = OptionParser.parse(args)
        #IO.inspect cmdarg 
        {[],[numNodes,topology,algorithm],[]} = cmdarg
        numInt = String.to_integer(numNodes)
        if topology == "2D" || topology =="imp2D" do
            numInt = round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
            IO.puts "Rounded off. Starting 2D grid with #{numInt} Nodes." 
        end
        
        ApplicationSupervisor.start_link([numInt,topology,algorithm])
        
        

        
        #kregex = ~r/^\d{1,2}$/    
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
        
