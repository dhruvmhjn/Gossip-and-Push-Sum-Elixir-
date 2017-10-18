# Project2

Group members:
Dhruv Mahajan 4211-1994
Ashvini Patel 4794-9297

What works: Implemented everything specified in the project brief.
We have implemented both the Gossip and Push-Sum algorithms for the topologies:
Full Network
2D Grid
Line
Imperfect 2D Grid


Input: 

The input to run is provided as a command line with the following format:

./project2 numNodes topology algorithm

where numNodes is the number of actors involved
      topology is one of {line, full, 2D, imp2D}
      algorithm is one of {gossip, push-sum}


Output:

For Gossip algorithm, the output indicates when the network is finished being built and the time taken for convergence of the gossip algorithm in milliseconds.

For Push-sum algorithm, the output indicates when the network is finished being built, the computed average and the time taken for convergence of the push-sum algorithm in milliseconds.


Largest network observed for each algorithm and each topology:

Algorithm : Gossip
Full: 500,000 (convergence time: 20.86 seconds)
Line: 10,000  (convergence time: 203.23 seconds)
2D grid: 20,000 (convergence time: 8.27 seconds)
Imperfect 2D grid: 20,000 (convergence time: 3.07 seconds)

Algorithm : Push-sum
Full: 50,000 (convergence time: 40.53 seconds)
Line: 2,000  (convergence time: 251.51 seconds)
2D grid: 2,000 (convergence time: 179.93 seconds)
Imperfect 2D grid: 50,000 (convergence time: 131.11 seconds)


References:
https://stackoverflow.com/questions/35364511/proper-elixir-otp-way-to-structure-an-infinite-loop-task
https://elixirforum.com/t/properly-stopping-a-supervision-tree-with-cleanup/916

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/project2](https://hexdocs.pm/project2).

