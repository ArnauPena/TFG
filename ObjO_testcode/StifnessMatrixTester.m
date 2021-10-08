classdef StifnessMatrixTester < handle
        
    properties (Access = private)
       data
       dim
       loadedStifnessMatrix
       computedStifnessMatrix
       testedPropertyName
    end
    
    methods (Access = public)
        
        function obj = StifnessMatrixTester(cParams)
            obj.init(cParams)           
        end
        
        function obj = compute(obj)
            obj.computeStifnessMatrix();
            obj.test();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            run(cParams.staticFileData);
            load(cParams.loadedStifnessMatrix);
            obj.loadedStifnessMatrix = Kgt;
            obj.data                 = datav;
            obj.dim                  = dimv;
            obj.testedPropertyName   = cParams.testedPropertyName;
        end
        
        function obj = computeStifnessMatrix(obj)
            s.data   = obj.data;
            s.dim    = obj.dim;
            Solution = StifnessMatrixComputer(s);
            Solution.compute();
            obj.computedStifnessMatrix = Solution.stifnessMatrix;
        end
        
        function test(obj)
            s.loaded   = obj.loadedStifnessMatrix;
            s.computed = obj.computedStifnessMatrix;
            s.name     = obj.testedPropertyName;
            Test = TestComputer(s);
            Test.compute();
        end
        
    end
    
end