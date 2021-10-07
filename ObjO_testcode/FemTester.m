classdef FemTester < handle
    
    properties (Access = private) 
        matrixname
        displacements
        u
        loadedDisplacements
        computedDisplacements
        staticFileData
        solver_type
        testedPropertyName
    end
    
    methods (Access = public)
        function obj = FemTester(cParams)
            obj.init(cParams);
        end
        
        function obj = compute(obj)
            obj.computeFEM();
            obj.testFEM();
        end
        
    end
    
    methods (Access = private)
        
        function obj = init(obj,cParams)
            obj.testedPropertyName = cParams.testedPropertyName;
            obj.staticFileData     = cParams.staticFileData;
            obj.solver_type        = cParams.solver_type;
        end
        
        function obj = computeFEM(obj)
            s.staticFileData  = obj.staticFileData;
            s.solver_type     = obj.solver_type;
            Analysis = FEMcomputer(s);
            Analysis.solve();
            obj.loadedDisplacements   = Analysis.loadedDisplacements;
            obj.computedDisplacements = Analysis.displacements;
        end
        
        function testFEM(obj,s)
            s.loaded   = obj.loadedDisplacements;
            s.computed = obj.computedDisplacements;
            s.name     = obj.testedPropertyName;
            Test = TestComputer(s);
            Test.compute();
        end
        
    end
end

