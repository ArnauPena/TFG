classdef DisplacementsComputer < handle
    
    properties (Access = public)
       st
       LHS
       RHS
       u
    end
    
    properties (Access = private)
       Krr, Kll
       Klr, Krl
       Fl, Fr
       ur, ul
       vr, vl
    end
    
    methods (Access = public)
        
        function obj = DisplacementsComputer(cParams)
            obj.init(cParams)
            
        end
        
        function obj = computeDisplacement(obj)
            obj.prepareSolverTerms();
            obj.solveFreeDisplacements();
            obj.computeDisplacementsVector();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.Kll = cParams.Kll;
            obj.Krr = cParams.Krr;
            obj.Klr = cParams.Klr;
            obj.Krl = cParams.Krl;
            obj.Fl  = cParams.Fl;
            obj.ur  = cParams.ur;    
            obj.Fr  = cParams.Fr;
            obj.vl  = cParams.vl;
            obj.vr  = cParams.vr;            
            obj.st  = cParams.st;
        end
        
        function obj = prepareSolverTerms(obj)
            obj.LHS = obj.Kll;
            obj.RHS = obj.Fl-obj.Klr*obj.ur;
        end
        
        function obj = solveFreeDisplacements(obj)
            solver   = Solver.create(obj.st);
            solution = solver.solve(obj.LHS, obj.RHS);
            obj.ul   = solution;
        end
        
        function obj = computeDisplacementsVector(obj)
            obj.u(obj.vl,1) = obj.ul;
            obj.u(obj.vr,1) = obj.ur;
        end
    end
    
end