classdef IterativeSolver < Solver

    methods (Static, Access = public)
        function solution = solve(LHS,RHS)
            solution = pcg(LHS,RHS);
        end
    end 

end

