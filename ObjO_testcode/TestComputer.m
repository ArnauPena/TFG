classdef TestComputer < handle
    
    properties (Access = private)
        loadedData
        computedData
        testedPropertyName
    end
    
    
    methods (Access = public)
        
        function obj = TestComputer(cParams)
            obj.init(cParams)           
        end
        
        function compute(obj)
            if obj.check()
                cprintf('comment',obj.testedPropertyName);
                cprintf('comment',' is correct!\n');
            else
                cprintf('err',obj.testedPropertyName);
                cprintf('err',' is wrong!\n');
            end
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.loadedData          = cParams.loaded;
            obj.computedData        = cParams.computed;
            obj.testedPropertyName  = cParams.name;
        end
        
        function passed = check(obj)
            maxdiff   = obj.computeMaxDifference();
            tolerance = 1e-8;
            if maxdiff > tolerance
                passed = 0;
            else
                passed = 1;
            end
        end
        
        function maxdiff = computeMaxDifference(obj)
            diff    = obj.computeDifference();
            maxdiff = max(max(diff));
        end
        
        function diff = computeDifference(obj)
            diff = abs((obj.computedData - obj.loadedData)...
                ./obj.loadedData);
        end
        
    end
    
end