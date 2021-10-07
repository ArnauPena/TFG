classdef FreeDOFsVectorTester < handle

    properties (Access = private)
        matrix
        vector
        data
        dim
        computedFreeDOFsVector
        testedPropertyName
        loadedData
    end
    
    methods (Access = public)
        
        function obj = FreeDOFsVectorTester(cParams)
            obj.init(cParams)            
        end
        
        function obj = compute(obj)
            obj.computeFreeDOFsVectorSplit();
            obj.test();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            run(cParams.staticFileData);
            load(cParams.matrix);
            load(cParams.vector);
            load(cParams.loadedFreeDOFsVector);
            obj.matrix               = Kgt;
            obj.vector               = f;
            obj.loadedData           = Fl;
            obj.data                 = datav;
            obj.dim                  = dimv;
            obj.testedPropertyName   = cParams.testedPropertyName;            
        end
        
        function obj = computeFreeDOFsVectorSplit(obj)
            s.matrix = obj.matrix;
            s.vector = obj.vector;
            s.data   = obj.data;
            s.dim    = obj.dim;
            Solution = MatrixSplitterComputer(s);
            Solution.compute();
            obj.computedFreeDOFsVector = Solution.F.l;
        end
        
        function test(obj)
            s.loaded   = obj.loadedData;
            s.computed = obj.computedFreeDOFsVector;
            s.name     = obj.testedPropertyName;
            Test = TestComputer(s);
            Test.compute();            
        end
        
    end
    
end