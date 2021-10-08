classdef Tester < handle
        
    properties (Access = private)
        directSolver
        iterativeSolver
        staticFileData
        loadedStifnessMatrix
        loadedFreeDOFsMatrix
        loadedFreeDOFsVector
        forceVector
    end
    
    methods (Access = public)
        
        function obj = Tester(cParams)
            obj.init(cParams)            
        end
        
        function obj = run(obj)
            obj.runFEMtest();
            obj.runStifnessMatrixTest();
            obj.runFreeDOFsMatrixTest();
            obj.runFreeDOFsVectorTest();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.directSolver          = cParams.solver_direct;
            obj.iterativeSolver       = cParams.solver_iterative;
            obj.staticFileData        = cParams.staticfiledata;
            obj.loadedStifnessMatrix  = cParams.stifnessmatrix;
            obj.loadedFreeDOFsMatrix  = cParams.Kll;
            obj.loadedFreeDOFsVector  = cParams.Fl;
            obj.forceVector           = cParams.forcevector;
        end
        
        function obj = runFEMtest(obj)
            obj.computeDirectSolverFEM();
            obj.computeIterativeSolverFEM();
        end
        
        function obj = runStifnessMatrixTest(obj)
            s.staticFileData       = obj.staticFileData;
            s.loadedStifnessMatrix = obj.loadedStifnessMatrix;
            s.testedPropertyName   = 'Stifness Matrix solution';
            Test1 = StifnessMatrixTester(s);
            Test1.compute();
        end
        
        function obj = runFreeDOFsMatrixTest(obj)
            s.staticFileData       = obj.staticFileData;
            s.matrix               = obj.loadedStifnessMatrix;
            s.vector               = obj.forceVector;
            s.loadedFreeDOFsMatrix = obj.loadedFreeDOFsMatrix;
            s.testedPropertyName   = 'Free DOFs Matrix solution';            
            Test2 = FreeDOFsMatrixTester(s);
            Test2.compute();
        end
        
        function obj = runFreeDOFsVectorTest(obj)
            s.staticFileData       = obj.staticFileData;
            s.matrix               = obj.loadedStifnessMatrix;
            s.vector               = obj.forceVector;
            s.loadedFreeDOFsVector = obj.loadedFreeDOFsVector;
            s.testedPropertyName   = 'Free DOFs Vector solution';
            Test3 = FreeDOFsVectorTester(s);
            Test3.compute();
        end
        
        function obj = computeDirectSolverFEM(obj)
            s.staticFileData     = obj.staticFileData;
            s.solver_type        = obj.directSolver;
            s.testedPropertyName = 'Direct solution displacement vector';
            DirectTest = FemTester(s);
            DirectTest.compute();
        end
        
        function obj = computeIterativeSolverFEM(obj)
            s.staticFileData     = obj.staticFileData;
            s.solver_type        = obj.iterativeSolver;
            s.testedPropertyName = 'Iterative solution displacement vector';            
            IterativeTest = FemTester(s);
            IterativeTest.compute();
        end
        
    end
    
end