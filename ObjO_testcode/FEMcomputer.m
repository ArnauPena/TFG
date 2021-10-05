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
        staticfiledata
        solvertype
        stifnessmatrix
        v
        K
        F
        ur
        Fl
        Kll
    end
    
    methods (Access = public)
        function obj = FEMcomputer(cParams)
            obj.init(cParams);
        end
    end
    methods (Access = public)
        function obj = init(obj,cParams)
            obj.staticfiledata = cParams.staticfiledata;
            run(obj.staticfiledata);
            obj.solvertype     = cParams.solver_type;
            obj.stifnessmatrix = cParams.stifnessmatrix;
            obj.Kll            = cParams.Kll;
            obj.Fl             = cParams.Fl;
            obj.data           = datav;            
            obj.dim            = dimv;
            obj.displacement   = displacementv;
        end
    end
    methods (Access = public)        
        function obj = solve(obj)
            obj.computeStifnessMatrix();
            obj.testStifnessMatrix();
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
            s.Kll     = obj.Kll;
            s.Fl      = obj.Fl;
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
        
        function obj = testStifnessMatrix(obj)
            load(obj.stifnessmatrix);
            s.tested        = obj.Kglobal;
            s.tester        = Kgt;
            s.matrixname    = 'Stifness';
            TestKglobal = MatrixTester(s);
            TestKglobal.compute();
        end
        
    end 
end 
         
        
        


