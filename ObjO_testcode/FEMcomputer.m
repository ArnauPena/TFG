classdef FEMcomputer < handle

    properties (Access = public)
        displacements
        loadedDisplacements
    end
    properties (Access = private)
        data
        dim
        StifnessMatrix 
        Fext
        solvertype
        v
        splittedStifnessMatrix
        splittedForceVector
        ur
    end
    
    methods (Access = public)
        
        function obj = FEMcomputer(cParams)
            obj.init(cParams);
        end
        
        function obj = solve(obj)
            obj.computeStifnessMatrix();
            obj.computeFext();
            obj.computeMatrixSplit();
            obj.computeDisplacements();
        end  
        
    end
    
    methods (Access = private)
        
        function obj = init(obj,cParams)
            run(cParams.staticFileData);
            obj.solvertype           = cParams.solver_type;
            obj.data                 = datav;
            obj.dim                  = dimv;
            obj.loadedDisplacements  = displacementv;
        end
        
        function obj = computeStifnessMatrix(obj)
            s.data             = obj.data;
            s.dim              = obj.dim;
            Solution           = StifnessMatrixComputer(s);
            Solution.compute();
            obj.StifnessMatrix = Solution.stifnessMatrix;
        end
        
        function obj = computeFext(obj)
           s.data   = obj.data;
           s.dim    = obj.dim;
           Solution = ForceComputer(s);
           obj.Fext = Solution.compute();
        end
        
        function obj = computeMatrixSplit(obj)           
            s.data    = obj.data;
            s.dim     = obj.dim;
            s.matrix  = obj.StifnessMatrix;
            s.vector  = obj.Fext;
            Solution  = MatrixSplitterComputer(s);
            Solution.compute();           
            obj.splittedStifnessMatrix = Solution.K;
            obj.v                   = Solution.v;
            obj.splittedForceVector = Solution.F;
            obj.ur                  = Solution.ur;
        end
        
        function obj = computeDisplacements(obj)
            s.K               = obj.splittedStifnessMatrix;
            s.v               = obj.v;
            s.F               = obj.splittedForceVector;
            s.ur              = obj.ur;
            s.solvertype      = obj.solvertype;           
            Solution          = DisplacementsComputer(s);
            Solution.compute();
            obj.displacements = Solution.displacements;
        end
           
    end 
end 
         
        
        


