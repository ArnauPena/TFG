classdef FreeDOFsMatrixTester < TestComputer
    
    properties (Access = private)
        matrix
        vector
        data
        dim
    end
    
    methods (Access = public)
        
        function obj = FreeDOFsMatrixTester(cParams)
            obj.init(cParams)           
        end
        
        function obj = compute(obj)
            obj.computeFreeDOFsMatrixSplit();
            obj.checkResult();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            run(cParams.staticFileData);
            load(cParams.matrix);
            load(cParams.vector);
            load(cParams.loadedFreeDOFsMatrix);
            obj.matrix               = Kgt;
            obj.vector               = f;
            obj.loadedData           = Kll;
            obj.data                 = datav;
            obj.dim                  = dimv;
            obj.testedPropertyName   = cParams.testedPropertyName;
        end
        
        function obj = computeFreeDOFsMatrixSplit(obj)
            s.matrix = obj.matrix;
            s.vector = obj.vector;
            s.data   = obj.data;
            s.dim    = obj.dim;
            Solution = DOFsManager(s);
            Solution.compute();
            obj.computedData = Solution.K.ll;
        end
        
    end
    
end