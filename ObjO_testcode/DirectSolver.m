classdef DirectSolver < Solver
    
    methods (Static, Access = public)
        function solution = solve(LHS, RHS)
            solution = LHS \ RHS;
        end
    end
    
end

