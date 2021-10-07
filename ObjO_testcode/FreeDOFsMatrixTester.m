classdef FreeDOFsMatrixTester < handle
    
    properties (Access = private)
        matrix
        vector
        loadedData
        computedFreeDOFsMatrix
        data
        dim
        testedPropertyName
    end
    
    methods (Access = public)
        
        function obj = FreeDOFsMatrixTester(cParams)
            obj.init(cParams)           
        end
        
        function obj = compute(obj)
            obj.computeFreeDOFsMatrixSplit();
            obj.test();
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
            Solution = MatrixSplitterComputer(s);
            Solution.compute();
            obj.computedFreeDOFsMatrix = Solution.K.ll;
        end
        
        function test(obj)
            s.loaded   = obj.loadedData;
            s.computed = obj.computedFreeDOFsMatrix;
            s.name     = obj.testedPropertyName;
            Test = TestComputer(s);
            Test.compute();
        end
        
    end
    
end