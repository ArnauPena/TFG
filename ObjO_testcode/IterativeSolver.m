classdef IterativeSolver < Solver

    methods (Static, Access = public)
        function solution = solve(LHS,RHS)
            solution = pcg(LHS,RHS,[],1000);
        end
    end 

end

