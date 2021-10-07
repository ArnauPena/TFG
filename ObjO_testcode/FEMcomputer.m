classdef FEMcomputer < handle

    properties (Access = public)
        u
        displacement
    end
    properties (Access = private)
        data
        dim
        Kglobal 
        Fext
        solvertype
        stifnessmatrix
        v
        K
        F
        ur
    end
    
    methods (Access = public)
        function obj = FEMcomputer(cParams)
            obj.init(cParams);
        end
    end
    methods (Access = public)
        function obj = init(obj,cParams)
            run(cParams.staticFileData);
            obj.solvertype     = cParams.solver_type;
            obj.data           = datav;            
            obj.dim            = dimv;
            obj.displacement   = displacementv;
        end
    end
    methods (Access = public)        
        function obj = solve(obj)
            obj.computeStifnessMatrix();
            obj.computeFext();
            obj.computeMatrixSplit();
            obj.computeDisplacements();
        end  
    end
    
    methods (Access = private)
        function obj = computeStifnessMatrix(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            kg = StifnessMatrixComputer(s);
            kg.compute();
            obj.Kglobal = kg.Kg;
        end
        
        function obj = computeFext(obj)
           s.data = obj.data;
           s.dim  = obj.dim;
           f = ForceComputer(s);
           obj.Fext = f.compute();
        end
        
        function obj = computeMatrixSplit(obj)           
            s.data    = obj.data;
            s.dim     = obj.dim;
            s.matrix  = obj.Kglobal;
            s.vector  = obj.Fext;
            p = MatrixSplitterComputer(s);
            p.compute();           
            obj.K     = p.K;
            obj.v     = p.v;
            obj.F     = p.F;
            obj.ur    = p.ur;
        end
        
        function obj = computeDisplacements(obj)
            s.K           = obj.K;
            s.v           = obj.v;
            s.F           = obj.F;
            s.ur          = obj.ur;
            s.solvertype  = obj.solvertype;           
            sol = DisplacementsComputer(s);
            sol.compute();
            obj.u = sol.u;
        end
        
        
    end 
end 
         
        
        


