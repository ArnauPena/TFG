classdef (Abstract) Solver < handle
    
    methods (Static)

        function stype = create(solver_type)    
            switch solver_type
                case {'DIRECT'}
                    stype = DirectSolver();
                case {'ITERATIVE'}
                    stype = IterativeSolver();
                otherwise
                    error('Invalid Solver Type.')
            end
        end

    end
    
    methods (Abstract, Access = public)
        solve(LHS, RHS)
    end
    
end