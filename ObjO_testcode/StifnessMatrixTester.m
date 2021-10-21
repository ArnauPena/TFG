classdef StifnessMatrixTester < TestComputer
        
    properties (Access = private)
       data
       dim
    end
    
    methods (Access = public)
        
        function obj = StifnessMatrixTester(cParams)
            obj.init(cParams)           
        end
        
        function obj = compute(obj)
            obj.computeStifnessMatrix();
            obj.checkResult();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            run(cParams.staticFileData);
            load(cParams.loadedStifnessMatrix);
            obj.loadedData           = Kgt;
            obj.data                 = datav;
            obj.dim                  = dimv;
            obj.testedPropertyName   = cParams.testedPropertyName;
        end
        
        function obj = computeStifnessMatrix(obj)
            s.data   = obj.data;
            s.dim    = obj.dim;
            Solution = StifnessMatrixComputer(s);
            Solution.compute();
            obj.computedData = Solution.stifnessMatrix;
        end
        
    end
    
end