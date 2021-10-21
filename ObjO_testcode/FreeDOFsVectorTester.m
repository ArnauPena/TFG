classdef FreeDOFsVectorTester < TestComputer

    properties (Access = protected)
        matrix
        vector
        data
        dim
    end
    
    methods (Access = public)
        
        function obj = FreeDOFsVectorTester(cParams)
            obj.init(cParams)            
        end
        
        function obj = compute(obj)
            obj.computeFreeDOFsVectorSplit();
            obj.checkResult();
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
            Solution = DOFsManager(s);
            Solution.compute();
            obj.computedData = Solution.F.l;
        end
        
    end
    
end