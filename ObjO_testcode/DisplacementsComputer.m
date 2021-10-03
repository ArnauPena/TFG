classdef DisplacementsComputer < handle
    
    properties (Access = public)
       solvertype
       LHS
       RHS
       u
    end
    
    properties (Access = private)
        K
        F
        ur, ul
        v
    end
    
    methods (Access = public)
        
        function obj = DisplacementsComputer(cParams)
            obj.init(cParams)            
        end
        
        function obj = compute(obj)
            obj.computeSolverTerms();
            obj.solveFreeDOFsDisplacements();
            obj.computeVectorJoint();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.K          = cParams.K;
            obj.F          = cParams.F;
            obj.v          = cParams.v;
            obj.ur         = cParams.ur;
            obj.solvertype = cParams.solvertype;
        end
        
        function obj = computeSolverTerms(obj)
            obj.LHS = obj.K.ll;
            obj.RHS = obj.F.l-obj.K.lr*obj.ur;
        end
        
        function obj = solveFreeDOFsDisplacements(obj)
            solver   = Solver.create(obj.solvertype);
            solution = solver.solve(obj.LHS, obj.RHS);
            obj.ul   = solution;
        end
        
        function obj = computeVectorJoint(obj)
            obj.u(obj.v.l,1) = obj.ul;
            obj.u(obj.v.r,1) = obj.ur;
        end
    end
    
end