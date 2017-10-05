defmodule PushsumNode do
    use GenServer

    def start_link(top,n,x) do
        sqn=round(:math.sqrt(n))
        i = div((x-1),sqn) + 1
        j = rem((x-1),sqn) + 1 
        returnok = {:ok,_pid} = cond do
          (top == "line")||(top == "full") ->  GenServer.start_link(PushsumNode, {top,n,x,x,0}, name: String.to_atom("node#{x}"))
          (top == "2D") || (top == "imp2D") ->  GenServer.start_link(PushsumNode, {top,n,x,i,j}, name: String.to_atom("node#{i}@#{j}"))
        end
      returnok        
    end

    def init({top,n,x,i,j}) do
        sqn= round(:math.sqrt(n))
        list = cond do
          (top == "full") -> []  
          (top == "line") && (i == 1) -> [:node2]
          (top == "line") && (i == n) -> [String.to_atom("node#{n-1}")]
          (top == "line")  -> [String.to_atom("node#{i-1}"),String.to_atom("node#{i+1}")]
          (i != 1) && (i != sqn) && (j != 1) && (j != sqn) -> [String.to_atom("node#{i}@#{j+1}"),String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j-1}"),String.to_atom("node#{i-1}@#{j}")]
          (i == 1) && (j == 1) -> [:node2@1,:node1@2]
          (i == sqn) && (j == 1) -> [String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i}@#{j+1}")] #{Integer.undigits([i-1,j]), Integer.undigits([i,j+1])}
          (i == 1) && (j == sqn) -> [String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j-1}")] #{Integer.undigits([i,j-1]), Integer.undigits([i+1,j])}      
          (i == sqn) && (j == sqn) -> [String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i}@#{j-1}")] #{Integer.undigits([(i-1),j]), Integer.undigits([i,(j-1)])}
          (j == 1) ->[String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j+1}")]  #{Integer.undigits([i+1,j]), Integer.undigits([i,j+1]), Integer.undigits([i-1,j])}
          (j == sqn) ->  [String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j-1}")]#{Integer.undigits([i+1,j]), Integer.undigits([i,j-1]), Integer.undigits([i-1,j])}
          (i == 1) ->  [String.to_atom("node#{i}@#{j-1}"),String.to_atom("node#{i}@#{j+1}"),String.to_atom("node#{i+1}@#{j}")]#{Integer.undigits([i,j-1]), Integer.undigits([i,j+1]), Integer.undigits([i+1,j])}
          (i == sqn) ->  [String.to_atom("node#{i}@#{j-1}"),String.to_atom("node#{i}@#{j+1}"),String.to_atom("node#{i-1}@#{j}")]#{Integer.undigits([i,j-1]), Integer.undigits([i,j+1]), Integer.undigits([i-1,j])}
          true ->  []
        end
        if(top=="imp2D") do
          randi = :rand.uniform(sqn)
          randj = :rand.uniform(sqn)
          list = list ++ [String.to_atom("node#{randi}@#{randj}")]
        end
       # state: num modes, list of neighbours, last s/w, termination counter, s, w
       #IO.puts "sqn=#{sqn} i=#{i} j=#{j} list=#{inspect(list)}"
        {:ok,{n,list,0.0,0,x,1.0}}
    end

    def handle_cast({:rumour,s1,w1},{n,list,ratio,t_counter,s,w}) do
        if (t_counter < 3) do
            s = s + s1
            w = w + w1
            newratio = s/w
            if  Float.round(abs(ratio-newratio),11) < :math.pow(10.0,-10) do
                t_counter = t_counter+1
            else
                t_counter = 0    
            end
            ratio=newratio
            if (t_counter == 3) do
                GenServer.cast(:pcounter, {:sumreport,ratio})
            end
            # start spreading the rumour -> cast to self 
            if (t_counter < 3) do 
                GenServer.cast(self(), {:spreadrumour})
            end
        end
        #IO.puts "Storing ujpdates sate" 
    {:noreply,{n,list,ratio,t_counter,s,w}}
    end

   def handle_cast({:spreadrumour},{n,list,ratio,t_counter,s,w}) do   #IO.puts "In spread rumor"
        if t_counter < 3 do
            len_neb = length(list)
            name_neb = cond do
                len_neb == 0 -> String.to_atom("node#{:rand.uniform(n)}")
                true -> Enum.at(list,(:rand.uniform(len_neb)-1))
            end
            s=s/2.0
            w=w/2.0
            GenServer.cast(name_neb, {:rumour, s,w})
            #GenServer.cast(self(), {:spreadrumour})
        end  
    {:noreply,{n,list,ratio,t_counter,s,w}} 
   end
end